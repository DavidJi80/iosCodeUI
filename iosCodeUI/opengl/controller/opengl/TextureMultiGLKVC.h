//
//  TextureMultiGLKVC.h
//  iosCodeUI
//
//  Created by mac on 2019/7/2.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "AGLKTextureMultiBuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextureMultiGLKVC : GLKViewController

@property (nonatomic,strong) GLKBaseEffect *baseEffect;
@property (nonatomic,strong) AGLKTextureMultiBuffer *vertexBuffer;

@end

NS_ASSUME_NONNULL_END
