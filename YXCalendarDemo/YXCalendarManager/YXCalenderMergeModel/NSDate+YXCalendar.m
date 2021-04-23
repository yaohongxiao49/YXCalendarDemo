//
//  NSDate+YXCalendar.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "NSDate+YXCalendar.h"

@implementation NSDate (YXCalendar)

#pragma mark - 获得当前NSDate对象对应的日子
+ (NSInteger)yxGetDateDay:(NSDate *)date {
    
    NSDateComponents *components = [self yxCurrentDateComponents:NSCalendarUnitDay date:date];
    return components.day;
}

#pragma mark - 获得当前NSDate对象对应的月份
+ (NSInteger)yxGetDateMonth:(NSDate *)date {
    
    NSDateComponents *components = [self yxCurrentDateComponents:NSCalendarUnitMonth date:date];
    return components.month;
}

#pragma mark - 获得当前NSDate对象对应的年份
+ (NSInteger)yxGetDateYear:(NSDate *)date {
    
    NSDateComponents *components = [self yxCurrentDateComponents:NSCalendarUnitYear date:date];
    return components.year;
}

#pragma mark - 获得当前NSDate对象的上个月的某一天的NSDate对象
+ (NSDate *)yxGetLastMonthDate:(NSDate *)date {
    
    NSDateComponents *components = [self yxNearByDateComponents:date]; //定位到当月中间日子
    if (components.month == 1) {
        components.month = 12;
        components.year -= 1;
    }
    else {
        components.month -= 1;
    }
    NSDate *lastDate = [[NSCalendar currentCalendar] dateFromComponents:components];

    return lastDate;
}

#pragma mark - 获得当前NSDate对象的下个月的某一天的NSDate对象
+ (NSDate *)yxGetNextMonthDate:(NSDate *)date {
    
    NSDateComponents *components = [self yxNearByDateComponents:date]; //定位到当月中间日子
    if (components.month == 12) {
        components.month = 1;
        components.year += 1;
    }
    else {
        components.month += 1;
    }
    NSDate *nextDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return nextDate;
}

#pragma mark - 获得当前NSDate对象对应的月份的总天数
+ (NSInteger)yxGetTotalDaysOfMonth:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

#pragma mark - 获得当前NSDate对象对应月份当月第一天的所属星期
+ (NSInteger)yxGetFirstWeekDayOfMonth:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.day = 1; //定位到当月第一天
    NSDate *firstDay = [calendar dateFromComponents:components];
    
    //默认一周第一天序号为 1，而日历中约定为 0，故需要减一
    NSInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDay] - 1;
    return firstWeekday;
}

#pragma mark - Private Method
+ (NSDateComponents *)yxCurrentDateComponents:(NSCalendarUnit)calendarUnit date:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:calendarUnit fromDate:date];
}
+ (NSDateComponents *)yxNearByDateComponents:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.day = 15; //定位到当月中间日子
    return components;
}

@end
