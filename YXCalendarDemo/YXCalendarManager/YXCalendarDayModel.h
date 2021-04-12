//
//  YXCalendarDayModel.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "YXCalendarBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCalendarDayModel : YXCalendarBaseModel

/** 这天是否是当天*/
@property (nonatomic, assign) BOOL boolCurrentDay;
/** 这天是否属于当前月*/
@property (nonatomic, assign) BOOL boolInCurrentMonth;

@end

NS_ASSUME_NONNULL_END
