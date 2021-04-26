//
//  YXWeeksView.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "YXWeeksView.h"
#import "YXCalendarWeeksCell.h"

@interface YXWeeksView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *monthBgView; //月份背景视图
@property (nonatomic, strong) UIButton *lastMonthBtn; //上一月
@property (nonatomic, strong) UIButton *yearsBtn; //年
@property (nonatomic, strong) UIButton *nextMonthBtn; //下一月
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *weeksDataSourceArr;

@end

@implementation YXWeeksView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - 月份切换
- (void)progressMonthChangeBtn:(UIButton *)sender {
    
    if (self.yxWeeksViewMonthBlock) {
        self.yxWeeksViewMonthBlock(sender.tag);
    }
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.weeksDataSourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXCalendarWeeksCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YXCalendarWeeksCell class]) forIndexPath:indexPath];
    [cell reloadValueByIndexPath:indexPath valueArr:self.weeksDataSourceArr];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger screenWidth = (self.frame.size.width - 20 - (10 *6)) /7;
    return CGSizeMake(screenWidth, screenWidth);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
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
- (void)setMonthModel:(YXCalendarMonthModel *)monthModel {
    
    _monthModel = monthModel;
    
    [self.yearsBtn setTitle:[NSString stringWithFormat:@"%ld", _monthModel.year] forState:UIControlStateNormal];
}

#pragma mark - 初始化视图
- (void)initView {
    
    [self.collectionView reloadData];
    self.lastMonthBtn.hidden = self.yearsBtn.hidden = self.nextMonthBtn.hidden = NO;
}

#pragma mark - 懒加载
- (UIView *)monthBgView {
    
    if (!_monthBgView) {
        _monthBgView = [[UIView alloc] init];
        _monthBgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_monthBgView];
        
        [_monthBgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.and.top.equalTo(self);
            make.height.mas_equalTo(self).multipliedBy(0.5);
        }];
    }
    return _monthBgView;
}
- (UIButton *)lastMonthBtn {
    
    if (!_lastMonthBtn) {
        _lastMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastMonthBtn setTitle:@"上一月" forState:UIControlStateNormal];
        [_lastMonthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _lastMonthBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _lastMonthBtn.tag = YXCalendarMonthTypeLast;
        [_lastMonthBtn addTarget:self action:@selector(progressMonthChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.monthBgView addSubview:_lastMonthBtn];
        
        [_lastMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.and.bottom.equalTo(self.yearsBtn);
            make.left.equalTo(self.monthBgView);
            make.right.equalTo(self.yearsBtn.mas_left);
        }];
    }
    return _lastMonthBtn;
}
- (UIButton *)yearsBtn {
    
    if (!_yearsBtn) {
        _yearsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yearsBtn setTitle:@"2020" forState:UIControlStateNormal];
        [_yearsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _yearsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _yearsBtn.tag = YXCalendarMonthTypeCurrent;
        [_yearsBtn addTarget:self action:@selector(progressMonthChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.monthBgView addSubview:_yearsBtn];
        
        [_yearsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.and.bottom.equalTo(self.monthBgView);
            make.center.equalTo(self.monthBgView);
            make.width.equalTo(self.lastMonthBtn);
        }];
    }
    return _yearsBtn;
}
- (UIButton *)nextMonthBtn {
    
    if (!_nextMonthBtn) {
        _nextMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextMonthBtn setTitle:@"下一月" forState:UIControlStateNormal];
        [_nextMonthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextMonthBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _nextMonthBtn.tag = YXCalendarMonthTypeNext;
        [_nextMonthBtn addTarget:self action:@selector(progressMonthChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.monthBgView addSubview:_nextMonthBtn];
        
        [_nextMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.and.bottom.equalTo(self.yearsBtn);
            make.right.equalTo(self.monthBgView);
            make.left.equalTo(self.yearsBtn.mas_right);
            make.width.equalTo(self.yearsBtn);
        }];
    }
    return _nextMonthBtn;
}
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[YXCalendarWeeksCell class] forCellWithReuseIdentifier:NSStringFromClass([YXCalendarWeeksCell class])];
        [self addSubview:_collectionView];
     
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.monthBgView.mas_bottom);
            make.left.and.right.and.bottom.equalTo(self);
        }];
    }
    return _collectionView;
}
- (NSMutableArray *)weeksDataSourceArr {
    
    if (!_weeksDataSourceArr) {
        _weeksDataSourceArr = [[NSMutableArray alloc] initWithArray:@[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]];
    }
    return _weeksDataSourceArr;
}

@end
