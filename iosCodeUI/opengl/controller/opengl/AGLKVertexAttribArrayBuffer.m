//
//  AGLKVertexAttribArrayBuffer.m
//  iosCodeUI
//
//  Created by mac on 2019/6/28.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@interface AGLKVertexAttribArrayBuffer()

@end

@implementation AGLKVertexAttribArrayBuffer

- (id)initWithAttribStride:(GLsizei)stride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr usage:(GLenum)usage{
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    
    self = [super init];
    if (self) {
        _stride = stride;
        _bufferSizeBytes = _stride*count;
        
        glGenBuffers(1, &_glName);                                          //1、为缓存生成一个独一无二的标识符
        glBindBuffer(GL_ARRAY_BUFFER, _glName);                             //2、为接下来的应用绑定缓存
        glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, dataPtr, usage);    //3、复制数据到缓存中
        
        NSAssert(0 != _glName, @"生成唯一标识失败");
    }
    return self;
}

- (void)prepareToDrawWithAttrib:(GLint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizei)offset shouldEnable:(BOOL)shouldEnable{
    NSParameterAssert((0<count) && (count<=4));
    NSParameterAssert(offset < self.stride);
    if (shouldEnable) {
        glEnableVertexAttribArray(index);                                               //4、启动顶点缓存渲染操作
    }
    //5、告诉OpenGL ES顶点数据在哪里，以及解释为每个顶点保存的数据
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, self.stride, NULL + offset);
    
}

- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count{
    NSAssert(self.bufferSizeBytes >= (first+count)*self.stride, @"试图渲染多于可用数量的顶点");
    glDrawArrays(mode, first, count);                                                   //6、绘图
}

- (void)dealloc{
    if (0 != _glName) {
        glDeleteBuffers(1, &_glName);                                                   //7、删除不再需要的顶点缓存
        _glName = 0;
    }
}

@end
