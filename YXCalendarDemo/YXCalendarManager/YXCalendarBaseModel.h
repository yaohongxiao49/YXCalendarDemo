//
//  YXCalendarBaseModel.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXCalendarBaseModelType) {
    /** 年 */
    YXCalendarBaseModelTypeYears,
    /** 月 */
    YXCalendarBaseModelTypeMonths,
    /** 日 */
    YXCalendarBaseModelTypeDays,
};

@interface YXCalendarBaseModel : NSObject

/** 当前年 */
@property (nonatomic, assign) NSInteger year;
/** 当前月 */
@property (nonatomic, assign) NSInteger month;
/** 当前天 */
@property (nonatomic, assign) NSInteger day;
/** 当前年(农历) */
@property (nonatomic, copy) NSString *solarYear;
/** 当前月(农历) */
@property (nonatomic, copy) NSString *solarMonth;
/** 当前天(农历) */
@property (nonatomic, copy) NSString *solarDay;
/** 当月天数 */
@property (nonatomic, assign) NSInteger totalDays;
/** 起始是星期几（0：周日，1：周一....） */
@property (nonatomic, assign) NSInteger firstWeekday;

@end

NS_ASSUME_NONNULL_END
