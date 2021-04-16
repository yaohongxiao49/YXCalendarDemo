//
//  YXCalendarYearModel.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/16.
//

#import <Foundation/Foundation.h>
#import "YXCalendarMonthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCalendarYearModel : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, strong) NSMutableArray<YXCalendarMonthModel *> *monthArr;

@end

NS_ASSUME_NONNULL_END
