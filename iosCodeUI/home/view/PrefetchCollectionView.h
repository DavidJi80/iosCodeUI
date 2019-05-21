//
//  PrefetchCollectionView.h
//  iosCodeUI
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrefetchCollectionView : UICollectionView

@property (nonatomic,strong) NSMutableArray<NSMutableArray<Person *> *> * personDataSource;

@end

NS_ASSUME_NONNULL_END
