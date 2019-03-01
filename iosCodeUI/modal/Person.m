//
//  Person.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/17.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "Person.h"

@implementation Person

+(NSArray *)initPersonDataSource{
    
    NSMutableArray * dataArray=@[].mutableCopy;
    for(int i=0;i<100;i++){
        Person * person=[Person new];
        person.name=@"jz";
        person.age=i;
        [dataArray addObject:person];
    }
    return dataArray.copy;
}


@end
