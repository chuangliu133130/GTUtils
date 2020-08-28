//
//  DXTTabContorlView.h
//  SlideTabbarView
//
//  Created by 韩冬 on 2020/8/16.
//  Copyright © 2020 韩冬. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JXCategoryView/JXCategoryView.h>

@class DXTTabContorlView;


@interface DXTTabContorlView : UIView

FOUNDATION_EXPORT NSString *const VWTCDOREFRESH;
FOUNDATION_EXPORT NSString *const VWTCDOEDITTAB;

@property (assign, nonatomic) CGFloat hContent;
@property (copy, nonatomic) NSArray<UIView *> *contents;
@property (copy, nonatomic) NSArray<NSString *> *titles;
@property (strong, nonatomic) UIImage *imgAction;
@property (copy, nonatomic) NSString *nSEL;
@property (assign, nonatomic) id<JXCategoryViewDelegate> tabbarDelegate;

- (void)layout;

@end
