//
//  NSDate+YXCalendar.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (YXCalendar)

/**  获得当前NSDate对象对应的日子 */
+ (NSInteger)yxGetDateDay:(NSDate *)date;

/** 获得当前NSDate对象对应的月份 */
+ (NSInteger)yxGetDateMonth:(NSDate *)date;

/** 获得当前NSDate对象对应的年份 */
+ (NSInteger)yxGetDateYear:(NSDate *)date;

/** 获得当前NSDate对象的上个月的某一天的NSDate对象 */
+ (NSDate *)yxGetLastMonthDate:(NSDate *)date;

/** 获得当前NSDate对象的下个月的某一天的NSDate对象 */
+ (NSDate *)yxGetNextMonthDate:(NSDate *)date;

/** 获得当前NSDate对象对应的月份的总天数 */
+ (NSInteger)yxGetTotalDaysOfMonth:(NSDate *)date;

/** 获得当前NSDate对象对应月份当月第一天的所属星期 */
+ (NSInteger)yxGetFirstWeekDayOfMonth:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
