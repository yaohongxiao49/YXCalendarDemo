//
//  YXDateAlertView.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXDateAlertViewBtnType) {
    /** 取消 */
    YXDateAlertViewBtnTypeCancel,
    /** 确定 */
    YXDateAlertViewBtnTypeSure,
    /** 公历 */
    YXDateAlertViewBtnTypeSolar,
    /** 农历 */
    YXDateAlertViewBtnTypeLunar
};

typedef void(^YXDateAlertViewSureBlock)(YXCalendarDayModel *model);

@interface YXDateAlertView : UIView

/** 弹框控制器，用于dismiss */
@property (nonatomic, weak) TYAlertController *alertController;
@property (nonatomic, weak) YXCalendarDayModel *model;
@property (nonatomic, copy) YXDateAlertViewSureBlock yxDateAlertViewSureBlock;

/**
 * 初始化视图
 * @param frame 尺寸
 * @param startYear 起始年
 * @param endYear 结束年
 * @param boolChange 是否能切换公农历
 */
- (instancetype)initWithFrame:(CGRect)frame
                    startYear:(NSInteger)startYear
                      endYear:(NSInteger)endYear
                   boolChange:(BOOL)boolChange;

@end

NS_ASSUME_NONNULL_END
