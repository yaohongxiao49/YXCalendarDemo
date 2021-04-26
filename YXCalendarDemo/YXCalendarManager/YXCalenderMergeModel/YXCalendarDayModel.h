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

@end

NS_ASSUME_NONNULL_END
