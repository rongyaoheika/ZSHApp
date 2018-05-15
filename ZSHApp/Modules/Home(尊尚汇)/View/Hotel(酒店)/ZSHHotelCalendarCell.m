//
//  ZSHHotelCalendarCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelCalendarCell.h"

static 
@interface ZSHHotelCalendarCell()

@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIButton *dateBtn;
@property (nonatomic, strong) UIButton *leaveBtn;

@end

@implementation ZSHHotelCalendarCell

- (void)setup{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(calenderDateChanged:) name:KCalendarDateChanged object:nil];
    
    NSString *currentDay = [ZSHBaseFunction getCurrentTime];
    NSDictionary *leftTopDic = @{@"text":@"入住",@"font":kPingFangRegular(11),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(11)};
    NSDictionary *leftBottomDic = @{@"text":currentDay,@"font":kPingFangRegular(15),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(15)};
    UIButton *checkBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:leftTopDic bottomDic:leftBottomDic];
    checkBtn.tag = 1;
    [checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:checkBtn];
     [self addSubview:checkBtn];
    _checkBtn = checkBtn;
     [[NSUserDefaults standardUserDefaults]setObject:currentDay forKey:@"beginDate"];
    
    NSDictionary *dateBtnDic = @{@"title":@"共1天",@"font":kPingFangMedium(15)};
    UIButton *dateBtn = [ZSHBaseUIControl  createBtnWithParamDic:dateBtnDic target:self action:nil];
//    [self.contentView addSubview:dateBtn];
     [self addSubview:dateBtn];
     [ZSHSpeedy zsh_chageControlCircularWith:dateBtn AndSetCornerRadius:kRealValue(12) SetBorderWidth:1 SetBorderColor:KZSHColor979797 canMasksToBounds:YES];
    _dateBtn = dateBtn;
    
    NSString *endDay = [ZSHBaseFunction  GetTomorrowDay:[ZSHBaseFunction dateFromString:[ZSHBaseFunction getCurrentTime]]];
    NSDictionary *rightTopDic = @{@"text":@"离开",@"font":kPingFangRegular(11),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(11)};
    NSDictionary *rightBottomDic = @{@"text":endDay,@"font":kPingFangRegular(15),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(15)};
    UIButton *leaveBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:rightTopDic bottomDic:rightBottomDic];
    leaveBtn.tag = 2;
    [leaveBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:leaveBtn];
     [self addSubview:leaveBtn];
    
    _leaveBtn = leaveBtn;
    [[NSUserDefaults standardUserDefaults]setObject:endDay forKey:@"endDate"];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"days"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(kRealValue(16));
        make.width.mas_equalTo((KScreenWidth-kRealValue(70))/2);
        make.height.mas_equalTo(kRealValue(35));
    }];
    
    [_dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(_checkBtn);
        make.height.mas_equalTo(kRealValue(23));
        make.width.mas_equalTo(kRealValue(70));
    }];
    
    [_leaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(_checkBtn);
        make.width.mas_equalTo(_checkBtn);
        make.height.mas_equalTo(_checkBtn);
    }];
  
    RLog(@" layoutSubviews 中cell.frame==%@,cell.contentView.frame == %@",NSStringFromCGRect(self.frame),NSStringFromCGRect(self.contentView.frame));
}

- (void)checkBtnAction:(UIButton *)btn{
    if (self.dateViewTapBlock) {
        self.dateViewTapBlock(btn.tag);
    }
}

- (void)calenderDateChanged:(NSNotification *)noti{
    NSString *dateStr = noti.object[@"dateStr"];
    NSInteger btnTag = [noti.object[@"btnTag"]integerValue];
   
    if (btnTag==1) {
        [[NSUserDefaults standardUserDefaults]setObject:dateStr forKey:@"beginDate"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        UILabel *checkBtnLB = [_checkBtn viewWithTag:21];
        checkBtnLB.text = dateStr;
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:dateStr forKey:@"endDate"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UILabel *leaveBtnLB = [_leaveBtn viewWithTag:21];
        leaveBtnLB.text = dateStr;
        [self getDaysCount];
    }
    
}

- (void)getDaysCount{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"beginDate"]&&[[NSUserDefaults standardUserDefaults]objectForKey:@"endDate"]) {
        NSDate *beginDate = [ZSHBaseFunction dateFromString:[[NSUserDefaults standardUserDefaults]objectForKey:@"beginDate"]];
        NSDate *endDate = [ZSHBaseFunction dateFromString:[[NSUserDefaults standardUserDefaults]objectForKey:@"endDate"]];
        NSInteger days = [ZSHBaseFunction getDaysFrom:beginDate To:endDate];
        [_dateBtn setTitle:[NSString stringWithFormat:@"共%ld天",days] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",days] forKey:@"days"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
