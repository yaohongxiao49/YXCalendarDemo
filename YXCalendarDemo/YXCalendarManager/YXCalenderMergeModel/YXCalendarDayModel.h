//
//  YXCalendarDayModel.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "YXCalendarBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 月份类型枚举 */
typedef NS_ENUM(NSUInteger, YXCalendarMonthType) {
    /** 上一月 */
    YXCalendarMonthTypeLast,
    /** 当前月 */
    YXCalendarMonthTypeCurrent,
    /** 下一月 */
    YXCalendarMonthTypeNext,
};

@interface YXCalendarDayModel : YXCalendarBaseModel

/** 这天是否是当天*/
@property (nonatomic, assign) BOOL boolCurrentDay;
/** 月份类型 */
@property (nonatomic, assign) YXCalendarMonthType monthType;
/** 是否选中 */
@property (nonatomic, assign) BOOL boolSelected;
/** 是否是假日/节气 */
@property (nonatomic, assign) BOOL boolHoliday;
/** 假日名称 */
@property (nonatomic, copy) NSString *holidayNamed;

/** 是否是闰年 */
@property (nonatomic, assign) BOOL boolLeapYear;
/** 是否是闰月 */
//@property (nonatomic, assign) BOOL boolLeapMonth;
/** 月总天数 */
@property (nonatomic, assign) NSInteger monthTotal;

#pragma mark - 农历显示
/** 是否是农历 */
@property (nonatomic, assign) BOOL boolLunar;
/** 结果显示日期 */
@property (nonatomic, copy) NSString *date;
/** 公历 */
@property (nonatomic, copy) NSString *solarDate;
/** 农历 */
@property (nonatomic, copy) NSString *lunarDate;

@end

NS_ASSUME_NONNULL_END
