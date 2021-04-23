//
//  YXSolarModel.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXSolarModel : NSObject

/** 公历日 */
@property (nonatomic, assign) int solarDay;
/** 公历月 */
@property (nonatomic, assign) int solarMonth;
/** 公历年 */
@property (nonatomic, assign) int solarYear;

/** 初始化 */
- (instancetype)initWithYear:(int)year month:(int)month day:(int)day;

@end

NS_ASSUME_NONNULL_END
