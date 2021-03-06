//
//  YXCalendarMonthModel.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/16.
//

#import <Foundation/Foundation.h>
#import "YXCalendarDayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCalendarMonthModel : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, strong) NSMutableArray<YXCalendarDayModel *> *dayArr;

@end

NS_ASSUME_NONNULL_END
