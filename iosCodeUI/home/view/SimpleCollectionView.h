//
//  SimpleCollectionView.h
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/26.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface SimpleCollectionView : UICollectionView

@property (nonatomic,strong) NSMutableArray<NSMutableArray<Person *> *> * personDataSource;

@end

NS_ASSUME_NONNULL_END
