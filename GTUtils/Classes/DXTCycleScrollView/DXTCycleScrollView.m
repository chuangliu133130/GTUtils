//
//  DXTCycleScrollView.m
//  RecycleView
//
//  Created by 韩冬 on 2020/8/16.
//  Copyright © 2020 韩冬. All rights reserved.
//

#import "DXTCycleScrollView.h"

#import <objc/runtime.h>

@implementation DXTCycleScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    Method method = class_getInstanceMethod(NSClassFromString(@"SDCycleScrollView"), @selector(scrollViewDidScroll:));
    SEL sel = method_getName(method);
    IMP impl = method_getImplementation(method);
    void (*func)(id, SEL, id) = (void *)impl;
    func(self, sel, scrollView);
//    if ([super respondsToSelector:@selector(scrollViewDidScroll:)]) {
////        SEL selector = @selector(scrollViewDidScroll:);
////        NSMethodSignature *signature = [NSClassFromString(@"SDCycleScrollView") instanceMethodSignatureForSelector:selector];
////        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
////        [invocation setTarget:self];
////        [invocation setSelector:selector];
////        [invocation setArgument:&scrollView atIndex:2];
////        [invocation  invoke];
//        [super performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
//    }
    if (self.itemScrollingOperationBlock) {
        UICollectionView *collectionView = (UICollectionView *)[self valueForKeyPath:@"mainView"];
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        CGFloat offset = flowLayout == UICollectionViewScrollDirectionVertical ? collectionView.contentOffset.y : collectionView.contentOffset.x;
        self.itemScrollingOperationBlock(flowLayout.scrollDirection, offset);
    }
}

@end
