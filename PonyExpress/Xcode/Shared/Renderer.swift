//
//  Created by Rocco Bowling on 2/15/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

// Our platform independent renderer class.

import Metal
import MetalKit
import GLKit
import simd

import PonyExpress_Private

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
public class Renderer: NSObject, PonyExpressViewDelegate {
    private var metalDevice: MTLDevice!
    private var metalCommandQueue: MTLCommandQueue!
    
    private var ignoreStencilState: MTLDepthStencilState!
    private var decrementStencilState: MTLDepthStencilState!
    private var testStencilState: MTLDepthStencilState!
    private var incrementStencilState: MTLDepthStencilState!
    
    private var stencilPipelineState: MTLRenderPipelineState!
    private var flatPipelineState: MTLRenderPipelineState!
    private var texturePipelineState: MTLRenderPipelineState!
    private var sdfPipelineState: MTLRenderPipelineState!
    
    private let textureLoader:MTKTextureLoader!
    
    private var normalSamplerState: MTLSamplerState!
    private var mipmapSamplerState: MTLSamplerState!
    
    private var bundlePathCache:Dictionary<String, String>!
    private var textureCache:Dictionary<String, MTLTexture>!
    
    private var depthTexture:MTLTexture!
    
    private var sceneMatrices = SceneMatrices()
    
    private var globalUniforms = GlobalUniforms()
    
    private var sdfUniforms = SDFUniforms(edgeDistance:0.4, edgeWidth:1.0)
    private var sdfUniformsBuffer: MTLBuffer!
    
    private var projectedSize:CGSize = CGSize(width:128, height:128)
    
    private var stencilValueCount:Int = 0
    private var stencilValueMax:Int = 255
    
    private var aaplView: PonyExpressView
    
    private var getTextureLock:NSObject = NSObject()
    private var fileURLFromBundlePathLock:NSObject = NSObject()
    private var renderAheadCountLock:NSObject = NSObject()
        
    @objc public init(aaplView: PonyExpressView) {
        metalDevice = MTLCreateSystemDefaultDevice()
        metalCommandQueue = metalDevice.makeCommandQueue()
        
        //Get the framework bundle by using `Bundle(for: type(of: self))` from inside any framework class.
        //Then use the bundle to define an MTLLibrary.
        let frameworkBundle = Bundle(for: type(of: self))
        
        let defaultLibrary = (try? metalDevice.makeDefaultLibrary(bundle: frameworkBundle))!
        
        self.aaplView = aaplView
        
        // render as normal testing against the stencil buffer for masking
        if true {
            let stencilDescriptor = MTLStencilDescriptor()
            stencilDescriptor.stencilCompareFunction = .equal
            stencilDescriptor.depthStencilPassOperation = .keep
            stencilDescriptor.stencilFailureOperation = .keep
            stencilDescriptor.depthFailureOperation = .keep
            stencilDescriptor.readMask = 0xFF
            stencilDescriptor.writeMask = 0x00
            
            let depthStencilDescriptor = MTLDepthStencilDescriptor()
            depthStencilDescriptor.depthCompareFunction = .lessEqual
            depthStencilDescriptor.isDepthWriteEnabled = false
            depthStencilDescriptor.frontFaceStencil = stencilDescriptor
            depthStencilDescriptor.backFaceStencil = stencilDescriptor

            testStencilState = metalDevice.makeDepthStencilState(descriptor: depthStencilDescriptor)
        }
        
        // render to the stencil buffer, don't render to the color attachment
        if true {
            let stencilDescriptor = MTLStencilDescriptor()
            stencilDescriptor.stencilCompareFunction = .equal
            stencilDescriptor.stencilFailureOperation = .keep
            stencilDescriptor.depthFailureOperation = .keep
            stencilDescriptor.depthStencilPassOperation = .decrementClamp
            stencilDescriptor.readMask = 0x00
            stencilDescriptor.writeMask = 0xFF
            
            let depthStencilDescriptor = MTLDepthStencilDescriptor()
            depthStencilDescriptor.depthCompareFunction = .lessEqual
            depthStencilDescriptor.isDepthWriteEnabled = false
            depthStencilDescriptor.frontFaceStencil = stencilDescriptor
            depthStencilDescriptor.backFaceStencil = stencilDescriptor

            decrementStencilState = metalDevice.makeDepthStencilState(descriptor: depthStencilDescriptor)
        }
        
        // unrender from the stencil buffer, don't render to the color attachment
        if true {
            let stencilDescriptor = MTLStencilDescriptor()
            stencilDescriptor.stencilCompareFunction = .equal
            stencilDescriptor.stencilFailureOperation = .keep
            stencilDescriptor.depthFailureOperation = .keep
            stencilDescriptor.depthStencilPassOperation = .incrementClamp
            stencilDescriptor.readMask = 0x00
            stencilDescriptor.writeMask = 0xFF
            
            let depthStencilDescriptor = MTLDepthStencilDescriptor()
            depthStencilDescriptor.depthCompareFunction = .lessEqual
            depthStencilDescriptor.isDepthWriteEnabled = false
            depthStencilDescriptor.frontFaceStencil = stencilDescriptor
            depthStencilDescriptor.backFaceStencil = stencilDescriptor

            incrementStencilState = metalDevice.makeDepthStencilState(descriptor: depthStencilDescriptor)
        }
        
        // ignore stencil state: normal rendering while ignoring the stencil buffer
        if true {
            let depthStencilDescriptor = MTLDepthStencilDescriptor()
            depthStencilDescriptor.depthCompareFunction = .lessEqual
            depthStencilDescriptor.isDepthWriteEnabled = false
            depthStencilDescriptor.frontFaceStencil = nil
            depthStencilDescriptor.backFaceStencil = nil

            ignoreStencilState = metalDevice.makeDepthStencilState(descriptor: depthStencilDescriptor)
        }
        
        
        // A shader pipeline for rendering to the stencil buffer only
        if true {
            let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
            pipelineStateDescriptor.vertexFunction = defaultLibrary.makeFunction(name: "flat_vertex")
            pipelineStateDescriptor.fragmentFunction = nil
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = aaplView.metalLayer.pixelFormat
            
            pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
            pipelineStateDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
            
            stencilPipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        }

        // A "flat" shader pipeline (no texture, just geometric colors)
        if true {
            let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
            pipelineStateDescriptor.vertexFunction = defaultLibrary.makeFunction(name: "flat_vertex")
            pipelineStateDescriptor.fragmentFunction = defaultLibrary.makeFunction(name: "flat_fragment")
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = aaplView.metalLayer.pixelFormat

            pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
            pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add
            pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add
            pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
            pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
            pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
            
            pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
            pipelineStateDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
            
            flatPipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        }
        
        // A textured shader pipeline
        if true {
            let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
            pipelineStateDescriptor.vertexFunction = defaultLibrary.makeFunction(name: "textured_vertex")
            pipelineStateDescriptor.fragmentFunction = defaultLibrary.makeFunction(name: "textured_fragment")
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = aaplView.metalLayer.pixelFormat
            
            pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
            pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add
            pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add
            pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
            pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
            pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
            
            pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
            pipelineStateDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
            
            texturePipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        }
        
        // A sdf shader pipeline
        if true {
            let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
            pipelineStateDescriptor.vertexFunction = defaultLibrary.makeFunction(name: "sdf_vertex")
            pipelineStateDescriptor.fragmentFunction = defaultLibrary.makeFunction(name: "sdf_fragment")
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = aaplView.metalLayer.pixelFormat
            
            pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
            pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add
            pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add
            pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
            pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
            pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
            
            pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
            pipelineStateDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
            
            sdfPipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        }
        
        
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
        
        depthTexture = getDepthTexture(size:CGSize(width: 128, height: 128))
        
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

    public func drawableResize(_ size: CGSize, withScale scale: CGFloat, andInsets insets:CGRect) {
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
            
            RenderEngineInternal_updateBounds(nil,
                                              Float(projectedSize.width),
                                              Float(projectedSize.height),
                                              Float(insets.origin.x),
                                              Float(insets.origin.y),
                                              Float(insets.size.width),
                                              Float(insets.size.height))
            
            depthTexture = getDepthTexture(size:size)
            
            //print("\(projectedSize.width) x \(projectedSize.height)")
        }
    }
    
    public func render(to metalLayer: CAMetalLayer) {
        if let drawable = metalLayer.nextDrawable() {
            
            #if !RENDER_ON_MAIN_THREAD
            pony_register_thread()
            pony_become(pony_ctx(), platformActor)
            #endif
            
            while renderAheadCount >= RenderEngine_maxConcurrentFrames() {
                RenderEngineInternal_Poll()
            }
            
            objc_sync_enter(renderAheadCountLock)
            defer {
                objc_sync_exit(renderAheadCountLock)
            }
            
            renderAheadCount += 1
            
            // uncomment to do performance testing on layout->render sequence
            //RenderEngineInternal_updateBounds(nil, Float(projectedSize.width) + Float(arc4random() % 20), Float(projectedSize.height) + Float(arc4random() % 20))
            
            RenderEngineInternal_renderAll(nil)
            
            if RenderEngineInternal_gatherAllRenderUnitsForNextFrame(nil) == false {
                renderAheadCount -= 1
                return
            }
            
            let renderPassDescriptor = MTLRenderPassDescriptor()
            if let depthAttachment = renderPassDescriptor.depthAttachment {
                depthAttachment.texture = depthTexture
                depthAttachment.clearDepth = 1.0
                depthAttachment.storeAction = .dontCare
                depthAttachment.loadAction = .clear
                
                if let stencilAttachment = renderPassDescriptor.stencilAttachment {
                    stencilAttachment.texture = depthAttachment.texture
                    stencilAttachment.storeAction = .dontCare
                    stencilAttachment.loadAction = .clear
                    stencilAttachment.clearStencil = 255
                }
            }
                
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
            
            stencilValueCount = stencilValueMax
            renderEncoder.setStencilReferenceValue(UInt32(stencilValueCount))
            renderEncoder.setDepthStencilState(ignoreStencilState)
            
            var aborted = false
            
            while let unitPtr = RenderEngineInternal_nextRenderUnit(nil) {
                let unit = unitPtr.pointee
                let shaderType = unit.shaderType
                
                if unit.textureName != nil {
                    renderEncoder.setFragmentTexture(getTexture(namePtr: unit.textureName), index: 0)
                }
                
                if stencilValueCount == stencilValueMax {
                    renderEncoder.setDepthStencilState(ignoreStencilState)
                } else {
                    renderEncoder.setDepthStencilState(testStencilState)
                }
                
                if shaderType == ShaderType_Abort {
                    aborted = true
                }
                    
                if shaderType == ShaderType_Flat {
                    renderEncoder.setRenderPipelineState(flatPipelineState)
                    renderEncoder.setFragmentSamplerState(normalSamplerState, index:0)
                } else if shaderType == ShaderType_Textured {
                    renderEncoder.setRenderPipelineState(texturePipelineState)
                    renderEncoder.setFragmentSamplerState(normalSamplerState, index:0)
                } else if shaderType == ShaderType_SDF {
                    renderEncoder.setRenderPipelineState(sdfPipelineState)
                    renderEncoder.setFragmentSamplerState(mipmapSamplerState, index:0)
                } else if shaderType == ShaderType_Stencil_Begin {
                    renderEncoder.setDepthStencilState(decrementStencilState)
                    renderEncoder.setRenderPipelineState(stencilPipelineState)
                    renderEncoder.setFragmentSamplerState(normalSamplerState, index:0)
                } else if shaderType == ShaderType_Stencil_End {
                    renderEncoder.setDepthStencilState(incrementStencilState)
                    renderEncoder.setRenderPipelineState(stencilPipelineState)
                    renderEncoder.setFragmentSamplerState(normalSamplerState, index:0)
                }
                
                if unit.vertices != nil && unit.bytes_vertices != 0 && unit.num_vertices != 0 {
                    drawRenderUnit(renderEncoder, unit)
                }
                
                if shaderType == ShaderType_Stencil_Begin {
                    stencilValueCount = max(stencilValueCount - 1, 0)
                    renderEncoder.setStencilReferenceValue(UInt32(stencilValueCount))
                }
                if shaderType == ShaderType_Stencil_End {
                    stencilValueCount = min(stencilValueCount + 1, stencilValueMax)
                    renderEncoder.setStencilReferenceValue(UInt32(stencilValueCount))
                }
            }
            RenderEngineInternal_frameFinished(nil)
            
            renderEncoder.endEncoding()
            
            commandBuffer.addCompletedHandler { (buffer) in
                objc_sync_enter(self.renderAheadCountLock)
                self.renderAheadCount -= 1
                objc_sync_exit(self.renderAheadCountLock)
            }
            
            if aborted == false {
                commandBuffer.present(drawable)
            }
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
            
            
            // TODO: replace this with setBlendColor(red: Float, green: Float, blue: Float, alpha: Float)????
            
            renderEncoder.setVertexBytes(&globalUniforms, length: MemoryLayout<GlobalUniforms>.stride, index: 2)
        }
        
        if unit.bytes_vertices < 4096 {
            renderEncoder.setVertexBytes(unit.vertices, length: Int(unit.bytes_vertices), index: 0)
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: Int(unit.num_vertices))
            RenderEngine_release(unit.vertices, unit.size_vertices_array)
        }else{
            vertexBuffer = metalDevice.makeBuffer(bytesNoCopy: unit.vertices,
                                                  length: Int(unit.bytes_vertices),
                                                  options: [ .storageModeShared ],
                                                  deallocator: { (pointer: UnsafeMutableRawPointer, _: Int) in
                                                    RenderEngine_release(unit.vertices, unit.size_vertices_array)
                                                })
            if vertexBuffer != nil {
                renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
                renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: Int(unit.num_vertices))
            }else{
                print("vertexBuffer is nil: \(unit.bytes_vertices) bytes for \(unit.num_vertices) vertices")
                RenderEngine_release(unit.vertices, unit.size_vertices_array)
            }
        }
        
        
    }
    
    func getDepthTexture(size:CGSize) -> MTLTexture {
        
        var textureWidth:Int = 128
        var textureHeight:Int = 128
        
        if size.width > 0 {
            textureWidth = Int(size.width)
        }
        if size.height > 0 {
            textureHeight = Int(size.height)
        }
        
        let desc = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .depth32Float_stencil8,
            width: textureWidth, height: textureHeight, mipmapped: false)
        desc.storageMode = .private
        desc.usage = .renderTarget
        return metalDevice.makeTexture(descriptor: desc)!
    }
    
    func getTexture(namePtr: UnsafePointer<Int8>?) -> MTLTexture? {
        // attempt to get it from cache first, if not load it then cache it
        if let namePtr = namePtr {
            let name = String(cString: namePtr)
            let resolvedName = fileURLFromBundlePath(name)
                        
            // This doesn't like being multi-threaded, because we use dictionary cache. So lock and then check again before loading
            objc_sync_enter(getTextureLock)
            defer {
                objc_sync_exit(getTextureLock)
            }
            
            var texture = textureCache[resolvedName]
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
        
        // This doesn't like being multi-threaded, because we use dictionary cache. So lock and then check again before loading
        objc_sync_enter(fileURLFromBundlePathLock)
        defer {
            objc_sync_exit(fileURLFromBundlePathLock)
        }
        
        let cachedPath = bundlePathCache[bundlePath]
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
