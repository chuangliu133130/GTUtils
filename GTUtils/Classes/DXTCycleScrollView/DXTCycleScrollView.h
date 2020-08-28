//
//  DXTCycleScrollView.h
//  RecycleView
//
//  Created by 韩冬 on 2020/8/16.
//  Copyright © 2020 韩冬. All rights reserved.
//

#import <SDCycleScrollView/SDCycleScrollView.h>

@interface DXTCycleScrollView : SDCycleScrollView

@property (nonatomic, copy) void (^itemScrollingOperationBlock)(UICollectionViewScrollDirection direction, CGFloat currentPosition);

@end
