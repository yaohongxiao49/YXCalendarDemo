//
//  YXCalendarManager.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import <Foundation/Foundation.h>
#import "YXCalendarBaseModel.h"
#import "YXCalendarDayModel.h"
#import "NSDate+YXCalendar.h"
#import "YXCalendarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCalendarManager : NSObject

/** 当前日 */
@property (nonatomic, assign) NSInteger currentDay;
/** 当前月 */
@property (nonatomic, assign) NSInteger currentMonth;
/** 当前年 */
@property (nonatomic, assign) NSInteger currentYear;

/** 单例 */
+ (instancetype)sharedManager;

/**
 * 显示日历视图
 * @param vc 父控制器
 * @param baseView 父视图
 * @param frame 坐标尺寸
 * @param boolShowSolarCalendar 是否显示阳历
 */
+ (void)yxShowCalendarViewByVC:(UIViewController *)vc
                      baseView:(UIView *)baseView
                         frame:(CGRect)frame
         boolShowSolarCalendar:(BOOL)boolShowSolarCalendar;

/**
 * 获取日历容器数据
 * currentTag：本月偏移值（0：当前月=本月，1：当前月=下一月，-1：当前月=上一月，........）
 * calendar: 日历容器内数据回调
 */
- (void)yxCalendarContainerWithNearByMonths:(NSInteger)currentTag
                              calendarBlock:(void(^)(NSArray *daysArr, YXCalendarBaseModel *baseModel))calendarBlock;

/** 组装阳历数据 */
- (YXCalendarDayModel *)assemblySolarCalendarDayModelByDayModel:(YXCalendarDayModel *)dayModel;

@end

NS_ASSUME_NONNULL_END
