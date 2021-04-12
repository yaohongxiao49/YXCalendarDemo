//
//  YXCalendarWeeksCell.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "YXCalendarWeeksCell.h"

@interface YXCalendarWeeksCell ()

@property (nonatomic, strong) UILabel *weeksLab;

@end

@implementation YXCalendarWeeksCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

- (void)reloadValueByIndexPath:(NSIndexPath *)indexPath valueArr:(NSMutableArray *)valueArr {
    
    self.weeksLab.text = valueArr[indexPath.row];
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.weeksLab.text = @"日";
}

#pragma mark - 懒加载
- (UILabel *)weeksLab {
    
    if (!_weeksLab) {
        _weeksLab = [[UILabel alloc] init];
        _weeksLab.textColor = [UIColor whiteColor];
        _weeksLab.textAlignment = NSTextAlignmentCenter;
        _weeksLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_weeksLab];
        
        [_weeksLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self.contentView);
        }];
    }
    return _weeksLab;
}

@end
