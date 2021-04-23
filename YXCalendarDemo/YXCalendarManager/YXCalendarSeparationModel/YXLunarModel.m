//
//  YXLunarModel.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/23.
//

#import "YXLunarModel.h"

@implementation YXLunarModel

#pragma mark - 初始化
- (instancetype)initWithYear:(int)year month:(int)month day:(int)day {

    self = [super init];
    if (self) {
        _lunarYear = year;
        _lunarMonth = month;
        _lunarDay = day;
    }
    return self;
}

@end
