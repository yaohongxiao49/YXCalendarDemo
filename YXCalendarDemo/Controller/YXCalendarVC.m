//
//  YXCalendarVC.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "YXCalendarVC.h"

@interface YXCalendarVC ()

@end

@implementation YXCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;

    [YXCalendarMergeManager yxShowCalendarViewByVC:self baseView:self.view frame:CGRectMake(10, 100, [[UIScreen mainScreen] bounds].size.width - 20, [[UIScreen mainScreen] bounds].size.height - 200) startYear:2020 endYear:2022 boolOnlyCurrent:NO boolShowLunarCalendar:YES boolContainsTerms:YES boolScrollView:YES];
}

@end
