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

- (void)reloadValueByIndexPath:(NSIndexPath *)indexPath valueArr:(NSMutableArray *)valueArr boolShowLunarCalendar:(BOOL)boolShowLunarCalendar {
    
    YXCalendarDayModel *dayModel = valueArr[indexPath.row];
    
    [self bgViewLayerBorderByBoolBorder:dayModel.boolCurrentDay];
    [self bgViewBgColorByBoolSelected:dayModel.boolSelected];
    
    self.solarCalendarLab.text = [NSString stringWithFormat:@"%ld", dayModel.day];
    YXCalendarDayModel *holidayModel = [[YXCalendarMergeManager sharedManager] assemblyLunarCalendarDayModelByDayModel:dayModel boolContainsTerms:boolShowLunarCalendar];
    self.lunarCalendarLab.text = holidayModel.holidayNamed ? : @"";
    
    [self titleColorByBoolCurrentMonth:dayModel.monthType == YXCalendarMonthTypeCurrent boolHoliday:boolShowLunarCalendar ? holidayModel.boolHoliday : NO];
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

#pragma mark - 背景视图色值变化
- (void)bgViewBgColorByBoolSelected:(BOOL)boolSelected {

    if (boolSelected) {
        _bgView.backgroundColor = [UIColor colorWithRed:225 /255.0 green:225 /255.0 blue:225 /255.0 alpha:0.2];
    }
    else {
        _bgView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - 文字显示色值变化
- (void)titleColorByBoolCurrentMonth:(BOOL)boolCurrentMonth boolHoliday:(BOOL)boolHoliday {
    
    if (boolCurrentMonth) {
        self.solarCalendarLab.textColor = [UIColor whiteColor];
        self.lunarCalendarLab.textColor = boolHoliday ? [UIColor colorWithRed:255 /255.0 green:221 /255.0 blue:0 /255.0 alpha:1] : [UIColor colorWithRed:220 /255.0 green:220 /255.0 blue:220 /255.0 alpha:1];
    }
    else {
        self.solarCalendarLab.textColor = [UIColor colorWithRed:112 /255.0 green:112 /255.0 blue:112 /255.0 alpha:1];
        self.lunarCalendarLab.textColor = boolHoliday ? [UIColor colorWithRed:145 /255.0 green:133 /255.0 blue:58 /255.0 alpha:1] : [UIColor colorWithRed:112 /255.0 green:112 /255.0 blue:112 /255.0 alpha:1];
    }
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.solarCalendarLab.text = @"阳历";
    self.lunarCalendarLab.text = @"阴历";
    [self bgViewLayerBorderByBoolBorder:YES];
}

#pragma mark - 懒加载
- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _bgView.layer.borderWidth = 0;
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self.contentView);
        }];
    }
    return _bgView;
}
- (UILabel *)solarCalendarLab {
    
    if (!_solarCalendarLab) {
        _solarCalendarLab = [[UILabel alloc] init];
        _solarCalendarLab.textColor = [UIColor whiteColor];
        _solarCalendarLab.textAlignment = NSTextAlignmentCenter;
        _solarCalendarLab.font = [UIFont systemFontOfSize:12];
        [self.bgView addSubview:_solarCalendarLab];
        
        [_solarCalendarLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.bgView).with.offset(5);
            make.left.equalTo(self.bgView).with.offset(5);
            make.right.equalTo(self.bgView).with.offset(-5);
        }];
    }
    return _solarCalendarLab;
}
- (UILabel *)lunarCalendarLab {
    
    if (!_lunarCalendarLab) {
        _lunarCalendarLab = [[UILabel alloc] init];
        _lunarCalendarLab.textColor = [UIColor colorWithRed:220 /255.0 green:220 /255.0 blue:220 /255.0 alpha:1];
        _lunarCalendarLab.textAlignment = NSTextAlignmentCenter;
        _lunarCalendarLab.font = [UIFont systemFontOfSize:9];
        [self.bgView addSubview:_lunarCalendarLab];
        
        [_lunarCalendarLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.equalTo(self.solarCalendarLab);
            make.top.equalTo(self.solarCalendarLab.mas_bottom).with.offset(5);
            make.bottom.equalTo(self.bgView).with.offset(-5);
        }];
    }
    return _lunarCalendarLab;
}

@end
