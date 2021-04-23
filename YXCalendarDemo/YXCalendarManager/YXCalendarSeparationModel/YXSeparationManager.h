//
//  YXSeparationManager.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/23.
//

#import <Foundation/Foundation.h>
#import "YXLunarModel.h"
#import "YXSolarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXSeparationManager : NSObject

+ (instancetype)sharedManager;

/** 农历转公历 */
+ (YXSolarModel *)solarFromLunar:(YXLunarModel *)lunar;

/** 公历转农历 */
+ (YXLunarModel *)lunarFromSolar:(YXSolarModel *)solar;

/** 公历年转农历年 */
+ (NSString *)lunarYearFromSolarYear:(NSInteger)solarYear;

/** 农历转字符串 */
+ (NSString *)stringFromLunar:(YXLunarModel *)lunar;

/** 获取农历月数据 */
+ (NSArray *)getLunarMonthArr;

/** 获取农历日数据 */
+ (NSArray *)getLunarDayArr;

@end

NS_ASSUME_NONNULL_END
