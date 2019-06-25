//
//  OfficialDemoGLKVC.m
//  iosCodeUI
//
//  Created by mac on 2019/6/25.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "OfficialDemoGLKVC.h"

@interface OfficialDemoGLKVC ()

@end

@implementation OfficialDemoGLKVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Create an OpenGL ES context and assign it to the view loaded from storyboard
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Configure renderbuffers created by the view
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    
    // Enable multisampling
    view.drawableMultisample = GLKViewDrawableMultisample4X;
}

//- (void)drawRect:(CGRect)rect{
//    // Clear the framebuffer
//    glClearColor(0.0f, 0.0f, 0.1f, 1.0f);
//    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//
//    // Draw using previously configured texture, shader, uniforms, and vertex array
//    glBindTexture(GL_TEXTURE_2D, planetTexture);
//    glUseProgram(diffuseShading);
//    glUniformMatrix4fv(uniformModelViewProjectionMatrix, 1, 0, modelViewProjectionMatrix.m);
//    glBindVertexArrayOES(planetMesh);
//    glDrawElements(GL_TRIANGLE_STRIP, 256, GL_UNSIGNED_SHORT);
//}
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    // Create a context so we can test for features
//    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    [EAGLContext setCurrentContext:context];
//
//    // Choose a rendering class based on device features
//    GLint maxTextureSize;
//    glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize);
//    if (maxTextureSize > 2048)
//        self.renderer = [[MyBigTextureRenderer alloc] initWithContext:context];
//    else
//        self.renderer = [[MyRenderer alloc] initWithContext:context];
//
//    // Make the renderer the delegate for the view loaded from the main storyboard
//    GLKView *view = (GLKView *)self.window.rootViewController.view;
//    view.delegate = self.renderer;
//
//    // Give the OpenGL ES context to the view so it can draw
//    view.context = context;
//
//    return YES;
//}
//
//
@end
