//
//  TextureSamplingGLKVC.m
//  iosCodeUI
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 季舟. All rights reserved.
//
#import "TextureSamplingGLKVC.h"

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoord;
}SceneVertex;

//顶点
static SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

//默认顶点
static const SceneVertex defaultVertices[] = {
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

//move结构体
static GLKVector3 movementVectors[3] = {
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};

@interface TextureSamplingGLKVC () {
    GLuint vertextBufferID;
}

@property (nonatomic,strong)GLKBaseEffect *baseEffect;
@property (nonatomic,assign) GLfloat sCoordinateOffset; //顶点s坐标的offset
@property (nonatomic,assign) BOOL shouldAnimate;        //是否开启动画
@property (nonatomic,assign) BOOL shouldRepeatTexture;  //是否重复纹理
@property (nonatomic,assign) BOOL shouldUseLineFilter;  //是否使用线性过滤器

@property(nonatomic,strong) UISlider * slider;
@property(nonatomic,strong) UISwitch * switchAnimation;
@property(nonatomic,strong) UILabel * labelAnimation;
@property(nonatomic,strong) UISwitch * switchRepeat;
@property(nonatomic,strong) UILabel * labelRepeat;
@property(nonatomic,strong) UISwitch * switchLinear;
@property(nonatomic,strong) UILabel * labelLinear;

@end

@implementation TextureSamplingGLKVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGLKit];
    [self intiView];
}

- (void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if ( 0 != vertextBufferID) {
        glDeleteBuffers(1,&vertextBufferID);
        vertextBufferID = 0;
    }
    [EAGLContext setCurrentContext:nil];
}

-(void)intiView{
    self.preferredFramesPerSecond = 60;
    self.shouldAnimate = YES;
    self.shouldRepeatTexture = YES;
    self.shouldUseLineFilter = NO;
    
    _slider=[UISlider new];
    _slider.frame=CGRectMake(20, SCREEN_HEIGHT-80, SCREEN_WIDTH-40, 20);
    _slider.maximumValue=100.0;
    _slider.minimumValue=0.0;
    _slider.value=50;
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    _switchAnimation=[UISwitch new];
    _switchAnimation.frame=CGRectMake(20, SCREEN_HEIGHT-120, 40, 20);
    [_switchAnimation addTarget:self action:@selector(switchAnimationChanged:) forControlEvents:UIControlEventTouchUpInside];
    [_switchAnimation setOn:self.shouldAnimate];
    [self.view addSubview:self.switchAnimation];
    
    _labelAnimation=[UILabel new];
    _labelAnimation.frame=CGRectMake(75, SCREEN_HEIGHT-115, 80, 20);
    _labelAnimation.text=@"Animation";
    _labelAnimation.textColor=[UIColor whiteColor];
    [self.view addSubview:self.labelAnimation];
    
    _switchRepeat=[UISwitch new];
    _switchRepeat.frame=CGRectMake(180, SCREEN_HEIGHT-120, 40, 20);
    [_switchRepeat addTarget:self action:@selector(switchRepeatChanged:) forControlEvents:UIControlEventTouchUpInside];
    [_switchRepeat setOn:self.shouldRepeatTexture];
    [self.view addSubview:self.switchRepeat];
    
    _labelRepeat=[UILabel new];
    _labelRepeat.frame=CGRectMake(235, SCREEN_HEIGHT-115, 130, 20);
    _labelRepeat.text=@"Repeat Texture";
    _labelRepeat.textColor=[UIColor whiteColor];
    [self.view addSubview:self.labelRepeat];
    
    _switchLinear=[UISwitch new];
    _switchLinear.frame=CGRectMake(20, SCREEN_HEIGHT-160, 40, 20);
    [_switchLinear addTarget:self action:@selector(switchLinearChanged:) forControlEvents:UIControlEventTouchUpInside];
    [_switchLinear setOn:self.shouldUseLineFilter];
    [self.view addSubview:self.switchLinear];
    
    _labelLinear=[UILabel new];
    _labelLinear.frame=CGRectMake(75, SCREEN_HEIGHT-155, 130, 20);
    _labelLinear.text=@"Linear Filter";
    _labelLinear.textColor=[UIColor whiteColor];
    [self.view addSubview:self.labelLinear];
}

-(void)sliderValueChanged:(UISlider *)slider{
    self.sCoordinateOffset = [slider value];
}

- (void)switchAnimationChanged:(UISwitch *)sender {
    self.shouldAnimate = [sender isOn];
}

- (void)switchRepeatChanged:(UISwitch *)sender {
    self.shouldRepeatTexture = [sender isOn];
}

- (void)switchLinearChanged:(UISwitch *)sender {
    self.shouldUseLineFilter = [sender isOn];
}

#pragma mark -- GLKit

-(void)initGLKit{
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's is not a GLKView");
    
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    //顶点缓存和纹理
    [self loadVertexBuffer];
    [self loadTexture];
}


- (void)loadVertexBuffer{
    glGenBuffers(1, &vertextBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
}


- (void)loadTexture{
    //绑定图片纹理
    CGImageRef imageRef = [[UIImage imageNamed:@"grid.png"] CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

#pragma mark -- 懒加载
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

#pragma mark -- GLKViewDelegate
/*
 更新动画顶点位置
 */
- (void)updateAnimateVertexPositions{
    if (_shouldAnimate) {
        for (int i = 0; i < 3; i++) {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if (vertices[i].positionCoords.x > 1.0f || vertices[i].positionCoords.x < -1.0f) {
                movementVectors[i].x = -movementVectors[i].x;
            }
            vertices[i].positionCoords.y += movementVectors[i].y;
            if(vertices[i].positionCoords.y >= 1.0f || vertices[i].positionCoords.y <= -1.0f){
                movementVectors[i].y = -movementVectors[i].y;
            }
            vertices[i].positionCoords.z += movementVectors[i].z;
            if(vertices[i].positionCoords.z >= 1.0f || vertices[i].positionCoords.z <= -1.0f){
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    }else{
        for(int i = 0; i < 3; i++){
            vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
        }
    }
    // Adjust the S texture coordinates to slide texture and
    // reveal effect of texture repeat vs. clamp behavior
    // 'i' is current vertex index
    for(int i = 0; i < 3; i++){
        vertices[i].textureCoord.s = (defaultVertices[i].textureCoord.s + _sCoordinateOffset);
    }
}

/**
 更新纹理参数设置
 */
- (void)updateTextureParameters{
    glBindTexture(self.baseEffect.texture2d0.target, self.baseEffect.texture2d0.name);
    /**
     void glTexParameteri(GLenum target, GLenum pname, GLint param);
        target:
        pname:
            GL_TEXTURE_MIN_FILTER：没有足够的可用纹素来唯一性的映射一个或者多个纹素到每个片元时配置取样
        param:
            GL_LINEAR: 无论何时出现多个纹素对应一个片元时，从相配的多个纹素中取样颜色，然后使用线性内插法来混合这些颜色以得到片元的颜色
            GL_NEAREST：与片元的U，V坐标最接近的纹素的颜色会被取样
     */
    glTexParameteri(self.baseEffect.texture2d0.target, GL_TEXTURE_WRAP_S, (self.shouldRepeatTexture) ? GL_REPEAT : GL_CLAMP_TO_EDGE);
    glTexParameteri(self.baseEffect.texture2d0.target, GL_TEXTURE_MAG_FILTER, (self.shouldUseLineFilter) ? GL_LINEAR : GL_NEAREST);
}

/**
 在系统方法update里面更新顶点坐标和纹理取样设置参数，系统update方法调用频率和系统屏幕帧数一致
 */
- (void)update{
    [self updateAnimateVertexPositions];    //更新动画顶点位置
    [self updateTextureParameters];         //更新纹理参数设置
    //刷新vertexBuffer
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClear(GL_COLOR_BUFFER_BIT);
    [self.baseEffect prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);
    
    //设置vertex偏移指针
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex),NULL + offsetof(SceneVertex, positionCoords));
    
    //设置textureCoords偏移指针
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex),NULL + offsetof(SceneVertex, textureCoord));
    
    //Draw
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

@end
