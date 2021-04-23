//
//  YXSolarModel.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/23.
//

#import "YXSolarModel.h"

@implementation YXSolarModel

#pragma mark - 初始化
- (instancetype)initWithYear:(int)year month:(int)month day:(int)day {

    self = [super init];
    if (self) {
        _solarYear = year;
        _solarMonth = month;
        _solarDay = day;
    }
    return self;
}

@end
