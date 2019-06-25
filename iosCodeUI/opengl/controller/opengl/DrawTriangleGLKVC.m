//
//  DrawTriangleGLKVC.m
//  iosCodeUI
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "DrawTriangleGLKVC.h"

/**
 4. 顶点结构体
 */
typedef struct{
    GLKVector3 positionCoords;
}sceneVertex;

/**
 5. 三角形的三个顶点
 */
static const sceneVertex vertices[] = {
    {0.f,-0.5f,0.8f},
    {0.5f,-0.5f,0.8f},
    {-0.5f,0.5f,-0.3f}
};

/**
 6. 声明缓存ID
 */
@interface DrawTriangleGLKVC (){
    GLuint vertextBufferID;
}

//2. 声明一个GLKBaseEffect属性
@property (nonatomic,strong)GLKBaseEffect *baseEffect;

@end

@implementation DrawTriangleGLKVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     1. 创建OpenGL ES上下文
     */
    GLKView *view  = (GLKView *)self.view;
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];     //创建OpenGL ES2.0上下文
    [EAGLContext setCurrentContext:view.context];                                   //设置当前上下文
    
    // Configure renderbuffers created by the view
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    
    // Enable multisampling
    view.drawableMultisample = GLKViewDrawableMultisample4X;
    
    
    /**
     6. 为缓存提供数据
     */
    glGenBuffers(1, &vertextBufferID);                                          //申请一个标识符
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);                             //将标识符绑定到当前缓存
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);  //复制顶点数据从CPU到GPU
}

/**
 3. GLKBaseEffect使我们不需要编写shader Language代码就可以简单完成图形绘制
 */
-(GLKBaseEffect *)baseEffect{
    if (!_baseEffect){
        _baseEffect= [[GLKBaseEffect alloc]init];
        _baseEffect.useConstantColor = GL_TRUE;                                 //使用静态颜色绘制
        _baseEffect.constantColor = GLKVector4Make(1.0f, 0.1f, 1.0f, 1.0f);     //设置默认绘制颜色，参数分别是 RGBA
    }
    return _baseEffect;
}

/**
 7. 委托方法应该绘制视图的内容
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    glClearColor(0.0f,0.0f,0.0f,1.0f);                  //设置背景色
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); //Clear Frame Buffer
    glEnableVertexAttribArray(GLKVertexAttribPosition); //开启对应的顶点缓存属性
    glVertexAttribPointer(GLKVertexAttribPosition,      //设置指针从顶点数组中读取数据
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(sceneVertex),
                          NULL);
    glDrawArrays(GL_TRIANGLES,0,3);                     //绘制图形

}

/**
 8. 释放缓存数据
 */
- (void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if ( 0 != vertextBufferID) {
        glDeleteBuffers(1,&vertextBufferID);    //删除缓存
        vertextBufferID = 0;
    }
    [EAGLContext setCurrentContext:nil];
    
}



@end


