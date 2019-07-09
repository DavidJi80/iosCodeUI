//
//  TextureMultiGLKVC.m
//  iosCodeUI
//
//  Created by mac on 2019/7/2.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "TextureMultiGLKVC.h"
#import "AGLKContext.h"

typedef struct{
    GLKVector3 positionCoords;  //GLKVector3类型的位置坐标
    GLKVector2 textureCoords;   //GLKVector2类型的纹理坐标
}SceneVertex;

//初始化位置坐标和纹理坐标
static const SceneVertex vertices[] = {
    {{-0.5f,-0.4f,0.0f},{0.0f,0.0f}},   //图片1的坐标，前面三个数字是位置坐标，后面2个数字是纹理坐标
    {{0.5f,-0.4f,0.0f},{1.0f,0.0f}},
    {{-0.5f,0.4f,0.0f},{0.0f,1.0f}},
    {{0.5f,0.4f,0.0},{1.0f,1.0f}},
    {{-0.1f,0.20f,0.0f},{0.0f,0.0f}},   //图片2的坐标
    {{0.1f,0.20f,0.0f},{1.0f,0.0f}},
    {{-0.1f,0.30f,0.0f},{0.0f,1.0f}},
    {{0.1f,0.30f,0.0},{1.0f,1.0f}}
    
};


@interface TextureMultiGLKVC ()

@property (nonatomic,strong)GLKTextureInfo* info;   //图片1的纹理
@property (nonatomic,strong)GLKTextureInfo* info1;  //图片2的纹理

@end

@implementation TextureMultiGLKVC


#pragma mark -  生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *view = (GLKView *)self.view;
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f,0.0f,0.0f,1.0f);
    
    /**
     1、为缓存生成一个独一无二的标识符
     2、为接下来的应用绑定缓存
     3、复制数据到缓存中
     */
    self.vertexBuffer = [[AGLKTextureMultiBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) bytes:vertices usage:GL_STATIC_DRAW];
    
    /**
     NSDictionary对象来设定选项
     设置GLKTextureLoaderOriginBottomLeft和YES为
     确保GLKTextureLoader画出的图像与UIKit坐标一致，不颠倒
     */
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil];
    CGImageRef imageRef = [[UIImage imageNamed:@"flower.jpg"] CGImage];
    /**
     接受一个CGImageRef并创建一个新的包含CGImageRef的像素数据的OpenGL ES纹理缓存，
     options参数接受一个存储了用于指定GLKTextureLoader怎么解析加载的图像数据的键值对的NSDictionary。
     可用选项之一是指示GLKTextureLoader为加载的图像生成MIP贴图。
     */
    self.info = [GLKTextureLoader textureWithCGImage:imageRef options:options error:NULL];
    //加载第二个纹理并开启与像素颜色渲染缓存的混合
    CGImageRef imageRef1 = [[UIImage imageNamed:@"honeybee"] CGImage];
    self.info1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:options error:NULL];
    
    /**
     void glEnable(GLenum cap);
     开启混合
     */
    glEnable(GL_BLEND);
    /**
     void glBlendFunc(GLenum sfactor, GLenum dfactor);
     设置混合函数
        sfactor：指定每个片元的最终颜色元素是怎样影响混合的
            GL_SRC_ALPHA：让源片的透明度元素挨个与其他的片元颜色元素相乘
        dfactor：指定目标帧缓存中已经存在的颜色是怎样影响混合的
            GL_ONE_MINUS_SRC_ALPHA：让源片元的透明度元素与在帧缓存内的正在被更新的像素的颜色元素相乘
     */
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [AGLKContext setCurrentContext:view.context];
    [EAGLContext setCurrentContext:nil];
}

#pragma mark -  懒加载
/**
 GLKBaseEffect使我们不需要编写shader Language代码就可以简单完成图形绘制
 */
-(GLKBaseEffect *)baseEffect{
    if (!_baseEffect){
        _baseEffect= [[GLKBaseEffect alloc]init];
        _baseEffect.useConstantColor = GL_TRUE;                                 //使用静态颜色绘制
        _baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);     //设置默认绘制颜色，参数分别是 RGBA
    }
    return _baseEffect;
}

#pragma mark - GLKViewDelegate
/*
 这两个方法每帧都执行一次（循环执行），执行频率与屏幕刷新率相同。
 第一次循环时，先调用“glkView”再调用“update”。
 一般，将场景数据变化放在“update”中，而渲染代码则放在“glkView”中。
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    /*
     启动顶点缓存渲染操作
     告诉OpenGL ES顶点数据在哪里，以及解释为每个顶点保存的数据
     */
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    
    /*
     启动纹理缓存渲染操作
     告诉OpenGL ES纹理数据在哪里，以及解释为每个纹理保存的数据
     */
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    

    /**
     设置baseEffect的texture2d0属性和使用一个新的纹理缓存。
     GLKTextureInfo类封装了与刚创建的纹理缓存相关的信息，
     包含他的尺寸、是否包含MIP贴图、OpenGL ES标识符、名字以及用于纹理的OpenGL ES目标等。（纹理1）
     */
    self.baseEffect.texture2d0.name = self.info.name;
    self.baseEffect.texture2d0.target = self.info.target;
    [self.baseEffect prepareToDraw];
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLE_STRIP startVertexIndex:0 numberOfVertices:4];
    
    /**
     设置baseEffect的texture2d0属性和使用一个新的纹理缓存。
     GLKTextureInfo类封装了与刚创建的纹理缓存相关的信息，
     包含他的尺寸、是否包含MIP贴图、OpenGL ES标识符、名字以及用于纹理的OpenGL ES目标等。（纹理2）
     */
    self.baseEffect.texture2d0.name = self.info1.name;
    self.baseEffect.texture2d0.target = self.info1.target;
    [self.baseEffect prepareToDraw];
    //从第5个顶点开始数4个顶点
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLE_STRIP startVertexIndex:4 numberOfVertices:4];
}



@end
