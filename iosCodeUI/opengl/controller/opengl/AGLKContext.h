//
//  AGLKContext.h
//  iosCodeUI
//
//  Created by mac on 2019/6/28.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGLKContext : EAGLContext{
    GLKVector4 _clearColor;
}

@property (nonatomic,assign)GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;
- (void)enable:(GLenum)capability;
- (void)disable:(GLenum)capability;
- (void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor;

@end

NS_ASSUME_NONNULL_END
