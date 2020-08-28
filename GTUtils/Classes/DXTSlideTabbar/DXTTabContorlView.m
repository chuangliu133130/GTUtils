//
//  DXTTabContorlView.m
//  SlideTabbarView
//
//  Created by 韩冬 on 2020/8/16.
//  Copyright © 2020 韩冬. All rights reserved.
//

#import "DXTTabContorlView.h"

#import <JXCategoryView/JXCategoryView.h>

#define VWTCBOUNDSWIDTH (self.bounds.size.width)
#define VWTCTBHEIGHT (50)

NSString *const VWTCDOREFRESH = @"doRefresh";
NSString *const VWTCDOEDITTAB = @"doEditTab";

static NSString *const TABCONTROLCELLIDENTIFIER = @"dxt_tab_control_content_cell_identifier";

@interface DXTTabControlContentViewCell : UICollectionViewCell

@property (strong, nonatomic) UIView *view;

@end

@implementation DXTTabControlContentViewCell

- (void)setView:(UIView *)view {
    view.frame = self.bounds;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:view];
    _view = view;
}

@end

@interface DXTTabControlContentView : UICollectionView

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;

@end

@implementation DXTTabControlContentView



@end

@protocol DXTTabControlContentViewManagerDelegate;

@interface DXTTabControlContentViewManager : NSObject<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) DXTTabControlContentView *contentView;
@property (assign, nonatomic) NSInteger cellCount;
@property (assign, nonatomic) id<DXTTabControlContentViewManagerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *mVWs;

@end

@protocol DXTTabControlContentViewManagerDelegate <NSObject>

- (UIView *)contentManager:(DXTTabControlContentViewManager *)manager
          fetchViewAtIndex:(NSInteger)index;

@end

@implementation DXTTabControlContentViewManager

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DXTTabControlContentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TABCONTROLCELLIDENTIFIER forIndexPath:indexPath];
    UIView *contentView;
    if (self.mVWs.count > indexPath.row) {
        contentView = self.mVWs[indexPath.row];
    }
    if (!contentView) {
        NSAssert([self.delegate respondsToSelector:@selector(contentManager:fetchViewAtIndex:)], @"must implementation fetch view delegate");
        contentView = [self.delegate contentManager:self fetchViewAtIndex:indexPath.row];
        [self.mVWs addObject:contentView];
    }
    cell.view = contentView;
    return cell;
}

- (NSMutableArray *)mVWs {
    if (!_mVWs) {
        _mVWs = [NSMutableArray array];
    }
    return _mVWs;
}

@end

@protocol DXTCategoryIndicatorLineViewDelegate <NSObject>

- (CGFloat)fetchIndicatorWidth;

@end

@interface  DXTCategoryIndicatorLineView : JXCategoryIndicatorLineView

@property (assign, nonatomic) id<DXTCategoryIndicatorLineViewDelegate> extentionDelegate;

@end

@implementation DXTCategoryIndicatorLineView

- (CGFloat)indicatorWidthValue:(CGRect)cellFrame {
    if ([self.extentionDelegate respondsToSelector:@selector(fetchIndicatorWidth)]) {
        return [self.extentionDelegate fetchIndicatorWidth];
    }
    return 30;
}

@end

@interface DXTCategoryView : JXCategoryTitleView

@property (copy, nonatomic) NSMutableDictionary *mIndictorWidths;

@end

@implementation DXTCategoryView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    return CGSizeMake([self getCellWidthAtIndex:indexPath.row], VWTCTBHEIGHT);
}

- (CGRect)getTargetSelectedCellFrame:(NSInteger)targetIndex selectedType:(JXCategoryCellSelectedType)selectedType {
//    self.collectionView.numberOfSections
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0]];
    return cell.frame;
}

- (NSMutableDictionary *)mIndictorWidths {
    if (!_mIndictorWidths) {
        _mIndictorWidths = [NSMutableDictionary dictionary];
    }
    return _mIndictorWidths;
}

- (CGFloat)getCellWidthAtIndex:(NSInteger)index {
//    static CGFloat wFirst;
//    if (index == 0) {
//        //        return [super colleccollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPathton];
//        NSString *title = self.titles[0];
//        UILabel *lblTemp = [[UILabel alloc] init];
//        lblTemp.font = self.titleFont;
//        lblTemp.text = title;
//        [lblTemp sizeToFit];
//        wFirst = lblTemp.bounds.size.width + 34;
//        return wFirst;
//    } else {
//        return (VWTCBOUNDSWIDTH - wFirst) / (self.titles.count - 1);
//    }
    NSString *title = self.titles[index];
    CGFloat textWidth = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, self.titleFont.pointSize + 2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil].size.width;
    self.mIndictorWidths[@(index)] = @(textWidth);
    return VWTCBOUNDSWIDTH / 4;
}

@end

@interface DXTTabContorlView () <DXTTabControlContentViewManagerDelegate, DXTCategoryIndicatorLineViewDelegate> {
    
}

@property (strong, nonatomic) UIView *vwControl;
@property (strong, nonatomic) UIButton *btnAction;
@property (strong, nonatomic) DXTCategoryView *vwTab;
@property (strong, nonatomic) DXTTabControlContentView *vwContent;
@property (strong, nonatomic) DXTTabControlContentViewManager<UICollectionViewDataSource, UICollectionViewDelegate> *cmContent;

@end

@implementation DXTTabContorlView

- (void)layout {
    NSAssert(!CGRectIsEmpty(self.frame), @"tab control view must be have an effective area");
    NSAssert(self.bounds.size.width != 0, @"tab control view must be have an effective area");
    self.vwControl.frame = CGRectMake(0, 0, VWTCBOUNDSWIDTH, VWTCTBHEIGHT);
    [self addSubview:self.vwControl];
    NSAssert(self.imgAction, @"action image must be not null");
    [self.btnAction setImage:self.imgAction forState:UIControlStateNormal];
    self.btnAction.frame = CGRectMake(VWTCBOUNDSWIDTH - VWTCTBHEIGHT, 0, 50, VWTCTBHEIGHT);
    NSAssert(self.nSEL, @"button selector name must be not null");
    [self.btnAction addTarget:self action:@selector(doClicked:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat wTabbar =  VWTCBOUNDSWIDTH - VWTCTBHEIGHT - 1;
    UIView *btnSeperator = [[UIView alloc] init];
    btnSeperator.frame = CGRectMake(wTabbar, (VWTCTBHEIGHT - 18) / 2, 1, 18);
    btnSeperator.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    [self.vwControl addSubview:btnSeperator];
    [self.vwControl addSubview:self.btnAction];
    NSAssert([self collectionNotNull:self.titles], @"tab bar titles must be not blank");
    self.vwTab.titles = self.titles;
    
//    self.vwTab.cellSpacing = (wTabbar - 17) / self.titles.count;
//    NSMutableArray *mMdlBaseCell = [NSMutableArray array];
//    for (int i = 0; i < self.titles.count; i ++) {
//        JXCategoryBaseCellModel *model = [[JXCategoryBaseCellModel alloc] init];
//        model.index = i;
//        model.cellWidth = i == 0 ? JXCategoryViewAutomaticDimension : 150;
//        model.cellSpacing = i == 0 ? 0 : 20;
//        model.selected = i == 1;
//        [mMdlBaseCell addObject:model];
//    }
//    self.vwTab.dataSource = mMdlBaseCell;
    self.vwTab.frame = CGRectMake(0, 0, wTabbar, VWTCTBHEIGHT);
    [self.vwControl addSubview:self.vwTab];
    NSAssert(self.hContent > 0, @"must set content height value and the value must be greater than zero");
    self.vwContent.frame = CGRectMake(0, VWTCTBHEIGHT, VWTCBOUNDSWIDTH, self.hContent);
    self.vwContent.flowLayout.itemSize = CGSizeMake(VWTCBOUNDSWIDTH, self.hContent);
    [self addSubview:self.vwContent];
}

- (UIView *)contentManager:(DXTTabControlContentViewManager *)manager
          fetchViewAtIndex:(NSInteger)index {
    if (self.contents.count > index) {
        return self.contents[index];
    }
    return nil;
}

- (UIView *)vwControl{
    if (!_vwControl) {
        _vwControl = [[UIView alloc] init];
    }
    return _vwControl;
}

- (UIButton *)btnAction {
    if (!_btnAction) {
        _btnAction = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btnAction;
}

- (DXTCategoryView *)vwTab {
    if (!_vwTab) {
        _vwTab = [[DXTCategoryView alloc] init];
        _vwTab.delegate = (id)self;
        _vwTab.titleSelectedColor = [UIColor blackColor];
        _vwTab.titleColor = [UIColor colorWithWhite:0.1 alpha:1];
        _vwTab.backgroundColor = [UIColor whiteColor];
        _vwTab.titleLabelVerticalOffset = 0;
        _vwTab.separatorLineShowEnabled = YES;
        _vwTab.cellSpacing = 0;
        _vwTab.cellWidthIncrement = 0;
        _vwTab.averageCellSpacingEnabled = NO;
        _vwTab.separatorLineColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
        _vwTab.separatorLineSize = CGSizeMake(1, 18);
        DXTCategoryIndicatorLineView *vwLine = [[DXTCategoryIndicatorLineView alloc] init];
        vwLine.verticalMargin = 8;
        vwLine.indicatorColor = [UIColor colorWithHexString:@"#1159FE"];
        vwLine.indicatorWidth = UITableViewAutomaticDimension;
        vwLine.extentionDelegate = (id)self;
        _vwTab.indicators = @[vwLine];
        _vwTab.contentScrollView = self.vwContent;
        _vwTab.delegate = self.tabbarDelegate;
    }
    return _vwTab;
}

- (DXTTabControlContentView *)vwContent {
    if (!_vwContent) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _vwContent = [[DXTTabControlContentView alloc] initWithFrame:CGRectInfinite collectionViewLayout:layout];
        _vwContent.flowLayout = layout;
        _vwContent.showsVerticalScrollIndicator = NO;
        _vwContent.showsHorizontalScrollIndicator = NO;
        _vwContent.scrollEnabled = NO;
        [_vwContent registerClass:[DXTTabControlContentViewCell class] forCellWithReuseIdentifier:TABCONTROLCELLIDENTIFIER];
    }
    return _vwContent;
}

- (DXTTabControlContentViewManager *)cmContent {
    if (!_cmContent) {
        _cmContent = [[DXTTabControlContentViewManager<UICollectionViewDataSource,UICollectionViewDelegate> alloc] init];
        self.cmContent.delegate = self;
        self.vwContent.delegate = _cmContent;
        self.vwContent.dataSource = _cmContent;
        _cmContent.contentView = self.vwContent;
    }
    return _cmContent;
}

- (void)doClicked:(UIButton *)sender {
    [self callAction:self.nSEL];
}

- (void)callAction:(NSString *)nSEL {
    SEL selector = NSSelectorFromString(nSEL);
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation  invoke];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    self.cmContent.cellCount = titles.count;
}

- (void)doRefresh {
    
}

- (void)doEditTab {
    
}

- (BOOL)collectionNotNull:(id)obj {
    if (![obj isKindOfClass:[NSArray class]] && ![obj isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if (!obj) {
        return NO;
    }
    if ([obj count] == 0) {
        return NO;
    }
    return YES;
}

- (CGFloat)fetchIndicatorWidth {
    return [self.vwTab.mIndictorWidths[@(self.vwTab.selectedIndex)] floatValue];
}

@end


