//
//  YXCalendarView.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "YXCalendarView.h"
#import "YXCalendarDayCell.h"

@interface YXCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *monthBgLab;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, assign) CGFloat originalHeight;
@property (nonatomic, assign) BOOL boolShowLunarCalendar;

@end

@implementation YXCalendarView

- (instancetype)initWithFrame:(CGRect)frame boolShowLunarCalendar:(BOOL)boolShowLunarCalendar {
    self = [super initWithFrame:frame];
    
    if (self) {
        _boolShowLunarCalendar = boolShowLunarCalendar;
        [self initView];
    }
    return self;
}

#pragma mark - 回传高度
- (CGFloat)getCollectionViewHeight {
    
    [self.collectionView layoutIfNeeded];
    return self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}

- (CGFloat)getViewHightMethod {
    
    CGFloat height = [self getCollectionViewHeight];
    if (height != _originalHeight) {
        [self.monthBgLab mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.height.mas_equalTo(height);
        }];
        
        return height;
    }
    _originalHeight = height;
    return 0;
}

#pragma mark - 获取选中行
- (void)getSelectedByIndexPath:(NSIndexPath *)indexPath arr:(NSMutableArray *)arr {
    
    if (self.yxCalendarDayViewSelectedBlock) {
        YXCalendarDayModel *blockDayModel = [[YXCalendarDayModel alloc] init];
        NSInteger index = indexPath.row;
        blockDayModel = arr[index];
        self.yxCalendarDayViewSelectedBlock(blockDayModel);
    }
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YXCalendarDayCell class]) forIndexPath:indexPath];
    [cell reloadValueByIndexPath:indexPath valueArr:_dataSourceArr boolShowLunarCalendar:_boolShowLunarCalendar];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self getSelectedByIndexPath:indexPath arr:_dataSourceArr];
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

#pragma mark - setting
- (void)setDaysArr:(NSMutableArray *)daysArr {
    
    _daysArr = daysArr;
    
    _dataSourceArr = [[NSMutableArray alloc] initWithArray:_daysArr];
    [self.collectionView reloadData];
}
- (void)setMonthModel:(YXCalendarMonthModel *)monthModel {
    
    _monthModel = monthModel;
    
    self.monthBgLab.text = [NSString stringWithFormat:@"%ld", _monthModel.month];
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - 懒加载
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
        [self addSubview:_collectionView];
     
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.edges.equalTo(self);
        }];
    }
    return _collectionView;
}
- (UILabel *)monthBgLab {
    
    if (!_monthBgLab) {
        _monthBgLab = [[UILabel alloc] init];
        _monthBgLab.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:200 /2550.f];
        _monthBgLab.font = [UIFont systemFontOfSize:150.0f weight:120.f];
        _monthBgLab.textAlignment = NSTextAlignmentCenter;
        [self insertSubview:_monthBgLab atIndex:0];
        
        [_monthBgLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.and.right.and.left.equalTo(self.collectionView);
            make.height.mas_equalTo(CGRectGetHeight(self.bounds));
        }];
    }
    return _monthBgLab;
}

@end
