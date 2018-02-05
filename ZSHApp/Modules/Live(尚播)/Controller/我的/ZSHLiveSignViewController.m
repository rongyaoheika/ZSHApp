//
//  ZSHLiveSignViewController.m
//  ZSHApp
//
//  Created by mac on 05/02/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHLiveSignViewController.h"
#import <FSCalendar.h>

@interface ZSHLiveSignViewController ()<FSCalendarDataSource,FSCalendarDelegate>

@property (nonatomic, strong) UIButton *signBtn;
@property (nonatomic, strong) NSTimer  *timer;
@property (nonatomic,   weak) FSCalendar *calendar;

@end

@implementation ZSHLiveSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
}

- (void)createUI{
    self.title = @"签到";

    // 设置签到按钮
    _signBtn = [[UIButton alloc] initWithFrame:CGRectMake(146.5, 112.5, 82, 82)];
    [self.view addSubview:_signBtn];
    _signBtn.backgroundColor = KZSHColor262626;
    _signBtn.layer.cornerRadius = _signBtn.frame.size.width * 0.5;
    _signBtn.layer.masksToBounds = YES;
    [self.view addSubview:_signBtn];
    //    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *topLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"签到",@"font":kPingFangMedium(17)}];
    topLabel.frame = CGRectMake(24, 32.5, 35, 18);
    [_signBtn addSubview:topLabel];

    UILabel *bottomLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"已签到20天",@"font":kPingFangRegular(12)}];
    bottomLabel.frame = CGRectMake(9, 55, 70, 13);
    [_signBtn addSubview:bottomLabel];
    
    _timer= [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(btnClick:) userInfo:nil repeats:YES];
    [_timer fire];
    
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 260, kScreenWidth, 300)];
    calendar.scrollEnabled = false;
    calendar.locale = [NSLocale currentLocale];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = KBlackColor;
//    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesDefaultCase;
    calendar.appearance.todayColor = KZSHColorFD5739;;
    calendar.appearance.headerDateFormat = @"YYYY年M月";
    calendar.appearance.headerTitleFont  = kPingFangRegular(12);
    calendar.appearance.todayColor = KBlackColor;
    calendar.appearance.titleTodayColor = KZSHColor929292;
    calendar.appearance.headerTitleColor = KZSHColor929292;
    calendar.appearance.weekdayTextColor = KZSHColorFD5739;
    calendar.appearance.titleDefaultColor = KZSHColor929292;
    calendar.appearance.titleSelectionColor = KBlackColor;
    calendar.appearance.selectionColor = [UIColor whiteColor];
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    
    NSString *day = @"2017/9/21";
    NSDateFormatter *_dateFormatter1 = [[NSDateFormatter alloc] init];
    _dateFormatter1.dateFormat = @"yyyy/MM/dd";
    [calendar selectDate:[_dateFormatter1 dateFromString:day]];
    
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    calendar.allowsSelection = false;
}


- (void)btnClick:(UIButton *)btn {

    // 1.创建一个圆圈view
    UIView *circleView = [[UIView alloc] init];
    circleView.backgroundColor = KZSHColor262626;
    circleView.frame = _signBtn.frame;
    
    //    [self.view addSubview:circleView];
    // 把圆圈添加到控制器的view上并且加上支付宝按钮的上面
    //    [self.view insertSubview:circleView aboveSubview:btn];
    // 在支付宝按钮按钮下面插入一个view
    [self.view insertSubview:circleView belowSubview:_signBtn];
    circleView.layer.cornerRadius = circleView.frame.size.width * 0.5;
    
    circleView.layer.masksToBounds = YES;
    
    // 让每一个圆圈延迟时间不一样
    [UIView animateWithDuration:0.9 delay:0 options:0 animations:^{
        circleView.transform = CGAffineTransformMakeScale(1.7, 1.7);
        circleView.alpha = 0;
    } completion:^(BOOL finished) {
        [circleView removeFromSuperview];
    }];
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
