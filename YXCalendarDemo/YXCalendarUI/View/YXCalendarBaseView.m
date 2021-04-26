//
//  YXCalendarBaseView.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/25.
//

#import "YXCalendarBaseView.h"
#import "YXWeeksView.h"

@interface YXCalendarBaseView () <UIScrollViewDelegate>

@property (nonatomic, strong) YXWeeksView *weeksView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) NSMutableArray *calendarViewArr;
@property (nonatomic, strong) NSMutableArray *originalCalendarValueArr;
@property (nonatomic, strong) NSMutableArray *calendarValueArr;
@property (nonatomic, assign) BOOL boolShowLunarCalendar;
@property (nonatomic, assign) BOOL boolScrolView;
@property (nonatomic, strong) YXCalendarDayModel *selectedDayModel;

@end

@implementation YXCalendarBaseView

- (instancetype)initWithFrame:(CGRect)frame boolShowLunarCalendar:(BOOL)boolShowLunarCalendar boolScrollView:(BOOL)boolScrolView {
    self = [super initWithFrame:frame];
    
    if (self) {
        _boolShowLunarCalendar = boolShowLunarCalendar;
        _boolScrolView = boolScrolView;
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
    NSInteger monthBetween = month - model.month == 0 ? 0 : 1;
    NSInteger between = yearBetween == 0 ? [[NSString stringWithFormat:@"%@", monthStr] integerValue] - [[NSString stringWithFormat:@"%@", currentMonthStr] integerValue] : yearBetween *12 + ([[NSString stringWithFormat:@"%@", monthStr] integerValue] - [[NSString stringWithFormat:@"%@", currentMonthStr] integerValue]) + monthBetween;
    
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

#pragma mark - 月份切换
- (void)monthChangeMethodByType:(YXCalendarMonthType)type {
    
    if (type != YXCalendarMonthTypeCurrent) {
        if (type == YXCalendarMonthTypeLast) {
            [self updateFirstValueByBoolFirst:NO];
        }
        else {
            [self updateLastValue];
        }
        
        [self setImageFromImageNames];
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0)];
    }
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
            for (YXCalendarDayModel *dayModel in arr) {
                if (dayModel.year == _selectedDayModel.year && dayModel.month == _selectedDayModel.month && dayModel.day == _selectedDayModel.day) {
                    dayModel.boolSelected = YES;
                }
                else {
                    dayModel.boolSelected = NO;
                }
            }
            calendarView.monthModel = model;
            calendarView.daysArr = arr;
            calendarView.tag = j;
            j++;
        }
        else {
            YXCalendarMonthModel *model = _calendarValueArr[i];
            NSMutableArray *arr = model.dayArr;
            for (YXCalendarDayModel *dayModel in arr) {
                if (dayModel.year == _selectedDayModel.year && dayModel.month == _selectedDayModel.month && dayModel.day == _selectedDayModel.day) {
                    dayModel.boolSelected = YES;
                }
                else {
                    dayModel.boolSelected = NO;
                }
            }
            calendarView.monthModel = model;
            calendarView.daysArr = arr;
            calendarView.tag = i;
        }
        i++;
        
        if (calendarView.tag == 1) {
            CGFloat viewHeight = [calendarView getViewHightMethod];
            if (viewHeight) [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
               
                make.top.equalTo(self.weeksView.mas_bottom);
                make.left.and.right.equalTo(self);
                make.height.mas_equalTo(viewHeight);
            }];
            self.weeksView.monthModel = calendarView.monthModel;
        }
    }
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
        YXCalendarView *calendarView = [[YXCalendarView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width *i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) boolShowLunarCalendar:_boolShowLunarCalendar];
        calendarView.tag = i;
        calendarView.userInteractionEnabled = YES;
        [self.scrollView addSubview:calendarView];
        [_calendarViewArr addObject:calendarView];
        
        __weak typeof(self) weakSelf = self;
        calendarView.yxCalendarDayViewSelectedBlock = ^(YXCalendarDayModel * _Nonnull dayModel) {
            
            weakSelf.selectedDayModel = dayModel;
            [weakSelf monthChangeMethodByType:dayModel.monthType];
        };
    }
    
    _selectedDayModel = [[YXCalendarDayModel alloc] init];
    _selectedDayModel.year = [NSDate yxGetDateYear:[NSDate date]];
    _selectedDayModel.month = [NSDate yxGetDateMonth:[NSDate date]];
    _selectedDayModel.day = [NSDate yxGetDateDay:[NSDate date]];
    
    [self getCalendarArr];
}

#pragma mark - 懒加载
- (YXWeeksView *)weeksView {
    
    if (!_weeksView) {
        _weeksView = [[YXWeeksView alloc] init];
        _weeksView.backgroundColor = kYXCalendarViewBgColor;
        [self addSubview:_weeksView];
        
        __weak typeof(self) weakSelf = self;
        _weeksView.yxWeeksViewMonthBlock = ^(YXCalendarMonthType type) {
            
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
        _scrollView.backgroundColor = kYXCalendarViewBgColor;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = _boolScrolView;
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.weeksView.mas_bottom);
            make.left.and.right.equalTo(self);
            make.height.mas_equalTo(self.mas_height);
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
