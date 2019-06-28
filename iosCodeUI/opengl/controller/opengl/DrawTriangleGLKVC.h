//
//  DrawTriangleGLKVC.h
//  iosCodeUI
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <GLKit/GLKit.h>     //通过#import编译指令导入GLKit框架

NS_ASSUME_NONNULL_BEGIN

/**
 将ViewController继承的UIViewController改为GLKViewController，
 使其继承GLKViewController的基本功能(如：接收当视图需要重绘时的消息)，
 GLKViewController又从它的超类继承了很多功能
 */
@interface DrawTriangleGLKVC : GLKViewController

@end

NS_ASSUME_NONNULL_END
