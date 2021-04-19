//
//  YXCalendarView.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "YXCalendarView.h"
#import "YXWeeksView.h"
#import "YXCalendarDayCell.h"

#define kYXCalendarViewBgColor [[UIColor blackColor] colorWithAlphaComponent:0.5]

@interface YXCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) YXWeeksView *weeksView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *monthBgLab;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation YXCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = [self getCollectionViewHeight] + CGRectGetHeight(self.weeksView.bounds);
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.bounds), height);
}

#pragma mark - 回传高度
- (CGFloat)getCollectionViewHeight {
    
    [self.collectionView layoutIfNeeded];
    return self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}

#pragma mark - 更新月份数据
- (void)updateMonthMethodByMonths:(NSInteger)months {
    
    __weak typeof(self) weakSelf = self;
    [[YXCalendarManager sharedManager] yxCalendarContainerWithNearByMonths:months boolOnlyCurrent:YES boolContainsTerms:YES calendarBlock:^(NSArray * _Nonnull daysArr, YXCalendarBaseModel * _Nonnull baseModel) {
        
        weakSelf.dataSourceArr = [[NSMutableArray alloc] initWithArray:daysArr];
        weakSelf.weeksView.model = baseModel;
        weakSelf.monthBgLab.text = [NSString stringWithFormat:@"%ld", baseModel.month];
        [weakSelf.collectionView reloadData];
        [weakSelf layoutSubviews];
    }];
}

#pragma mark - 月份切换
- (void)monthChangeMethodByType:(MonthChangeBtnType)type {
    
    static NSInteger month = 0;
    static UIViewAnimationOptions animationOption = UIViewAnimationOptionTransitionCurlUp;
    if (type == MonthChangeBtnTypeNext) {
        month = month + 1;
        animationOption = UIViewAnimationOptionTransitionCurlUp;
    }
    else {
        month = month - 1;
        animationOption = UIViewAnimationOptionTransitionCurlDown;
        
    }
    __weak typeof(self) weakSelf = self;
    [UIView transitionWithView:self.collectionView duration:0.8 options:animationOption animations:^{
        
        [weakSelf updateMonthMethodByMonths:month];
    } completion:nil];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YXCalendarDayCell class]) forIndexPath:indexPath];
    [cell reloadValueByIndexPath:indexPath valueArr:self.dataSourceArr];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger idx = 0;
    for (YXCalendarDayModel *dayModel in self.dataSourceArr) {
        dayModel.boolSelected = idx == indexPath.row ? YES : NO;
        idx++;
    }
    [collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger screenWidth = (self.frame.size.width - 20 - (10 *6)) /7;
    return CGSizeMake(screenWidth, screenWidth);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(15, 10, 15, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.backgroundColor = [UIColor clearColor];
    [self updateMonthMethodByMonths:0];
}

#pragma mark - 懒加载
- (YXWeeksView *)weeksView {
    
    if (!_weeksView) {
        _weeksView = [[YXWeeksView alloc] init];
        _weeksView.backgroundColor = kYXCalendarViewBgColor;
        [self addSubview:_weeksView];
        
        __weak typeof(self) weakSelf = self;
        _weeksView.yxWeeksViewMonthBlock = ^(MonthChangeBtnType type) {
            
            [weakSelf monthChangeMethodByType:type];
        };
        
        [_weeksView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.and.left.and.right.equalTo(self);
            make.height.mas_equalTo(54);
        }];
        
        [_weeksView setNeedsLayout];
        [_weeksView layoutIfNeeded];
    }
    return _weeksView;
}
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = kYXCalendarViewBgColor;
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.weeksView.mas_bottom);
            make.left.and.right.and.bottom.equalTo(self);
        }];
        
        [_scrollView setNeedsLayout];
        [_scrollView layoutIfNeeded];
    }
    return _scrollView;
}
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionHeadersPinToVisibleBounds = YES;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[YXCalendarDayCell class] forCellWithReuseIdentifier:NSStringFromClass([YXCalendarDayCell class])];
        [self.scrollView addSubview:_collectionView];
     
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.weeksView.mas_bottom);
            make.left.and.right.and.bottom.equalTo(self);
        }];
        
        [_collectionView setNeedsLayout];
        [_collectionView layoutIfNeeded];
    }
    return _collectionView;
}
- (UILabel *)monthBgLab {
    
    if (!_monthBgLab) {
        _monthBgLab = [[UILabel alloc] init];
        _monthBgLab.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:200 /2550.f];
        _monthBgLab.font = [UIFont systemFontOfSize:150.0f weight:120.f];
        _monthBgLab.textAlignment = NSTextAlignmentCenter;
        [self.collectionView insertSubview:_monthBgLab atIndex:0];
        
        [_monthBgLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self.collectionView);
        }];
    }
    return _monthBgLab;
}

@end
