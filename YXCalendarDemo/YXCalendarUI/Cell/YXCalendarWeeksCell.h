//
//  YXCalendarWeeksCell.h
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCalendarWeeksCell : UICollectionViewCell

- (void)reloadValueByIndexPath:(NSIndexPath *)indexPath valueArr:(NSMutableArray *)valueArr;

@end

NS_ASSUME_NONNULL_END
