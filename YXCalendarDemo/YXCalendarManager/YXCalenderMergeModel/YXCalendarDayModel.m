//
//  YXCalendarDayModel.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "YXCalendarDayModel.h"

@implementation YXCalendarDayModel

#pragma mark - 结果显示日期
- (NSString *)date {
    
    return self.boolLunar ? self.lunarDate : self.solarDate;
}
- (NSString *)lunarDate {

    NSArray *solarArr = [self.solarDate componentsSeparatedByString:@"."];
    YXCalendarYearModel *yearModel = [[YXCalendarYearModel alloc] init];
    yearModel.year = [solarArr[0] integerValue];

    YXCalendarMonthModel *monthModel = [[YXCalendarMonthModel alloc] init];
    monthModel.year = yearModel.year;
    monthModel.month = [solarArr[1] integerValue];

    YXCalendarDayModel *dayModel = [[YXCalendarDayModel alloc] init];
    dayModel.year = monthModel.year;
    dayModel.month = monthModel.month;
    dayModel.day = [solarArr[2] integerValue];

    NSDictionary *lunarDic = [[YXCalendarMergeManager sharedManager] assemblySingleLunarModelByValue:dayModel type:YXCalendarBaseModelTypeDays boolContainsTerms:NO];

    return _lunarDate.length != 0 ? _lunarDate : [NSString stringWithFormat:@"%@(%@) %@ %@", @(yearModel.year), [lunarDic objectForKey:kYXCalendarMergeManagerLunarYear], [lunarDic objectForKey:kYXCalendarMergeManagerLunarMonth], [lunarDic objectForKey:kYXCalendarMergeManagerLunarDay]];
}

#pragma mark - 是否是闰年
- (BOOL)boolLeapYear {
    
    return ((self.year %4 == 0 && self.year %100 != 0) || self.year %400 == 0) ? YES : NO;
}

@end
