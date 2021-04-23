//
//  YXCalendarMergeManager.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "YXCalendarMergeManager.h"

@interface YXCalendarMergeManager ()

@property (nonatomic, copy) NSDate *currentDate;

@end

@implementation YXCalendarMergeManager

#pragma mark - 单例
+ (instancetype)sharedManager {
    
    static YXCalendarMergeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
    });
    
    return manager;
}

#pragma mark - 显示日历视图
+ (void)yxShowCalendarViewByVC:(UIViewController *)vc baseView:(UIView *)baseView frame:(CGRect)frame boolShowLunarCalendar:(BOOL)boolShowLunarCalendar {
    
    YXCalendarView *calendarView = [[YXCalendarView alloc] initWithFrame:frame];
    calendarView.boolShowLunarCalendar = boolShowLunarCalendar;
    [baseView addSubview:calendarView];
}

#pragma mark - 获取日历容器数据
- (void)yxCalendarContainerWithNearByMonths:(NSInteger)currentTag boolOnlyCurrent:(BOOL)boolOnlyCurrent boolContainsTerms:(BOOL)boolContainsTerms calendarBlock:(void(^)(NSArray *daysArr, YXCalendarBaseModel *baseModel))calendarBlock {
    
    NSArray *nearByMonths = [self yxGetNearByMonths:currentTag boolOnlyCurrent:boolOnlyCurrent];
    if (nearByMonths.count < 1) return;
    NSMutableArray *daysArray = [NSMutableArray arrayWithCapacity:2];

    //获取本月相近的前后两月信息
    YXCalendarBaseModel *currentModel = [nearByMonths objectAtIndex:boolOnlyCurrent ? 0 : 1];
    //显示上一月天数
    NSInteger showLastMonthDays = currentModel.firstWeekday;
    //还剩多少天没有满一星期
    NSInteger lastWeekDays = (currentModel.totalDays - (7 - showLastMonthDays)) %7;
    //显示下一月天数
    NSInteger showNextMonthDays = 7 - (lastWeekDays != 0 ? lastWeekDays : 7);
    
    if (!boolOnlyCurrent) {
        YXCalendarBaseModel *firstModel = [nearByMonths objectAtIndex:0];
        YXCalendarBaseModel *lastModel = [nearByMonths objectAtIndex:2];
        
        //获取日历第一个星期含有上月末尾日期lastMonth
        for (NSInteger index = 0; index < showLastMonthDays; index++) {
            YXCalendarDayModel *dayModel = [[YXCalendarDayModel alloc] init];
            dayModel.year = firstModel.year;
            dayModel.month = firstModel.month;
            dayModel.day = firstModel.totalDays - showLastMonthDays + index + 1;
            dayModel.boolInCurrentMonth = NO;
            dayModel.boolCurrentDay = NO;
            dayModel.boolSelected = NO;
            YXCalendarDayModel *endDayModel = [[YXCalendarMergeManager sharedManager] assemblyLunarCalendarDayModelByDayModel:dayModel boolContainsTerms:boolContainsTerms];
            [daysArray addObject:endDayModel];
        }
        //获取日历本月的日期currentMonth
        for (NSInteger index = 0; index < currentModel.totalDays; index++) {
            YXCalendarDayModel *dayModel = [[YXCalendarDayModel alloc] init];
            dayModel.year = currentModel.year;
            dayModel.month = currentModel.month;
            dayModel.day = index + 1;
            dayModel.boolInCurrentMonth = YES;
            dayModel.boolCurrentDay = [self yxJudgetCurrentDayNowMonth:dayModel];
            dayModel.boolSelected = dayModel.boolCurrentDay;
            YXCalendarDayModel *endDayModel = [[YXCalendarMergeManager sharedManager] assemblyLunarCalendarDayModelByDayModel:dayModel boolContainsTerms:boolContainsTerms];
            [daysArray addObject:endDayModel];
        }
        //获取日历最后一星期含有下月的日期nextMonth
        for (NSInteger index = 0; index < showNextMonthDays; index++) {
            YXCalendarDayModel *dayModel = [[YXCalendarDayModel alloc] init];
            dayModel.year = lastModel.year;
            dayModel.month = lastModel.month;
            dayModel.day = index + 1;
            dayModel.boolInCurrentMonth = NO;
            dayModel.boolCurrentDay = NO;
            dayModel.boolSelected = NO;
            YXCalendarDayModel *endDayModel = [[YXCalendarMergeManager sharedManager] assemblyLunarCalendarDayModelByDayModel:dayModel boolContainsTerms:boolContainsTerms];
            [daysArray addObject:endDayModel];
        }
    }
    else {
        for (NSInteger index = 0; index < currentModel.totalDays; index++) {
            YXCalendarDayModel *dayModel = [[YXCalendarDayModel alloc] init];
            dayModel.year = currentModel.year;
            dayModel.month = currentModel.month;
            dayModel.day = index + 1;
            dayModel.boolInCurrentMonth = YES;
            dayModel.boolCurrentDay = [self yxJudgetCurrentDayNowMonth:dayModel];
            dayModel.boolSelected = dayModel.boolCurrentDay;
            YXCalendarDayModel *endDayModel = [[YXCalendarMergeManager sharedManager] assemblyLunarCalendarDayModelByDayModel:dayModel boolContainsTerms:boolContainsTerms];
            [daysArray addObject:endDayModel];
        }
    }
    
    calendarBlock(daysArray, currentModel);
}

#pragma mark - 获取本月临近两月
- (NSArray *)yxGetNearByMonths:(NSInteger)currentTag boolOnlyCurrent:(BOOL)boolOnlyCurrent {
    
    NSDate *date = [NSDate date];
    if (boolOnlyCurrent) {
        if (currentTag > 0) {
            for (int i = 0; i < currentTag; i++) {
                date = [NSDate yxGetNextMonthDate:date];
            }
        }
        else {
            currentTag = labs(currentTag);
            for (int i = 0; i < currentTag; i++) {
                date = [NSDate yxGetLastMonthDate:date];
            }
        }
        self.currentDate = date;
        YXCalendarBaseModel *currentMonth = [self yxGetMonthWithDate:date];
        
        return @[currentMonth];
    }
    else {
        NSDate *last = [NSDate yxGetLastMonthDate:date];
        NSDate *next = [NSDate yxGetNextMonthDate:date];
        
        if (currentTag > 0) {
            for (int i = 0; i < currentTag; i++) {
                date = [NSDate yxGetNextMonthDate:date];
                last = [NSDate yxGetLastMonthDate:date];
                next = [NSDate yxGetNextMonthDate:date];
            }
        }
        else {
            currentTag = labs(currentTag);
            for (int i = 0; i < currentTag; i++) {
                date = [NSDate yxGetLastMonthDate:date];
                last = [NSDate yxGetLastMonthDate:date];
                next = [NSDate yxGetNextMonthDate:date];
            }
        }
        self.currentDate = date;
        YXCalendarBaseModel *currentMonth = [self yxGetMonthWithDate:date];
        YXCalendarBaseModel *lastMonth = [self yxGetMonthWithDate:last];
        YXCalendarBaseModel *nextMonth = [self yxGetMonthWithDate:next];
        
        return @[lastMonth, currentMonth, nextMonth];
    }
}

#pragma mark - 根据NSDate对象获取组装月份数据
- (YXCalendarBaseModel *)yxGetMonthWithDate:(NSDate *)date {
    
    YXCalendarBaseModel *model = [[YXCalendarBaseModel alloc] init];
    model.year = [NSDate yxGetDateYear:date];
    model.month = [NSDate yxGetDateMonth:date];
    model.day = [NSDate yxGetDateDay:date];
    model.totalDays = [NSDate yxGetTotalDaysOfMonth:date];
    model.firstWeekday = [NSDate yxGetFirstWeekDayOfMonth:date];
    
    return model;
}

#pragma mark - 判断是否为当前日期
- (BOOL)yxJudgetCurrentDayNowMonth:(YXCalendarDayModel *)dayModel {
    
    NSInteger nowDay = [NSDate yxGetDateDay:[NSDate date]];
    NSInteger nowMonth = [NSDate yxGetDateMonth:[NSDate date]];
    NSInteger nowYear = [NSDate yxGetDateYear:[NSDate date]];
    if (dayModel.year != nowYear) return NO;
    if (dayModel.month != nowMonth) return NO;
    if (dayModel.day != nowDay) return NO;
    
    return YES;
}

#pragma mark - getting
- (NSInteger)currentDay {
    
    return [NSDate yxGetDateDay:self.currentDate];
}
- (NSInteger)currentMonth {
    
    return [NSDate yxGetDateMonth:self.currentDate];
}
- (NSInteger)currentYear {
    
    return [NSDate yxGetDateYear:self.currentDate];
}
- (NSDate *)currentDate {
    
    if (!_currentDate) {
        _currentDate = [NSDate date];
    }
    return _currentDate;
}

#pragma mark - 组装阳历及节气显示数据
- (YXCalendarDayModel *)assemblyLunarCalendarDayModelByDayModel:(YXCalendarDayModel *)dayModel boolContainsTerms:(BOOL)boolContainsTerms {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", dayModel.year, dayModel.month, dayModel.day];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    if (!date) return nil;
    NSArray *heavenlyStems = [NSArray arrayWithObjects:@"癸", @"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", nil];
    NSArray *earthlyBranches = [NSArray arrayWithObjects:@"亥", @"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", nil];
    NSArray *lunarCalendarMonths = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月", nil];
    NSArray *lunarCalendarDays = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"廿十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", nil];
    
    YXCalendarDayModel *holidayModel = dayModel;
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *year = [NSString stringWithFormat:@"%@%@", heavenlyStems[localeComp.year %10], earthlyBranches[localeComp.year %12]];
    NSString *month = [lunarCalendarMonths objectAtIndex:localeComp.month - 1];
    NSString *day = [lunarCalendarDays objectAtIndex:localeComp.day - 1];
    
    NSString *lunarCalendarDay = day;
    holidayModel.lunarDay = lunarCalendarDay;
    holidayModel.lunarMonth = month;
    holidayModel.lunarYear = year;
    holidayModel.holidayNamed = lunarCalendarDay;
    
    if (boolContainsTerms) {
        NSDictionary *lunarCalendarMonthsDic = @{@"正月初一":@"春节", @"正月十五":@"元宵节", @"五月初五":@"端午节", @"八月十五":@"中秋节", @"九月初九":@"重阳节", @"腊月初八":@"腊八节", @"腊月廿三":@"小年", @"腊月三十":@"除夕"};
        NSString *monthAndDay = [NSString stringWithFormat:@"%@%@", month, day];
        
        NSArray *lunarCalendarMonthsArr = [lunarCalendarMonthsDic allKeys];
        if ([lunarCalendarMonthsArr containsObject:monthAndDay]) {
            lunarCalendarDay = [lunarCalendarMonthsDic objectForKey:monthAndDay];
            holidayModel.boolHoliday = YES;
        }
        else if ([lunarCalendarMonths containsObject:month] && [day isEqualToString:@"初一"]) {
            lunarCalendarDay = @"初一";
        }
        
        NSDictionary *solarCalendarDaysDic = @{@"01-01":@"元旦", @"02-14":@"情人节", @"03-08":@"妇女节", @"03-12":@"植树节", @"03-20":@"春分", @"04-01":@"愚人节", @"04-04":@"清明",  @"05-01":@"劳动节", @"05-04":@"青年节", @"06-01":@"儿童节", @"07-01":@"建党节", @"08-01":@"建军节", @"09-10":@"教师节", @"10-01":@"国庆节", @"11-26":@"感恩节", @"12-24":@"平安夜", @"12-25":@"圣诞节"};
        
        NSDictionary *lunarTermsDaysDic = @{@"02-03":@"立春", @"02-18":@"雨水", @"03-05":@"惊蛰", @"04-20":@"谷雨", @"05-05":@"立夏", @"05-21":@"小满", @"06-05":@"芒种", @"06-21":@"夏至", @"07-07":@"小暑", @"07-22":@"大暑", @"08-07":@"立秋", @"08-23":@"处暑", @"09-07":@"白露", @"09-23":@"秋分", @"10-08":@"寒露", @"10-23":@"霜降", @"11-07":@"立冬", @"11-22":@"小雪", @"12-07":@"大雪", @"12-21":@"冬至", @"01-05":@"小寒", @"01-20":@"大寒"};
        
        NSDateFormatter *dateFormatterNow = [[NSDateFormatter alloc] init];
        dateFormatterNow.dateFormat = @"MM-dd";
        NSString *nowDay = [dateFormatterNow stringFromDate:date];
        
        NSArray *lunarTermsDaysArr = [lunarTermsDaysDic allKeys];
        if ([lunarTermsDaysArr containsObject:nowDay]) {
            lunarCalendarDay = [lunarTermsDaysDic objectForKey:nowDay];
            holidayModel.boolHoliday = YES;
        }
        
        NSArray *solarCalendarDaysArr = [solarCalendarDaysDic allKeys];
        if ([solarCalendarDaysArr containsObject:nowDay]) {
            lunarCalendarDay = [solarCalendarDaysDic objectForKey:nowDay];
            holidayModel.boolHoliday = YES;
        }
        holidayModel.holidayNamed = lunarCalendarDay;
        holidayModel.lunarDay = lunarCalendarDay;
    }
    
    return holidayModel;
}

#pragma mark - 组装阴历
- (NSDictionary *)assemblySingleLunarModelByValue:(id)value type:(YXCalendarBaseModelType)type boolContainsTerms:(BOOL)boolContainsTerms {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *dateStr = [[NSString alloc] init];
    switch (type) {
        case YXCalendarBaseModelTypeYears: {
            YXCalendarYearModel *model = value;
            dateStr = [NSString stringWithFormat:@"%ld-%d-%d", model.year, 1, 1];
            break;
        }
        case YXCalendarBaseModelTypeMonths: {
            YXCalendarMonthModel *model = value;
            dateStr = [NSString stringWithFormat:@"%ld-%ld-%d", model.year, model.month, 1];
            break;
        }
        case YXCalendarBaseModelTypeDays: {
            YXCalendarDayModel *model = value;
            dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", model.year, model.month, model.day];
            break;
        }
        default:
            break;
    }

    NSDate *date = [dateFormatter dateFromString:dateStr];
    if (!date) return nil;
    NSArray *heavenlyStems = [NSArray arrayWithObjects:@"癸", @"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", nil];
    NSArray *earthlyBranches = [NSArray arrayWithObjects:@"亥", @"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", nil];
    NSArray *lunarCalendarMonths = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月", nil];
    NSArray *lunarCalendarDays = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"廿十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", nil];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];

    NSString *year = [NSString stringWithFormat:@"%@%@", heavenlyStems[localeComp.year %10], earthlyBranches[localeComp.year %12]];
    NSString *month = [lunarCalendarMonths objectAtIndex:localeComp.month - 1];
    NSString *day = [lunarCalendarDays objectAtIndex:localeComp.day - 1];

    if (boolContainsTerms) {
        NSDictionary *lunarCalendarMonthsDic = @{@"正月初一":@"春节", @"正月十五":@"元宵节", @"五月初五":@"端午节", @"八月十五":@"中秋节", @"九月初九":@"重阳节", @"腊月初八":@"腊八节", @"腊月廿三":@"小年", @"腊月三十":@"除夕"};
        NSString *monthAndDay = [NSString stringWithFormat:@"%@%@", month, day];

        NSArray *lunarCalendarMonthsArr = [lunarCalendarMonthsDic allKeys];
        if ([lunarCalendarMonthsArr containsObject:monthAndDay]) {
            day = [lunarCalendarMonthsDic objectForKey:monthAndDay];
        }
        else if ([lunarCalendarMonths containsObject:month] && [day isEqualToString:@"初一"]) {
            day = @"初一";
        }

        NSDictionary *solarCalendarDaysDic = @{@"01-01":@"元旦", @"02-14":@"情人节", @"03-08":@"妇女节", @"03-12":@"植树节", @"03-20":@"春分", @"04-01":@"愚人节", @"04-04":@"清明",  @"05-01":@"劳动节", @"05-04":@"青年节", @"06-01":@"儿童节", @"07-01":@"建党节", @"08-01":@"建军节", @"09-10":@"教师节", @"10-01":@"国庆节", @"11-26":@"感恩节", @"12-24":@"平安夜", @"12-25":@"圣诞节"};

        NSDictionary *lunarTermsDaysDic = @{@"02-03":@"立春", @"02-18":@"雨水", @"03-05":@"惊蛰", @"04-20":@"谷雨", @"05-05":@"立夏", @"05-21":@"小满", @"06-05":@"芒种", @"06-21":@"夏至", @"07-07":@"小暑", @"07-22":@"大暑", @"08-07":@"立秋", @"08-23":@"处暑", @"09-07":@"白露", @"09-23":@"秋分", @"10-08":@"寒露", @"10-23":@"霜降", @"11-07":@"立冬", @"11-22":@"小雪", @"12-07":@"大雪", @"12-21":@"冬至", @"01-05":@"小寒", @"01-20":@"大寒"};

        NSDateFormatter *dateFormatterNow = [[NSDateFormatter alloc] init];
        dateFormatterNow.dateFormat = @"MM-dd";
        NSString *nowDay = [dateFormatterNow stringFromDate:date];

        NSArray *lunarTermsDaysArr = [lunarTermsDaysDic allKeys];
        if ([lunarTermsDaysArr containsObject:nowDay]) {
            day = [lunarTermsDaysDic objectForKey:nowDay];
        }

        NSArray *solarCalendarDaysArr = [solarCalendarDaysDic allKeys];
        if ([solarCalendarDaysArr containsObject:nowDay]) {
            day = [solarCalendarDaysDic objectForKey:nowDay];
        }
    }

    if (type == YXCalendarBaseModelTypeYears) {
        NSDictionary *dic = @{kYXCalendarMergeManagerLunarYear:year, kYXCalendarMergeManagerLunarMonth:@"", kYXCalendarMergeManagerLunarDay:@""};
        return dic;
    }
    else if (type == YXCalendarBaseModelTypeMonths) {
        NSDictionary *dic = @{kYXCalendarMergeManagerLunarYear:year, kYXCalendarMergeManagerLunarMonth:month, kYXCalendarMergeManagerLunarDay:@""};
        return dic;
    }
    else {
        NSDictionary *dic = @{kYXCalendarMergeManagerLunarYear:year, kYXCalendarMergeManagerLunarMonth:month, kYXCalendarMergeManagerLunarDay:day};
        return dic;
    }
}

- (NSMutableArray *)assemblyDateByStartYears:(NSInteger)startYears boolContainsTerms:(BOOL)boolContainsTerms {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSInteger nowYear = [NSDate yxGetDateYear:[NSDate date]];
    NSInteger nowMonth = [NSDate yxGetDateMonth:[NSDate date]];
    
    for (NSInteger i = nowYear; i >= startYears; i --) {
        YXCalendarYearModel *yearModel = [[YXCalendarYearModel alloc] init];
        yearModel.year = i;
        
        NSMutableArray *monthArr = [[NSMutableArray alloc] init];
        if (i == nowYear) {
            for (NSInteger j = nowMonth; j >= 1; j --) {
                YXCalendarMonthModel *monthModel = [[YXCalendarMonthModel alloc] init];
                monthModel.year = i;
                monthModel.month = j;
                
                NSMutableArray *dayArr = [[NSMutableArray alloc] init];
                
                [self monthChangeMethodByType:UIViewAnimationOptionTransitionCurlDown boolCurrent:(j == nowMonth) boolContainsTerms:boolContainsTerms calendarBlock:^(NSArray *daysArr) {
                    
                    [dayArr addObjectsFromArray:daysArr];
                    monthModel.dayArr = dayArr;
                    [monthArr insertObject:monthModel atIndex:0];
                }];
            }
        }
        else {
            for (NSInteger j = 12; j >= 1; j --) {
                YXCalendarMonthModel *monthModel = [[YXCalendarMonthModel alloc] init];
                monthModel.year = i;
                monthModel.month = j;
                
                NSMutableArray *dayArr = [[NSMutableArray alloc] init];
                [self monthChangeMethodByType:UIViewAnimationOptionTransitionCurlDown boolCurrent:NO boolContainsTerms:boolContainsTerms calendarBlock:^(NSArray *daysArr) {
                    
                    [dayArr addObjectsFromArray:daysArr];
                    monthModel.dayArr = dayArr;
                    [monthArr insertObject:monthModel atIndex:0];
                }];
            }
        }
        yearModel.monthArr = monthArr;
        [arr insertObject:yearModel atIndex:0];
    }
    
    return arr;
}

#pragma mark - 月份切换
- (void)monthChangeMethodByType:(UIViewAnimationOptions)type boolCurrent:(BOOL)boolCurrent boolContainsTerms:(BOOL)boolContainsTerms calendarBlock:(void(^)(NSArray *daysArr))calendarBlock {
    
    static NSInteger month = 0;
    static UIViewAnimationOptions animationOption = UIViewAnimationOptionTransitionCurlUp;
    if (type == UIViewAnimationOptionTransitionCurlUp) {
        month = month + 1;
        animationOption = UIViewAnimationOptionTransitionCurlUp;
    }
    else {
        month = month - 1;
        animationOption = UIViewAnimationOptionTransitionCurlDown;
    }
    month = boolCurrent ? 0 : month;
    
    [[YXCalendarMergeManager sharedManager] yxCalendarContainerWithNearByMonths:month boolOnlyCurrent:YES boolContainsTerms:boolContainsTerms calendarBlock:^(NSArray * _Nonnull daysArr, YXCalendarBaseModel * _Nonnull baseModel) {
        
        calendarBlock(daysArr);
    }];
}

@end
