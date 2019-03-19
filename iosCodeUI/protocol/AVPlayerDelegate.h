//
//  AVPlayerDelegate.h
//  iosCodeUI
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 季舟. All rights reserved.
//

#ifndef AVPlayerDelegate_h
#define AVPlayerDelegate_h

@protocol AVPlayerDelegate <NSObject>
@required
- (void) replacePlayerItem:(NSInteger)index;
@end

#endif /* AVPlayerDelegate_h */
