//
//  YXCalendarBaseView.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/25.
//

#import "YXCalendarBaseView.h"
#import "YXWeeksView.h"

@interface YXCalendarBaseView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView; //滚动视图
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) NSMutableArray *calendarViewArr;
@property (nonatomic, strong) NSMutableArray *originalCalendarValueArr;
@property (nonatomic, strong) NSMutableArray *calendarValueArr;
@property (nonatomic, assign) BOOL boolShowLunarCalendar;

@end

@implementation YXCalendarBaseView

- (instancetype)initWithFrame:(CGRect)frame boolShowLunarCalendar:(BOOL)boolShowLunarCalendar {
    self = [super initWithFrame:frame];
    
    if (self) {
        _boolShowLunarCalendar = boolShowLunarCalendar;
        [self initView];
    }
    return self;
}

#pragma mark - 获取日历数据
- (void)getCalendarArr {
    
    NSInteger currentYear = [NSDate yxGetDateYear:[NSDate date]];
    [self updateMonthMethodByCurrentYear:currentYear boolInitArr:YES];
}

#pragma mark - 获取数据并更新年份
- (void)updateMonthMethodByCurrentYear:(NSInteger)currentYear boolInitArr:(BOOL)boolInitArr {
    
    NSInteger starYears = 2020;
    NSInteger endYears = 2021;
    
    if (boolInitArr) {
        _originalCalendarValueArr = [[YXCalendarMergeManager sharedManager] assemblyDateByStartYears:starYears endYears:endYears boolOnlyCurrent:NO boolContainsTerms:YES];
        for (YXCalendarYearModel *yearModel in _originalCalendarValueArr) {
            [_calendarValueArr addObjectsFromArray:(NSMutableArray *)yearModel.monthArr];
        }
    }
    
    if (boolInitArr) {
        [self updateFirstValueByBoolFirst:YES];
        [self setImageFromImageNames];
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    }
}

#pragma mark - 指定显示数据
- (void)pointToMonthByMonth:(NSInteger)month year:(NSInteger)year {
    
    YXCalendarMonthModel *model = _calendarValueArr.count == 0 ? nil : _calendarValueArr.count > 1 ? _calendarValueArr[1] : _calendarValueArr[0];
    
    NSString *currentMonthStr = model.month >= 10 ? [NSString stringWithFormat:@"%@", @(model.month)] : [NSString stringWithFormat:@"0%@", @(model.month)];
    
    NSString *monthStr = month >= 10 ? [NSString stringWithFormat:@"%@", @(month)] : [NSString stringWithFormat:@"0%@", @(month)];
    NSInteger yearBetween = year - model.year;
    NSInteger between = yearBetween == 0 ? [[NSString stringWithFormat:@"%@", monthStr] integerValue] - [[NSString stringWithFormat:@"%@", currentMonthStr] integerValue] : yearBetween *12 + ([[NSString stringWithFormat:@"%@", monthStr] integerValue] - [[NSString stringWithFormat:@"%@", currentMonthStr] integerValue]);
    
    if (between != 0) {
        for (NSInteger i = 0; i < labs(between); i++) {
            if (between > 0) {
                [self updateLastValue];
            }
            else {
                [self updateFirstValueByBoolFirst:NO];
            }
        }
        
        [self setImageFromImageNames];
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0)];
    }
}

#pragma mark - 更新第一条数据
- (void)updateFirstValueByBoolFirst:(BOOL)boolFirst {
    
    NSInteger judgeCount = 1;
    if (!boolFirst) judgeCount = 1;
    
    for (NSInteger i = 0; i < judgeCount; i ++) {
        NSMutableArray *arr = _calendarValueArr.lastObject;
        [_calendarValueArr removeLastObject];
        [_calendarValueArr insertObject:arr atIndex:0];
    }
}

#pragma mark - 更新最后一条数据
- (void)updateLastValue {
    
    NSMutableArray *arr = _calendarValueArr.firstObject;
    [_calendarValueArr removeObjectAtIndex:0];
    [_calendarValueArr addObject:arr];
}

#pragma mark - 滚动切换
- (void)scrollViewChangeByScrollView:(UIScrollView *)scrollView {
    
    NSInteger judgeBigCount = 2;
    NSInteger judgeSmallCount = 0;
    NSInteger judgeShowCount = 1;
    
    CGFloat offsetOrigin = scrollView.contentOffset.x;
    
    if (offsetOrigin >= judgeBigCount *CGRectGetWidth(self.scrollView.frame)) { //滑动到右边视图
        [self updateLastValue];
    }
    else if (offsetOrigin <= judgeSmallCount *CGRectGetWidth(self.scrollView.frame)) { //滑动到左边视图
        [self updateFirstValueByBoolFirst:NO];
    }
    else {
        return;
    }
    
    [self setImageFromImageNames];
    
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame) *judgeShowCount, 0)];
}

#pragma mark - 设置图片
- (void)setImageFromImageNames {
    
    NSInteger i = 0;
    NSInteger j = 0;
    NSInteger judgeCount = 3;
    NSInteger judgeShowCount = 1;
    NSInteger judgeHiddenCount = 1;
    if (_calendarValueArr.count <= 3) judgeShowCount = _calendarValueArr.count == 0 ? 0 : _calendarValueArr.count - 1;
    for (YXCalendarView *calendarView in _calendarViewArr) {
        if (_calendarValueArr.count == 1 && i != judgeHiddenCount) {
            calendarView.hidden = YES;
            calendarView.userInteractionEnabled = NO;
        }
        else {
            calendarView.hidden = NO;
            calendarView.userInteractionEnabled = YES;
        }
        
        if (_calendarValueArr.count < judgeCount && i > judgeShowCount) { //只有两张图片时，将最后一张视图的图片，以第一张图片进行设置。
            if (j == _calendarValueArr.count) j = 0;
            YXCalendarMonthModel *model = _calendarValueArr[j];
            NSMutableArray *arr = model.dayArr;
            calendarView.monthModel = model;
            calendarView.daysArr = arr;
            calendarView.tag = j;
            j++;
        }
        else {
            YXCalendarMonthModel *model = _calendarValueArr[i];
            calendarView.monthModel = model;
            calendarView.daysArr = model.dayArr;
            calendarView.tag = i;
        }
        i++;
    }
    
    YXCalendarView *view = _calendarViewArr.count == 0 ? nil : _calendarViewArr.count > 1 ? _calendarViewArr[1] : _calendarViewArr[0];
    __weak typeof(self) weakSelf = self;
    view.yxCalendarViewHeightBlock = ^(CGFloat height) {
        
        weakSelf.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(weakSelf.scrollView.frame), height);
    };
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self scrollViewChangeByScrollView:scrollView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width *3, self.scrollView.frame.size.height)];
}

#pragma mark - 初始化视图
- (void)initView {
    
    _calendarViewArr = [[NSMutableArray alloc] init];
    _originalCalendarValueArr = [[NSMutableArray alloc] init];
    _calendarValueArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i ++) {
        YXCalendarView *calendarView = [[YXCalendarView alloc] init];
        calendarView.tag = i;
        calendarView.frame = CGRectMake(self.scrollView.frame.size.width *i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        calendarView.userInteractionEnabled = YES;
        [self.scrollView addSubview:calendarView];
        [_calendarViewArr addObject:calendarView];
    }
    
    [self getCalendarArr];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self);
        }];
        
        [_scrollView setNeedsLayout];
        [_scrollView layoutIfNeeded];
    }
    return _scrollView;
}
- (UIView *)baseView {
    
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.userInteractionEnabled = NO;
        [self.scrollView addSubview:_baseView];
        
        [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.scrollView);
            make.width.and.height.equalTo(self.scrollView);
        }];
    }
    return _baseView;
}

@end
