//
//  PhotosFrameworksUtility.m
//  iosCodeUI
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "PhotosFrameworksUtility.h"

@implementation PhotosFrameworksUtility

+(NSString *)formatCMTime:(CMTime)cmTime{
    NSTimeInterval timeInterVal=CMTimeGetSeconds(cmTime);
    int minute = 0, hour = 0, secend = timeInterVal,microsecond=0;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    microsecond=(timeInterVal-timeInterVal)*1000;
    NSString * timeString=@"";
    if (hour>0){
        timeString=[NSString stringWithFormat:@"%d:%02d:%02d", hour,minute,secend];
    }else{
        timeString=[NSString stringWithFormat:@"%02d:%02d", minute,secend];
    }
    return timeString;
}

@end
