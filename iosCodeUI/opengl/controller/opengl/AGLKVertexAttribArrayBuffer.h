//
//  AGLKVertexAttribArrayBuffer.h
//  iosCodeUI
//
//  Created by mac on 2019/6/28.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGLKVertexAttribArrayBuffer : NSObject

@property (nonatomic,readonly) GLsizei stride;              //顶点数组单个元素缓存字节的数量额
@property (nonatomic,readonly) GLsizeiptr bufferSizeBytes;  //指定要复制这个缓存字节的数量
@property (nonatomic,readonly) GLuint glName;               //保存了用于盛放本例中用到的顶点数据的缓存的OpenGl ES标识符

//下面的实现在三个方法中封装了7个缓存管理步骤
- (id)initWithAttribStride:(GLsizei)stride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr usage:(GLenum)usage;

- (void)prepareToDrawWithAttrib:(GLint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizei)offset shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count;

@end

NS_ASSUME_NONNULL_END
