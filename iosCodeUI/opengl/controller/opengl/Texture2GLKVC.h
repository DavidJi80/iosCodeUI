//
//  Texture2GLKVC.h
//  iosCodeUI
//
//  Created by mac on 2019/6/28.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <GLKit/GLKit.h>
@class AGLKVertexAttribArrayBuffer;

NS_ASSUME_NONNULL_BEGIN

@interface Texture2GLKVC : GLKViewController

@property (nonatomic,strong) GLKBaseEffect *baseEffect;
@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@end

NS_ASSUME_NONNULL_END
