//
//  ShaderTypes.h
//  StarbaseOrion10 Shared
//
//  Created by Rocco Bowling on 2/15/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

//
//  Header containing types and enum constants shared between Metal shaders and Swift/ObjC source
//
#ifndef ShaderTypes_h
#define ShaderTypes_h

#ifdef __METAL_VERSION__
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#define NSInteger metal::int32_t
#else

#import <Foundation/Foundation.h>

#include "PonyPlatform.h"
#include "HALRenderEngine.h"


#include "PonyExpressConfig.h"
#include "PonyExpressView.h"

#endif

#include <simd/simd.h>



#endif

