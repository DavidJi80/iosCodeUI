//
//  Person.h
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/17.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic,copy) NSString * name;
// assign修饰NSString，演示错误之用
@property (nonatomic,weak) NSString * nameError;
@property (nonatomic,assign) NSInteger age;

+(NSMutableArray<NSMutableArray *> *)initPersonDataSource;

@end

NS_ASSUME_NONNULL_END
