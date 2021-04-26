//
//  YXWeeksView.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YXWeeksViewMonthBlock)(YXCalendarMonthType type);

@interface YXWeeksView : UIView

@property (nonatomic, copy) YXCalendarMonthModel *monthModel;

@property (nonatomic, copy) YXWeeksViewMonthBlock yxWeeksViewMonthBlock;

@end

NS_ASSUME_NONNULL_END
