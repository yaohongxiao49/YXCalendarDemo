//
//  YXCalendarDayCell.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCalendarDayCell : UICollectionViewCell

- (void)reloadValueByIndexPath:(NSIndexPath *)indexPath valueArr:(NSMutableArray *)valueArr boolShowLunarCalendar:(BOOL)boolShowLunarCalendar;

@end

NS_ASSUME_NONNULL_END
