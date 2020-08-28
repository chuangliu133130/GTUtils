//
//  XLChannelControl.h
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void(^XLChannelBlock)(NSArray *enabledTitles,NSArray *disabledTitles);
typedef void(^XLChannelBlock)(NSArray *dataArray);


@interface XLChannelControl : NSObject

+ (XLChannelControl*)shareControl;

//- (void)showChannelViewWithEnabledTitles:(NSArray*)enabledTitles disabledTitles:(NSArray*)disabledTitles finish:(XLChannelBlock)block;

- (void)showChannelViewWithData:(NSArray *)dataArray finish:(XLChannelBlock)block;

@end
