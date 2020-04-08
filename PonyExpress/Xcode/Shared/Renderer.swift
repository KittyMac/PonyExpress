//
//  Created by Rocco Bowling on 2/15/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

// Our platform independent renderer class.

import Metal
import MetalKit
import GLKit
import simd

import ponyexpress

struct SceneMatrices {
    var projectionMatrix: GLKMatrix4 = GLKMatrix4Identity
    var modelviewMatrix: GLKMatrix4 = GLKMatrix4Identity
}

struct GlobalUniforms {
    var globalColor: GLKVector4 = GLKVector4Make(1.0, 1.0, 1.0, 1.0)
}

struct SDFUniforms {
    var edgeDistance:Float
    var edgeWidth:Float
}

func bridge(_ obj : Renderer) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

func bridge(_ ptr : UnsafeMutableRawPointer) -> Renderer? {
    return Unmanaged.fromOpaque(ptr).takeUnretainedValue()
}

// Minimal Metal Renderer
class Renderer: NSObject, PonyExpressViewDelegate {
    private var metalDevice: MTLDevice!
    private var metalCommandQueue: MTLCommandQueue!
    private var flatPipelineState: MTLRenderPipelineState!
    private var texturePipelineState: MTLRenderPipelineState!
    private var sdfPipelineState: MTLRenderPipelineState!
    
    private let textureLoader:MTKTextureLoader!
    
    private var normalSamplerState: MTLSamplerState!
    private var mipmapSamplerState: MTLSamplerState!
    
    private var bundlePathCache:Dictionary<String, String>!
    private var textureCache:Dictionary<String, MTLTexture>!
    
    private var sceneMatrices = SceneMatrices()
    
    private var globalUniforms = GlobalUniforms()
    
    private var sdfUniforms = SDFUniforms(edgeDistance:0.4, edgeWidth:1.0)
    private var sdfUniformsBuffer: MTLBuffer!
    
    private var projectedSize:CGSize = CGSize.zero
    
    private var aaplView: PonyExpressView
        
    @objc init(aaplView: PonyExpressView) {
        metalDevice = MTLCreateSystemDefaultDevice()
        metalCommandQueue = metalDevice.makeCommandQueue()

        let defaultLibrary = metalDevice.makeDefaultLibrary()!
        
        self.aaplView = aaplView

        // A "flat" shader pipeline (no texture, just geometric colors)
        let flatPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        flatPipelineStateDescriptor.vertexFunction = defaultLibrary.makeFunction(name: "flat_vertex")
        flatPipelineStateDescriptor.fragmentFunction = defaultLibrary.makeFunction(name: "flat_fragment")
        flatPipelineStateDescriptor.colorAttachments[0].pixelFormat = aaplView.metalLayer.pixelFormat

        flatPipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
        flatPipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add
        flatPipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add
        flatPipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        flatPipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        flatPipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        flatPipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        flatPipelineState = try! metalDevice.makeRenderPipelineState(descriptor: flatPipelineStateDescriptor)
        
        // A textured shader pipeline
        let texturePipelineStateDescriptor = MTLRenderPipelineDescriptor()
        texturePipelineStateDescriptor.vertexFunction = defaultLibrary.makeFunction(name: "textured_vertex")
        texturePipelineStateDescriptor.fragmentFunction = defaultLibrary.makeFunction(name: "textured_fragment")
        texturePipelineStateDescriptor.colorAttachments[0].pixelFormat = aaplView.metalLayer.pixelFormat
        
        texturePipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
        texturePipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add
        texturePipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add
        texturePipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        texturePipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        texturePipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        texturePipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        texturePipelineState = try! metalDevice.makeRenderPipelineState(descriptor: texturePipelineStateDescriptor)
        
        // A sdf shader pipeline
        let sdfPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        sdfPipelineStateDescriptor.vertexFunction = defaultLibrary.makeFunction(name: "sdf_vertex")
        sdfPipelineStateDescriptor.fragmentFunction = defaultLibrary.makeFunction(name: "sdf_fragment")
        sdfPipelineStateDescriptor.colorAttachments[0].pixelFormat = aaplView.metalLayer.pixelFormat
        
        sdfPipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
        sdfPipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add
        sdfPipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add
        sdfPipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        sdfPipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        sdfPipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        sdfPipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        sdfPipelineState = try! metalDevice.makeRenderPipelineState(descriptor: sdfPipelineStateDescriptor)
        
        
        // do not interpolate between mipmaps
        let normalSamplerDesc = MTLSamplerDescriptor()
        normalSamplerDesc.sAddressMode = .clampToEdge
        normalSamplerDesc.tAddressMode = .clampToEdge
        normalSamplerDesc.minFilter = .linear
        normalSamplerDesc.magFilter = .linear
        normalSamplerDesc.mipFilter = .notMipmapped
        normalSamplerState = metalDevice.makeSamplerState(descriptor: normalSamplerDesc)
        
        // interpolate between mipmaps
        let mipmapSamplerDesc = MTLSamplerDescriptor()
        mipmapSamplerDesc.sAddressMode = .clampToEdge
        mipmapSamplerDesc.tAddressMode = .clampToEdge
        mipmapSamplerDesc.minFilter = .linear
        mipmapSamplerDesc.magFilter = .linear
        mipmapSamplerDesc.mipFilter = .linear
        mipmapSamplerState = metalDevice.makeSamplerState(descriptor: mipmapSamplerDesc)
        
        textureLoader = MTKTextureLoader(device: metalDevice)
        
        bundlePathCache = Dictionary<String, String>()
        textureCache = Dictionary<String, MTLTexture>()
                
        super.init()
        
        aaplView.delegate = self
        
        RenderEngineInternal_registerAPICallbacks(nil,
                                                  bridge(self),
                                                  { (observer, namePtr, widthPtr, heightPtr) -> Void in
                                                        let mySelf = Unmanaged<Renderer>.fromOpaque(observer!).takeUnretainedValue()
                                                    if let texture = mySelf.getTexture(namePtr: namePtr) {
                                                            if let widthPtr = widthPtr {
                                                                widthPtr.initialize(to: Float(texture.width))
                                                            }
                                                            if let heightPtr = heightPtr {
                                                                heightPtr.initialize(to: Float(texture.height))
                                                            }
                                                        }
                                                    }
        )
    }
    
    private var lastFramesTime: CFAbsoluteTime = 0.0
    var numFrames:Int = 0
    
    var renderAheadCount:Int = 0

    func drawableResize(_ size: CGSize, withScale scale: CGFloat) {
        var local_size = size
                
        if (scale != 0.0) {
            local_size.width /= scale
            local_size.height /= scale
        }
                
        if local_size != projectedSize {
            projectedSize = local_size
            
            let aspect = fabsf(Float(projectedSize.width) / Float(projectedSize.height))
            
            // calculate the field of view such that at a given depth we
            // match the size of the window exactly
            var radtheta:Float = 0.0
            let distance:Float = 500.0
            
            radtheta = 2.0 * atan2( Float(projectedSize.height) / 2.0, distance );
            
            let projectionMatrix = GLKMatrix4MakePerspective(
              radtheta,
              aspect,
              1.0,
              distance * 10.0)
            sceneMatrices.projectionMatrix = projectionMatrix
            
            RenderEngineInternal_updateBounds(nil, Float(projectedSize.width), Float(projectedSize.height))
            
            //print("\(projectedSize.width) x \(projectedSize.height)")
        }
    }
    
    func render(to metalLayer: CAMetalLayer) {
        if let drawable = metalLayer.nextDrawable() {
            #if !RENDER_ON_MAIN_THREAD
            pony_register_thread()
            pony_become(pony_ctx(), platformActor)
            #endif
            
            while renderAheadCount >= RenderEngine_maxConcurrentFrames() {
                RenderEngineInternal_Poll()
            }
            
            renderAheadCount += 1
            
            // uncomment to do performance testing on layout->render sequence
            RenderEngineInternal_updateBounds(nil, Float(projectedSize.width) + Float(arc4random() % 20), Float(projectedSize.height) + Float(arc4random() % 20))
            
            RenderEngineInternal_renderAll(nil)
                    
            if RenderEngineInternal_gatherAllRenderUnitsForNextFrame(nil) == false {
                renderAheadCount -= 1
                return
            }
            
            let renderPassDescriptor = MTLRenderPassDescriptor()
            renderPassDescriptor.colorAttachments[0].texture = drawable.texture
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            
            guard let commandBuffer = metalCommandQueue.makeCommandBuffer() else {
                renderAheadCount -= 1
                return
            }
            
            guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
                renderAheadCount -= 1
                return
            }

            // define the modelview and projection matrics and make them
            // available to the shaders
            var modelViewMatrix = GLKMatrix4Identity
            modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, Float(projectedSize.width * -0.5), Float(projectedSize.height * 0.5), -500.0)
            modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, Float.pi)
            sceneMatrices.modelviewMatrix = modelViewMatrix
            
            renderEncoder.setVertexBytes(&sceneMatrices, length: MemoryLayout<SceneMatrices>.stride, index: 1)
            
            renderEncoder.setFragmentBytes(&sdfUniforms, length: MemoryLayout<SDFUniforms>.stride, index: 0)
            
            globalUniforms.globalColor.r = -99
            globalUniforms.globalColor.g = -999
            globalUniforms.globalColor.b = -9999
            globalUniforms.globalColor.a = -99999
            
            var lastShaderType:UInt32 = 0
            while let unitPtr = RenderEngineInternal_nextRenderUnit(nil) {
                let unit = unitPtr.pointee
                
                if unit.vertices == nil || unit.bytes_vertices == 0 || unit.num_vertices == 0 {
                    continue
                }
                
                if unit.textureName != nil {
                    renderEncoder.setFragmentTexture(getTexture(namePtr: unit.textureName), index: 0)
                }
                                
                if lastShaderType != unit.shaderType {
                    lastShaderType = unit.shaderType
                    
                    if lastShaderType == ShaderType_Flat {
                        renderEncoder.setRenderPipelineState(flatPipelineState)
                        renderEncoder.setFragmentSamplerState(normalSamplerState, index:0)
                    } else if lastShaderType == ShaderType_Textured {
                        renderEncoder.setRenderPipelineState(texturePipelineState)
                        renderEncoder.setFragmentSamplerState(normalSamplerState, index:0)
                    } else if lastShaderType == ShaderType_SDF {
                        renderEncoder.setRenderPipelineState(sdfPipelineState)
                        renderEncoder.setFragmentSamplerState(mipmapSamplerState, index:0)
                   }
                }
                
                drawRenderUnit(renderEncoder, unit)
            }
            RenderEngineInternal_frameFinished(nil)
            
            renderEncoder.endEncoding()
            
            commandBuffer.addCompletedHandler { (buffer) in
                self.renderAheadCount -= 1
            }
            
            commandBuffer.present(drawable)
            commandBuffer.commit()
            //commandBuffer.waitUntilScheduled()
            
            // Simple FPS so we can compare performance
            numFrames = numFrames + 1
            
            let currentTime = CFAbsoluteTimeGetCurrent()
            let elapsedTime = currentTime - lastFramesTime
            if elapsedTime > 1.0 {
                print("\(numFrames) fps")
                numFrames = 0
                lastFramesTime = currentTime
            }
        }
    }
    
    func drawRenderUnit(_ renderEncoder:MTLRenderCommandEncoder, _ unit:RenderUnit) {
        var vertexBuffer: MTLBuffer!
        
        if  globalUniforms.globalColor.r != unit.globalR ||
            globalUniforms.globalColor.g != unit.globalG ||
            globalUniforms.globalColor.b != unit.globalB ||
            globalUniforms.globalColor.a != unit.globalA {
            
            globalUniforms.globalColor.r = unit.globalR
            globalUniforms.globalColor.g = unit.globalG
            globalUniforms.globalColor.b = unit.globalB
            globalUniforms.globalColor.a = unit.globalA
            
            renderEncoder.setVertexBytes(&globalUniforms, length: MemoryLayout<GlobalUniforms>.stride, index: 2)
        }
        
        if unit.bytes_vertices < 4096 {
            renderEncoder.setVertexBytes(unit.vertices, length: Int(unit.bytes_vertices), index: 0)
        }else{
            vertexBuffer = metalDevice.makeBuffer(bytesNoCopy: unit.vertices,
                                                  length: Int(unit.bytes_vertices),
                                                  options: [],
                                                  deallocator: { (pointer: UnsafeMutableRawPointer, _: Int) in
                                                    RenderEngine_release(unit.vertices, unit.size_vertices_array)
                                                })
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        }
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: Int(unit.num_vertices))
    }
    
    
    func getTexture(namePtr: UnsafePointer<Int8>?) -> MTLTexture? {
        // attempt to get it from cache first, if not load it then cache it
        if let namePtr = namePtr {
            let name = String(cString: namePtr)
            let resolvedName = fileURLFromBundlePath(name)
            
            // return quickly without locking if we can...
            var texture:MTLTexture? = textureCache[resolvedName]
            if texture != nil {
                return texture
            }
            
            // If not, MTKTextureLoader doesn't like being multi-threaded. So lock and then check again before loading
            objc_sync_enter(self)
            defer {
                objc_sync_exit(self)
            }
            
            texture = textureCache[resolvedName]
            if texture != nil {
                return texture
            }
            
            
            let textureLoaderOptions = [
                MTKTextureLoader.Option.textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue),
                MTKTextureLoader.Option.textureStorageMode: NSNumber(value: MTLStorageMode.`private`.rawValue),
                MTKTextureLoader.Option.SRGB: NSNumber(value: false),
                MTKTextureLoader.Option.generateMipmaps: NSNumber(value: true)
            ]
            do {
                texture = try textureLoader.newTexture(URL: URL(fileURLWithPath: resolvedName), options: textureLoaderOptions)
                textureCache[resolvedName] = texture
                return texture
            } catch {
                print("Texture failed to load: \(error)")
            }
        }
        return nil
    }
    
    func fileURLFromBundlePath(_ bundlePath:String) -> String {
        // name is a "url path" to a file.  These are like in planet:
        // "resources://landscape_desert.jpg"
        // "documents://landscape_desert.jpg"
        // "caches://landscape_desert.jpg"
        
        var cachedPath = bundlePathCache[bundlePath]
        if cachedPath != nil {
            return cachedPath!
        }
        
        // If not, this doesn't like being multi-threaded. So lock and then check again before loading
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        cachedPath = bundlePathCache[bundlePath]
        if cachedPath != nil {
            return cachedPath!
        }
        
        let pathComponents = bundlePath.components(separatedBy: ":/")
        var pathString = bundlePath
        
        switch pathComponents[0] {
        case "assets":
            if let resourcePath = Bundle.main.resourcePath {
                pathString = "\(resourcePath)/Assets/\(pathComponents[1])"
            }
        case "documents":
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            pathString = "\(documentsPath)/\(pathComponents[1])"
        case "caches":
            let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            pathString = "\(cachePath)/\(pathComponents[1])"
        default:
            // we default to resources:// and ".png" so that things like "imagename" are easy and possible
            if let resourcePath = Bundle.main.resourcePath {
                let ext = (bundlePath as NSString).pathExtension
                if ext.count == 0 {
                    pathString = "\(resourcePath)/Assets/\(bundlePath).png"
                }else{
                    pathString = "\(resourcePath)/Assets/\(bundlePath)"
                }
            }
        }
        
        bundlePathCache[bundlePath] = pathString
        
        return pathString
    }
}
