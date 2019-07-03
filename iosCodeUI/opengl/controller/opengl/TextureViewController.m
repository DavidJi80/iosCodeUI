//
//  TextureViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/6/25.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "TextureViewController.h"

/**
 1. 把纹理坐标被加入到SceneVertex类型的声明中
 */
typedef struct {
    GLKVector3 positionCoords;  //GLKVector3类型的位置坐标（positionCoords）
    GLKVector2 textureCoords;   //GLKVector2类型的纹理坐标（textureCoords）
}SceneVertex;

/**
 2. 矩形的六个顶点
    前面三个数字是位置坐标，后面2个数字是纹理坐标
    纹理坐标定义了几何图形中的每个顶点的纹理映射
 */
static const SceneVertex vertices[] = {
    {{1, -1, 0.0f,},{1.0f,0.0f}}, //右下
    {{1, 1,  0.0f},{1.0f,1.0f}}, //右上
    {{-1, 1, 0.0f},{0.0f,1.0f}}, //左上
    
    {{1, -1, 0.0f},{1.0f,0.0f}}, //右下
    {{-1, 1, 0.0f},{0.0f,1.0f}}, //左上
    {{-1, -1, 0.0f},{0.0f,0.0f}}, //左下
};

@interface TextureViewController (){
    GLuint vertextBufferID;
}

//声明一个GLKBaseEffect属性
@property (nonatomic,strong)GLKBaseEffect *baseEffect;

@end

@implementation TextureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     OpenGLES 上下文
     */
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc]initWithAPI: kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];                                   //设置当前上下文
    
    //填充VertexArray
    [self fillTexture];
    
    //填充纹理
    [self fillVertexArray];
}

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

/**
 设置顶点缓存buffer
 */
- (void)fillVertexArray{
    glGenBuffers(1, &vertextBufferID);                                          //1. 申请一个标识符
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);                             //2. 绑定指定标识符的缓存为当前缓存
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);  //3. 复制顶点数据从CPU到GPU
    glEnableVertexAttribArray(GLKVertexAttribPosition);                         //4. 顶点数据缓存
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, positionCoords));                                 //5. 设置指针从顶点数组中读取数据
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);                        //纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, textureCoords));
}

/**
 3. 通过图片数据产生纹理缓存
 */
- (void)fillTexture{
    CGImageRef imageRef = [[UIImage imageNamed:@"Demo.jpg"] CGImage];       //获取图片
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    /**
     3.1.
     GLKTextureInfo封装了纹理缓存的信息，包括是否包含MIP贴图
     [LKTextureLoader textureWithCGImage:]
        接受一个CGImageRef并创建一个新的包含CGImageRef的像素数据的OpenGL ES纹理缓存，
        options参数接受一个存储了用于指定GLKTextureLoader怎么解析加载的图像数据的键值对的NSDictionary。
        可用选项之一是指示GLKTextureLoader为加载的图像生成MIP贴图。
     */
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:options error:NULL];
    /**
     3.2. 设置baseEffect的texture2d0属性和使用一个新的纹理缓存。
     GLKTextureInfo类封装了与刚创建的纹理缓存相关的信息，
     包含他的尺寸、是否包含MIP贴图、OpenGL ES标识符、名字以及用于纹理的OpenGL ES目标等。
     */
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

/**
 4. 绘制
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    //清除背景色
    glClearColor(0.0f,0.0f,0.0f,1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self.baseEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}


/**
 6. 释放
 */
- (void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if ( 0 != vertextBufferID) {
        glDeleteBuffers(1,&vertextBufferID);
        vertextBufferID = 0;
    }
    [EAGLContext setCurrentContext:nil];
}

@end
