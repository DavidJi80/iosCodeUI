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
 SceneVertex是一个C结构体，用来保存一个GLKVector3类型的成员positionCoords。
 GLKit的GLKVector3类型保存了3个坐标：X、Y和Z。
 */
typedef struct{
    GLKVector3 positionCoords;
}SceneVertex;

/**
 5. 三角形的三个顶点
 vertices变量是一个用顶点数据初始化的普通C数组，这个变量用来定义一个三角形。
 */
static const SceneVertex vertices[] = {
    {0.f,-0.5f,0.8f},   //lower left corner
    {0.5f,-0.5f,0.8f},  //lower right corner
    {-0.5f,0.5f,-0.3f}  //upper left corner
};

/**
 6. 声明缓存ID
 */
@interface DrawTriangleGLKVC (){
    GLuint vertextBufferID;     //vertexBufferID变量保存了用于盛放顶点数据的缓存的OpenGL ES标识符
}

/**
 2. 声明一个GLKBaseEffect属性
 baseEffect属性声明了一个GLKBaseEffect实例的指针。
 GLKBaseEffect是GLKit提供的另一个内建类。
 GLKBaseEffect的存在是为了简化OpenGL ES的很多常用的操作。
 GLKBaseEffect隐藏了iOS设备支持的多了OpenGL ES版本间的差异。
 在应用中使用GLKBaseEffect能减少需要编写的代码量。
 */
@property (nonatomic,strong)GLKBaseEffect *baseEffect;

@end

@implementation DrawTriangleGLKVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     1. 创建OpenGL ES上下文
     */
    GLKView *view  = (GLKView *)self.view;
    //使用NSAssert()函数的一个运行时检查会验证self.view是否为正确的类型
    NSAssert([view isKindOfClass:[GLKView class]], @"viewcontroller’s view is not a GLKView");
    //分配一个新的EAGLContext的实例，并将它初始化为OpenGL ES 2.0
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //在任何其他的OpenGL ES配置或者渲染之前，应用的GLKview实例的上下文属性都要设置为当前
    [EAGLContext setCurrentContext:view.context];
    
    // Configure renderbuffers created by the view
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    
    // Enable multisampling
    view.drawableMultisample = GLKViewDrawableMultisample4X;
    
    
    /**
     6. 为缓存提供数据
     */
    /**
     void glGenBuffers(GLsizei n, GLuint *buffers);
     为缓存生成一个独一无二的标识符
        参数1: 指定要生成的缓存标识符的数量
        参数2: 是一个指针，指向生成的标识符的内存位置
     */
    glGenBuffers(1,&vertextBufferID);
    /**
     void glBindBuffer(GLenum target, GLuint buffer);
     将标识符绑定到当前缓存，为接下来的运算绑定缓存
        参数1：用于指定要绑定那一种类型的缓存，
                OPenGL ES2.0对于glbindBuffer()的实现只支持两种类型的缓存
                GL_ARRAY_BUFFER：顶点缓冲区对象
                GL_ELEMENT_ARRAY_BUFFER：顶点索引缓冲区对象
        参数2：要绑定缓存的标识符
     */
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);
    /**
     void glBufferData(GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage);
     复制顶点数据到当前上下文所绑定的顶点缓存中
         参数1：指定要更新当前上下文中所绑定的是哪一种缓存
         参数2：指定要复制这个缓存字节的数量
         参数3：复制的字节的地址
         参数4：缓存在未来的运算中可能将会被怎样使用
                GL_STATIC_DRAW：提示会告诉上下文，缓存中的内容适合复制到GPU控制的内存，因为很少对其修改
                GL_DYNAMIC_DRAW：会告诉上下文，缓存内的数据会频繁改变，同时提示OpenGL ES以不同的方式来处理缓存的存储
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
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
    /**
     void glEnableVertexAttribArray(GLuint index);
     启动，通过glEnableVertexAttribArray()来启动顶点缓存渲染操作。
     OpenGL ES 所支持的每一个渲染操作都可以单独的使用保存在当前OpenGL ES上下文中的设置来开启或关闭。
     */
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    /**
     void glVertexAttribPointer(GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid *ptr);
     设置指针。glVertexAttribPointer()函数会告诉OpenGL ES顶点数据在哪里，以及怎么解释为每个顶点保存的数据。
         参数1：指示当前绑定的缓存包含每个顶点的位置信息
         参数2：指示每个位置有三个部分
         参数3：告诉OpenGL ES每个部分都保存为一个浮点类型的值
         参数4：告诉OPenGL ES小数点固定数据是否可以被改变
         参数5：叫做步幅，他指定了每个顶点的保存需要多少个字节
         参数6：告诉OpenGL ES可以从当前绑定的顶点缓存的位置访问顶点数据
     */
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex),
                          NULL);
    /**
     void glDrawArrays(GLenum mode, GLint first, GLsizei count);
     绘图。通过调用glDrawArrays()来执行绘图。
         参数1：告诉GPU怎么处理在绑定的顶点缓存内的顶点数据
            GL_POINTS ：把每一个顶点作为一个点进行处理，顶点n即定义了点n，共绘制N个点
            GL_LINES ：把每一个顶点作为一个独立的线段，顶点2n－1和2n之间共定义了n条线段，总共绘制N/2条线段
            GL_LINE_LOOP：绘制从第一个顶点到最后一个顶点依次相连的一组线段，然后最后一个顶点和第一个顶点相连，
                    第n和n+1个顶点定义了线段n，总共绘制n条线段
            GL_LINE_STRIP：绘制从第一个顶点到最后一个顶点依次相连的一组线段，第n和n+1个顶点定义了线段n，总共绘制n－1条线段
            GL_TRIANGLES：把每个顶点作为一个独立的三角形，顶点3n－2、3n－1和3n定义了第n个三角形，总共绘制N/3个三角形
            GL_TRIANGLE_STRIP：绘制一组相连的四边形。每个四边形是由一对顶点及其后给定的一对顶点共同确定的。
                    顶点2n－1、2n、2n+2和2n+1定义了第n个四边形，总共绘制N/2-1个四边形
            GL_TRIANGLE_FAN ：绘制一组相连的三角形，三角形是  由第一个顶点及其后给定的顶点确定，
                    顶点1、n+1和n+2定义了第n个三角形，总共绘制N-2个三角形
         参数2：需要渲染的第一个顶点
         参数3：需要渲染的顶点的个数
     */
    glDrawArrays(GL_TRIANGLES,0,3);
}

/**
 8. 释放缓存数据
 */
- (void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if ( 0 != vertextBufferID) {
        /**
         void glDeleteBuffers(GLsizei n, const GLuint *buffers);
         删除不再需要的顶点缓存和上下文
         */
        glDeleteBuffers(1,&vertextBufferID);    //删除缓存
        vertextBufferID = 0;
    }
    [EAGLContext setCurrentContext:nil];
}



@end


