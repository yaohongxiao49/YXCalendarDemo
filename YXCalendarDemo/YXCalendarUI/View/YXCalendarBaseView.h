//
//  YXCalendarBaseView.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCalendarBaseView : UIView

- (instancetype)initWithFrame:(CGRect)frame boolShowLunarCalendar:(BOOL)boolShowLunarCalendar boolScrollView:(BOOL)boolScrolView;

/** 指定显示数据 */
- (void)pointToMonthByMonth:(NSInteger)month year:(NSInteger)year;

@end

NS_ASSUME_NONNULL_END
