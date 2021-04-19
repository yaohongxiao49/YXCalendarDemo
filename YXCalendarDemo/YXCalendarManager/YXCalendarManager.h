//
//  YXCalendarManager.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import <Foundation/Foundation.h>
#import "YXCalendarBaseModel.h"
#import "YXCalendarYearModel.h"
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
 * @param boolShowLunarCalendar 是否显示农历
 */
+ (void)yxShowCalendarViewByVC:(UIViewController *)vc
                      baseView:(UIView *)baseView
                         frame:(CGRect)frame
         boolShowLunarCalendar:(BOOL)boolShowLunarCalendar;

/**
 * 获取日历容器数据
 * @param currentTag 本月偏移值（0：当前月=本月，1：当前月=下一月，-1：当前月=上一月，........）
 * @param boolOnlyCurrent 是否只含当月
 */
- (void)yxCalendarContainerWithNearByMonths:(NSInteger)currentTag
                            boolOnlyCurrent:(BOOL)boolOnlyCurrent
                              calendarBlock:(void(^)(NSArray *daysArr, YXCalendarBaseModel *baseModel))calendarBlock;

/**
 * 组装阳历数据
 * @param dayModel 日期模型
 * @param boolContainsTerms 是否包含节假日
 */
- (YXCalendarDayModel *)assemblyLunarCalendarDayModelByDayModel:(YXCalendarDayModel *)dayModel
                                              boolContainsTerms:(BOOL)boolContainsTerms;


/**
 * 获取单个阳历数据
 * @param value 指定年月日（YXCalendarYearModel，YXCalendarMonthModel，YXCalendarDayModel）
 * @param type 年月日类型
 * @param boolContainsTerms 是否包含节气
 */
- (NSString *)assemblySingleLunarModelByValue:(id)value
                                         type:(YXCalendarBaseModelType)type
                            boolContainsTerms:(BOOL)boolContainsTerms;

/** 获取年月日，持续时间，如1900~当前 */
- (NSMutableArray *)assemblyDateByStartYears:(NSInteger)startYears;

/**
 * 月份切换
 * @param type UIViewAnimationOptionTransitionCurlUp/UIViewAnimationOptionTransitionCurlDown 下一个月/上一个月
 * @param boolCurrent 是否是当前月
 */
- (void)monthChangeMethodByType:(UIViewAnimationOptions)type
                    boolCurrent:(BOOL)boolCurrent
                  calendarBlock:(void(^)(NSArray *daysArr))calendarBlock;

@end

NS_ASSUME_NONNULL_END
