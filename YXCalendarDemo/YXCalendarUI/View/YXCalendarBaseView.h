//
//  YXCalendarBaseView.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YXCalendarBaseViewDayBlock)(YXCalendarDayModel *dayModel);

@interface YXCalendarBaseView : UIView

@property (nonatomic, copy) YXCalendarBaseViewDayBlock yxCalendarBaseViewDayBlock;

/** 指定显示数据 */
- (void)pointToMonthByMonth:(NSInteger)month
                       year:(NSInteger)year
                        day:(NSInteger)day;

/**
 * 初始化视图
 * @param frame 视图尺寸
 * @param vc 父视图控制器
 * @param startYear 起始年（默认为1900）
 * @param endYear 结束年（默认为当前年）
 * @param boolOnlyCurrent 是否只显示当月
 * @param boolShowLunarCalendar 是否显示农历
 * @param boolContainsTerms 是否显示节日（前置是显示农历）
 * @param boolScrollView 是否可以滚动切换
 */
- (instancetype)initWithFrame:(CGRect)frame
                           vc:(UIViewController *)vc
                    startYear:(NSInteger)startYear
                      endYear:(NSInteger)endYear
              boolOnlyCurrent:(BOOL)boolOnlyCurrent
        boolShowLunarCalendar:(BOOL)boolShowLunarCalendar
            boolContainsTerms:(BOOL)boolContainsTerms
               boolScrollView:(BOOL)boolScrollView;

@end

NS_ASSUME_NONNULL_END
