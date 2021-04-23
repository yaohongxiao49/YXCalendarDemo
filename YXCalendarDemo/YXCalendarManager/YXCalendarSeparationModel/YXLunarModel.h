//
//  YXLunarModel.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXLunarModel : NSObject

/** 是否闰月 */
@property (nonatomic, assign) BOOL isLeap;
/** 农历日 */
@property (nonatomic, assign) int lunarDay;
/** 农历月 */
@property (nonatomic, assign) int lunarMonth;
/** 农历年 */
@property (nonatomic, assign) int lunarYear;

/** 初始化 */
- (instancetype)initWithYear:(int)year month:(int)month day:(int)day;

@end

NS_ASSUME_NONNULL_END
