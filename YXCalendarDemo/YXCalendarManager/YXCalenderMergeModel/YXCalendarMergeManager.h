//
//  YXCalendarMergeManager.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import <Foundation/Foundation.h>
#import "YXCalendarBaseModel.h"
#import "YXCalendarYearModel.h"
#import "NSDate+YXCalendar.h"
#import "YXCalendarView.h"
#import "YXCalendarBaseView.h"

NS_ASSUME_NONNULL_BEGIN

#define kYXCalendarMergeManagerLunarYear @"YXCalendarMergeManagerLunarYear"
#define kYXCalendarMergeManagerLunarMonth @"YXCalendarMergeManagerLunarMonth"
#define kYXCalendarMergeManagerLunarDay @"YXCalendarMergeManagerLunarDay"

@interface YXCalendarMergeManager : NSObject

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
         boolShowLunarCalendar:(BOOL)boolShowLunarCalendar
                boolScrollView:(BOOL)boolScrollView;

/**
 * 获取日历容器数据
 * @param currentTag 本月偏移值（0：当前月=本月，1：当前月=下一月，-1：当前月=上一月，........）
 * @param boolOnlyCurrent 是否只含当月
 * @param boolContainsTerms 是否包含节气
 */
- (void)yxCalendarContainerWithNearByMonths:(NSInteger)currentTag
                            boolOnlyCurrent:(BOOL)boolOnlyCurrent
                          boolContainsTerms:(BOOL)boolContainsTerms
                              calendarBlock:(void(^)(NSArray *daysArr, YXCalendarBaseModel *baseModel))calendarBlock;

/**
 * 组装阳历数据
 * @param dayModel 日期模型
 * @param boolContainsTerms 是否包含节气
 */
- (YXCalendarDayModel *)assemblyLunarCalendarDayModelByDayModel:(YXCalendarDayModel *)dayModel
                                              boolContainsTerms:(BOOL)boolContainsTerms;


/**
 * 获取单个阳历数据
 * @param value 指定年月日（YXCalendarYearModel，YXCalendarMonthModel，YXCalendarDayModel）
 * @param type 年月日类型
 * @param boolContainsTerms 是否包含节气
 *
 * @return dic{kYXCalendarMergeManagerLunarYear:@"", kYXCalendarMergeManagerLunarMonth:@"", kYXCalendarMergeManagerLunarDay:@""}
 */
- (NSDictionary *)assemblySingleLunarModelByValue:(id)value
                                         type:(YXCalendarBaseModelType)type
                            boolContainsTerms:(BOOL)boolContainsTerms;

/**
 * 获取年月日，持续时间，如1900~2021
 * @param startYears 起始时间
 * @param endYears 结束时间
 * @param boolOnlyCurrent 是否至含当月
 * @param boolContainsTerms 是否包含节气
 */
- (NSMutableArray *)assemblyDateByStartYears:(NSInteger)startYears
                                    endYears:(NSInteger)endYears
                             boolOnlyCurrent:(BOOL)boolOnlyCurrent
                           boolContainsTerms:(BOOL)boolContainsTerms;

/**
 * 月份切换(只适合从当前月开始往前推移)
 * @param type UIViewAnimationOptionTransitionCurlUp/UIViewAnimationOptionTransitionCurlDown 下一个月/上一个月
 * @param boolCurrent 是否是当前月
 * @param boolOnlyCurrent 是否只含当月
 * @param boolContainsTerms 是否包含节气
 */
- (void)monthChangeMethodByType:(UIViewAnimationOptions)type
                    boolCurrent:(BOOL)boolCurrent
                boolOnlyCurrent:(BOOL)boolOnlyCurrent
              boolContainsTerms:(BOOL)boolContainsTerms
                  calendarBlock:(void(^)(NSArray *daysArr))calendarBlock;

/**
 * 月份切换(可指定开始结束年月)
 * @param year 开始年
 * @param month 开始月
 * @param currentYear 当前年
 * @param currentMonth 当前月
 * @param boolOnlyCurrent 是否只含当月
 * @param boolContainsTerms 是否包含节气
 */
- (void)monthChangeMethodByYear:(NSInteger)year
                          month:(NSInteger)month
                    currentYear:(NSInteger)currentYear
                   currentMonth:(NSInteger)currentMonth
                boolOnlyCurrent:(BOOL)boolOnlyCurrent
              boolContainsTerms:(BOOL)boolContainsTerms
                  calendarBlock:(void(^)(NSArray *daysArr))calendarBlock;

@end

NS_ASSUME_NONNULL_END
