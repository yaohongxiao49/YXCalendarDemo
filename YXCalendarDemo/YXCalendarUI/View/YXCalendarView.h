//
//  YXCalendarView.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kYXCalendarViewBgColor [[UIColor blackColor] colorWithAlphaComponent:0.5]

typedef void(^YXCalendarDayViewSelectedBlock)(YXCalendarDayModel *dayModel);

@interface YXCalendarView : UIView

@property (nonatomic, strong) NSMutableArray *daysArr;
@property (nonatomic, weak) YXCalendarMonthModel *monthModel;
@property (nonatomic, copy) YXCalendarDayViewSelectedBlock yxCalendarDayViewSelectedBlock;

- (CGFloat)getViewHightMethod;
- (instancetype)initWithFrame:(CGRect)frame boolShowLunarCalendar:(BOOL)boolShowLunarCalendar;

@end

NS_ASSUME_NONNULL_END
