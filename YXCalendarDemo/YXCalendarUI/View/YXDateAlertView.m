//
//  YXDateAlertView.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/29.
//

#import "YXDateAlertView.h"

@interface YXDateAlertView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) CGFloat startYear;
@property (nonatomic, assign) CGFloat endYear;
@property (nonatomic, assign) BOOL boolChange;

@property (nonatomic, strong) UIView *chooseBgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIView *dateChangeBgView;
@property (nonatomic, strong) UIButton *solarBtn;
@property (nonatomic, strong) UIButton *lunarBtn;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *yearArr; //年
@property (nonatomic, strong) NSMutableArray *monthArr; //月
@property (nonatomic, strong) NSMutableArray *dayArr; //日
@property (nonatomic, strong) NSArray *lunarMonthArr; //农历月数据
@property (nonatomic, strong) NSArray *lunarDayArr; //农历日数据

@property (nonatomic, assign) NSInteger yearRow;
@property (nonatomic, assign) NSInteger monthRow;
@property (nonatomic, assign) NSInteger dayRow;

@end

@implementation YXDateAlertView

- (instancetype)initWithFrame:(CGRect)frame startYear:(NSInteger)startYear endYear:(NSInteger)endYear boolChange:(BOOL)boolChange {
    self = [super initWithFrame:frame];
    
    if (self) {
        _startYear = startYear == 0 ? 1900 : startYear;
        _endYear = endYear == 0 ? [[YXCalendarMergeManager sharedManager] currentYear] : endYear;
        _boolChange = boolChange;
        [self initView];
    }
    return self;
}

#pragma mark - 指定位置
- (void)pointToTimeByModel:(YXCalendarDayModel *)model {
    
    NSArray *solarArr = [model.solarDate componentsSeparatedByString:@"."];
    NSArray *lunarArr = [model.lunarDate componentsSeparatedByString:@" "];
    
    NSInteger yearRow = 0;
    NSInteger i = 0;
    for (NSString *year in _yearArr) {
        if ([year integerValue] == [solarArr[0] integerValue]) {
            yearRow = i;
        }
        
        i++;
    }
    _yearRow = yearRow > _yearArr.count - 1 ? _yearArr.count - 1 : yearRow;
    [self.pickerView selectRow:_yearRow inComponent:0 animated:YES];
    
    NSInteger monthRow = 0;
    NSInteger j = 0;
    for (NSString *month in _monthArr) {
        if (model.boolLunar) {
            if ([_lunarMonthArr[j] containsString:lunarArr[1]]) {
                monthRow = j;
            }
        }
        else {
            if ([month integerValue] == [solarArr[1] integerValue]) {
                monthRow = j;
            }
        }
        
        j++;
    }
    [self getMonthArrByRow:yearRow];
    monthRow = monthRow > _monthArr.count - 1 ? _monthArr.count - 1 : monthRow;
    [self.pickerView selectRow:monthRow inComponent:1 animated:YES];
    
    NSInteger dayRow = 0;
    NSInteger k = 0;
    for (NSString *day in _dayArr) {
        if (model.boolLunar) {
            if ([_lunarDayArr[k] containsString:lunarArr[2]]) {
                dayRow = k;
            }
        }
        else {
            if ([day integerValue] == [solarArr[2] integerValue]) {
                dayRow = k;
            }
        }
        k++;
    }
    [self getDayArrByRow:monthRow];
    dayRow = dayRow > _dayArr.count - 1 ? _dayArr.count - 1 : dayRow;
    _dayRow = dayRow;
    [self.pickerView selectRow:_dayRow inComponent:2 animated:YES];
    
    [self getNowDateChooseAndShow];
}

#pragma mark - 获取年
- (void)getYearArrMethod {
    
    _yearArr = [[NSMutableArray alloc] init];
    for (NSInteger i = _startYear; i <= _endYear; ++i) {
        [_yearArr addObject:[NSString stringWithFormat:@"%@", @(i)]];
    }
    
    [self.pickerView reloadComponent:0];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self getMonthArrByRow:0];
}

#pragma mark - 获取月
- (void)getMonthArrByRow:(NSInteger)row {
    
    _yearRow = row;
    _monthArr = [[NSMutableArray alloc] init];
    NSInteger months = 12;
    if (_yearRow == _yearArr.count - 1) {
        months = [self getCurrentDateComponents].month;
    }
    
    for (NSInteger i = 1; i <= months; ++i) {
        [_monthArr addObject:[NSString stringWithFormat:@"%@", @(i)]];
    }
    
    [self.pickerView reloadComponent:1];
    [self.pickerView selectRow:0 inComponent:1 animated:YES];
    [self getDayArrByRow:0];
}

#pragma mark - 获取日
- (void)getDayArrByRow:(NSInteger)row {
    
    _monthRow = row;
    _dayArr = [[NSMutableArray alloc] init];
    
    NSString *yearStr = _yearArr[_yearRow];
    NSString *monthStr = _monthArr[_monthRow];
    NSString *dateStr = [NSString stringWithFormat:@"%@%@", yearStr, monthStr];
    NSInteger days = [self getDaysOfDateStr:dateStr];
    if (_yearRow == _yearArr.count - 1 && _monthRow == _monthArr.count - 1) {
        days = [self getCurrentDateComponents].day;
    }
    
    for (NSInteger i = 1; i <= days; ++i) {
        [_dayArr addObject:[NSString stringWithFormat:@"%@", @(i)]];
    }
    
    [self.pickerView reloadComponent:2];
    [self.pickerView selectRow:0 inComponent:2 animated:YES];
}

#pragma mark - 更新数值
- (void)reloadValueMethod {
    
    [self getYearArrMethod];
    [self judgeTypeShowByModel:self.model];
    [self pointToTimeByModel:self.model];
}

#pragma mark - 判断显示
- (void)judgeTypeShowByModel:(YXCalendarDayModel *)model {
    
    if (_boolChange) {
        self.dateChangeBgView.hidden = NO;
        self.dateLab.hidden = YES;
        if (model.boolLunar) {
            [self.lunarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.lunarBtn setBackgroundColor:[UIColor whiteColor]];
            
            [self.solarBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
            [self.solarBtn setBackgroundColor:[UIColor lightGrayColor]];
        }
        else {
            [self.solarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.solarBtn setBackgroundColor:[UIColor whiteColor]];
            
            [self.lunarBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
            [self.lunarBtn setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
    else {
        self.dateChangeBgView.hidden = YES;
        self.dateLab.hidden = NO;
    }
}

#pragma mark - 获取指定日期的天数
- (NSInteger)getDaysOfDateStr:(NSString *)dateStr {
    
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    if (dateStr.length == 6) {
        dateFromatter.dateFormat = @"yyyyMM";
    }
    else {
        dateFromatter.dateFormat = @"yyyyM";
    }
    if (self.model.boolLunar) dateFromatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSDate *date = [dateFromatter dateFromString:dateStr];
    NSCalendar *calendar = [self getCurrentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger days = range.length;
    return days;
}

#pragma mark - 获取指定组行的内容
- (NSString *)getContentWithComponent:(NSInteger)component row:(NSInteger)row {
    
    if (component == 0) {
        return _yearArr[row];
    }
    else if (component == 1) {
        if (self.model.boolLunar) {
            NSInteger index = [_monthArr[row] integerValue] - 1;
            return _lunarMonthArr[index];
        }
        else {
            return [NSString stringWithFormat:@"%@月", _monthArr[row]];
        }
    }
    else if (component == 2) {
        if (self.model.boolLunar) {
            NSInteger index = [_dayArr[row] integerValue] - 1;
            return _lunarDayArr[index];
        }
        else {
            return [NSString stringWithFormat:@"%@日", _dayArr[row]];
        }
    }
    return @"";
}

#pragma mark - 获取选择的日期
- (YXCalendarDayModel *)getSelectedDate {
    
    NSInteger yearRow = [self.pickerView selectedRowInComponent:0];
    NSInteger monthRow = [self.pickerView selectedRowInComponent:1];
    NSInteger dayRow = [self.pickerView selectedRowInComponent:2];
    int year = [_yearArr count] != 0 ? [_yearArr[yearRow] intValue] : 0;
    int month = [_monthArr count] != 0 ? [_monthArr[monthRow] intValue] : 0;
    int day = [_dayArr count] != 0 ? [_dayArr[dayRow] intValue] : 0;
    
    NSString *years = [NSString stringWithFormat:@"%@", @(year)];
    NSString *months = month < 10 ? [NSString stringWithFormat:@"0%@", @(month)] : [NSString stringWithFormat:@"%@", @(month)];
    NSString *days = day < 10 ? [NSString stringWithFormat:@"0%@", @(day)] : [NSString stringWithFormat:@"%@", @(day)];

    YXCalendarDayModel *model = [[YXCalendarDayModel alloc] init];
    NSString *dateStr = [NSString stringWithFormat:@"%@.%@.%@", years, months, days];
    model.solarDate = dateStr;
    if (self.model.boolLunar) {
        NSString *lunarYear = [[YXSeparationManager lunarYearFromSolarYear:year] stringByReplacingOccurrencesOfString:@"年" withString:@""] ;
        NSInteger lunarMonthIndex = month - 1;
        NSString *lunarMonth = _lunarMonthArr[lunarMonthIndex];
        NSInteger lunarDayIndex = day - 1;
        NSString *lunarDay = _lunarDayArr[lunarDayIndex];
        
        YXLunarModel *lunar = [[YXLunarModel alloc] initWithYear:year month:month day:day];
        YXSolarModel *solar = [YXSeparationManager solarFromLunar:lunar];
        
        NSString *lunarDateStr = [NSString stringWithFormat:@"%@(%@) %@ %@", @(solar.solarYear), lunarYear, lunarMonth, lunarDay];
        NSString *solarDateStr = [NSString stringWithFormat:@"%@.%@.%@", @(solar.solarYear), @(solar.solarMonth), @(solar.solarDay)];
        model.lunarDate = lunarDateStr;
        model.solarDate = solarDateStr;
    }
    return model;
}

#pragma mark - 获取当前选中日期并显示
- (void)getNowDateChooseAndShow {
    
    YXCalendarDayModel *newModel = [self getSelectedDate];
    self.dateLab.text = self.model.boolLunar ? newModel.lunarDate : newModel.solarDate;
}

#pragma mark - 获取当前日历
- (NSCalendar *)getCurrentCalendar {
    
    NSCalendar *calendar;
    if (self.model.boolLunar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    }
    else {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return calendar;
}

#pragma mark - 获取当前日期组件
- (NSDateComponents *)getCurrentDateComponents {
    
    NSCalendar *calendar = [self getCurrentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    return components;
}

#pragma mark - progress
- (void)progressChooseBtn:(UIButton *)sender {
    
    switch (sender.tag) {
        case YXDateAlertViewBtnTypeCancel: {
            [self.alertController dismissViewControllerAnimated:YES];
            break;
        }
        case YXDateAlertViewBtnTypeSure: {
            [self.alertController dismissViewControllerAnimated:YES];
            YXCalendarDayModel *model = [self getSelectedDate];
            self.model.solarDate = model.solarDate;
            self.model.lunarDate = model.lunarDate;
            if (self.yxDateAlertViewSureBlock) {
                self.yxDateAlertViewSureBlock(self.model);
            }
            break;
        }
        case YXDateAlertViewBtnTypeSolar: {
            self.model.boolLunar = NO;
            [self reloadValueMethod];
            break;
        }
        case YXDateAlertViewBtnTypeLunar: {
            self.model.boolLunar = YES;
            [self reloadValueMethod];
            break;
        }
        default:
            break;
    }
}

#pragma mark - <UIPickerViewDelegate, UIPickerViewDataSource>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (component == 0) {
        return _yearArr.count;
    }
    else if (component == 1) {
        return _monthArr.count;
    }
    else {
        return _dayArr.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return [self getContentWithComponent:component row:row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {

    return 34;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    return ([[UIScreen mainScreen] bounds].size.width - 30) /3;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (component == 0) {
        [self getMonthArrByRow:row];
    }
    else if (component == 1) {
        [self getDayArrByRow:row];
    }
    else {
        _dayRow = row;
    }
    
    [self getNowDateChooseAndShow];
}

#pragma mark - setting
- (void)setModel:(YXCalendarDayModel *)model {
    
    _model = model;
    
    [self reloadValueMethod];
}

#pragma mark - 初始化视图
- (void)initView {
    
    [self.pickerView reloadAllComponents];
    
    self.dateLab.hidden = _boolChange;
    self.dateChangeBgView.hidden =! _boolChange;
    
    //农历日期数据
    _lunarMonthArr = [YXSeparationManager getLunarMonthArr];
    _lunarDayArr = [YXSeparationManager getLunarDayArr];
    
    [self getYearArrMethod];
}

#pragma mark - 懒加载
- (UIView *)chooseBgView {
    
    if (!_chooseBgView) {
        _chooseBgView = [[UIView alloc] init];
        _chooseBgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_chooseBgView];
        
        [_chooseBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.and.top.equalTo(self);
            make.height.mas_equalTo(44);
        }];
    }
    return _chooseBgView;
}
- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _cancelBtn.tag = YXDateAlertViewBtnTypeCancel;
        [_cancelBtn addTarget:self action:@selector(progressChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseBgView addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.top.and.bottom.equalTo(self.chooseBgView);
            make.width.mas_equalTo(62);
        }];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _sureBtn.tag = YXDateAlertViewBtnTypeSure;
        [_sureBtn addTarget:self action:@selector(progressChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseBgView addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.and.top.and.bottom.equalTo(self.chooseBgView);
            make.width.mas_equalTo(62);
        }];
    }
    return _sureBtn;
}
- (UILabel *)dateLab {
    
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] init];
        _dateLab.font = [UIFont systemFontOfSize:13];
        _dateLab.textColor = [UIColor blackColor];
        _dateLab.textAlignment = NSTextAlignmentCenter;
        [self.chooseBgView addSubview:_dateLab];
        
        [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.cancelBtn.mas_right).with.offset(15);
            make.right.equalTo(self.sureBtn.mas_left).with.offset(-15);
            make.top.and.bottom.equalTo(self.chooseBgView);
        }];
    }
    return _dateLab;
}
- (UIView *)dateChangeBgView {
    
    if (!_dateChangeBgView) {
        _dateChangeBgView = [[UIView alloc] init];
        _dateChangeBgView.backgroundColor = [UIColor clearColor];
        _dateChangeBgView.layer.borderWidth = 1;
        _dateChangeBgView.layer.borderColor = [UIColor blackColor].CGColor;
        _dateChangeBgView.hidden = YES;
        [self.chooseBgView addSubview:_dateChangeBgView];
        
        [_dateChangeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.chooseBgView).with.offset(10);
            make.bottom.equalTo(self.chooseBgView).with.offset(-10);
            make.width.mas_equalTo(80);
            make.centerX.equalTo(self.chooseBgView);
        }];
    }
    return _dateChangeBgView;
}
- (UIButton *)solarBtn {
    
    if (!_solarBtn) {
        _solarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_solarBtn setTitle:@"公历" forState:UIControlStateNormal];
        [_solarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_solarBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
        _solarBtn.tag = YXDateAlertViewBtnTypeSolar;
        [_solarBtn addTarget:self action:@selector(progressChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.dateChangeBgView addSubview:_solarBtn];
        
        [_solarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.top.and.bottom.equalTo(self.dateChangeBgView);
            make.right.equalTo(self.lunarBtn.mas_left);
            make.width.equalTo(self.lunarBtn);
        }];
    }
    return _solarBtn;
}
- (UIButton *)lunarBtn {
    
    if (!_lunarBtn) {
        _lunarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lunarBtn setTitle:@"农历" forState:UIControlStateNormal];
        [_lunarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_lunarBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
        _lunarBtn.tag = YXDateAlertViewBtnTypeLunar;
        [_lunarBtn addTarget:self action:@selector(progressChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.dateChangeBgView addSubview:_lunarBtn];
        
        [_lunarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.and.top.and.bottom.equalTo(self.dateChangeBgView);
            make.left.equalTo(self.solarBtn.mas_right);
            make.width.equalTo(self.solarBtn);
        }];
    }
    return _lunarBtn;
}
- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
        
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.chooseBgView.mas_bottom);
            make.left.and.right.and.bottom.equalTo(self);
        }];
    }
    return _pickerView;
}

@end
