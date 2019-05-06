//
//  Person.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/17.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "Person.h"

@implementation Person

+(NSMutableArray<NSMutableArray *> *)initPersonDataSource{
    NSMutableArray<NSMutableArray *> * dataArray=@[].mutableCopy;
    for(int i=0;i<3;i++){
        NSMutableArray<Person *> * persons=@[].mutableCopy;
        for (int j=0;j<(i+1)*10;j++){
            Person * person=[Person new];
            person.name=@"jz";
            person.age=j;
            [persons addObject:person];
        }
        [dataArray addObject:persons];
    }
    return dataArray.copy;
}


@end
