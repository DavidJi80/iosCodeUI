//
//  AGLKTextureMultiBuffer.h
//  iosCodeUI
//
//  Created by mac on 2019/7/2.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    AGLKVertexAttribPosition = GLKVertexAttribPosition,
    AGLKVertexAttribNormal = GLKVertexAttribNormal,
    AGLKVertexAttribColor = GLKVertexAttribColor,
    AGLKVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    AGLKVertexAttribTexCoord1 = GLKVertexAttribTexCoord1,
} AGLKVertexAttrib;

@interface AGLKTextureMultiBuffer : NSObject{
    GLsizei      stride;
    GLsizeiptr   bufferSizeBytes;
    GLuint       name;
}

@property (nonatomic, readonly) GLuint name;
@property (nonatomic, readonly) GLsizeiptr bufferSizeBytes;
@property (nonatomic, readonly) GLsizei stride;

+ (void)drawPreparedArraysWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count;

- (id)initWithAttribStride:(GLsizei)stride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr usage:(GLenum)usage;

- (void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count;

- (void)reinitWithAttribStride:(GLsizei)stride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr;

@end

NS_ASSUME_NONNULL_END
