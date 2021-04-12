//
//  YXWeeksView.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 月份切换类型枚举 */
typedef NS_ENUM(NSUInteger, MonthChangeBtnType) {
    /** 上一月 */
    MonthChangeBtnTypeLast,
    /** 年 */
    MonthChangeBtnTypeYear,
    /** 下一月 */
    MonthChangeBtnTypeNext,
};

typedef void(^YXWeeksViewMonthBlock)(MonthChangeBtnType type);

@interface YXWeeksView : UIView

@property (nonatomic, copy) YXCalendarBaseModel *model;

@property (nonatomic, copy) YXWeeksViewMonthBlock yxWeeksViewMonthBlock;

@end

NS_ASSUME_NONNULL_END
