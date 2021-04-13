//
//  YXCalendarDayCell.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "YXCalendarDayCell.h"

@interface YXCalendarDayCell ()

@property (nonatomic, strong) UIView *bgView; //背景视图
@property (nonatomic, strong) UILabel *lunarCalendarLab; /** 阴历 */
@property (nonatomic, strong) UILabel *solarCalendarLab; /** 阳历 */

@end

@implementation YXCalendarDayCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

- (void)reloadValueByIndexPath:(NSIndexPath *)indexPath valueArr:(NSMutableArray *)valueArr {
    
    YXCalendarDayModel *dayModel = valueArr[indexPath.row];
    
    _lunarCalendarLab.text = [NSString stringWithFormat:@"%ld", dayModel.day];
    _solarCalendarLab.text = [[YXCalendarManager sharedManager] assemblySolarCalendarDayModelByDayModel:dayModel] ? :@"";
    
    [self bgViewLayerBorderByBoolBorder:dayModel.boolCurrentDay];
    [self bgViewBgColorByBoolCurrentMonth:dayModel.boolInCurrentMonth];
}

#pragma mark - 背景视图边框变化
- (void)bgViewLayerBorderByBoolBorder:(BOOL)boolBorder {
    
    if (boolBorder) {
        _bgView.layer.borderWidth = 1;
    }
    else {
        _bgView.layer.borderWidth = 0;
    }
}

#pragma mark - 背景视图背景色变化
- (void)bgViewBgColorByBoolCurrentMonth:(BOOL)boolCurrentMonth {
    
    if (boolCurrentMonth) {
        _bgView.backgroundColor = [UIColor redColor];
    }
    else {
        _bgView.backgroundColor = [UIColor colorWithRed:220 /255.0 green:220 /255.0 blue:220 /255.0 alpha:0.2];
    }
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.lunarCalendarLab.text = @"阴历";
    self.solarCalendarLab.text = @"阳历";
    [self bgViewLayerBorderByBoolBorder:YES];
}

#pragma mark - 懒加载
- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor redColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = [UIColor blackColor].CGColor;
        _bgView.layer.borderWidth = 0;
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self.contentView);
        }];
    }
    return _bgView;
}
- (UILabel *)lunarCalendarLab {
    
    if (!_lunarCalendarLab) {
        _lunarCalendarLab = [[UILabel alloc] init];
        _lunarCalendarLab.textColor = [UIColor whiteColor];
        _lunarCalendarLab.textAlignment = NSTextAlignmentCenter;
        _lunarCalendarLab.font = [UIFont systemFontOfSize:12];
        [self.bgView addSubview:_lunarCalendarLab];
        
        [_lunarCalendarLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.bgView).with.offset(5);
            make.left.equalTo(self.bgView).with.offset(5);
            make.right.equalTo(self.bgView).with.offset(-5);
        }];
    }
    return _lunarCalendarLab;
}
- (UILabel *)solarCalendarLab {
    
    if (!_solarCalendarLab) {
        _solarCalendarLab = [[UILabel alloc] init];
        _solarCalendarLab.textColor = [UIColor colorWithRed:220 /255.0 green:220 /255.0 blue:220 /255.0 alpha:1];
        _solarCalendarLab.textAlignment = NSTextAlignmentCenter;
        _solarCalendarLab.font = [UIFont systemFontOfSize:9];
        [self.bgView addSubview:_solarCalendarLab];
        
        [_solarCalendarLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.equalTo(self.lunarCalendarLab);
            make.top.equalTo(self.lunarCalendarLab.mas_bottom).with.offset(5);
            make.bottom.equalTo(self.bgView).with.offset(-5);
        }];
    }
    return _solarCalendarLab;
}

@end
