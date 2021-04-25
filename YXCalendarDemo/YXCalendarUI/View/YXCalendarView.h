//
//  YXCalendarView.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YXCalendarViewHeightBlock)(CGFloat height);

@interface YXCalendarView : UIView

/** 是否显示农历 */
@property (nonatomic, assign) BOOL boolShowLunarCalendar;

@property (nonatomic, strong) NSMutableArray *daysArr;
@property (nonatomic, weak) YXCalendarMonthModel *monthModel;
@property (nonatomic, strong) YXCalendarViewHeightBlock yxCalendarViewHeightBlock;

@end

NS_ASSUME_NONNULL_END
