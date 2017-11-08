//
//  JSCartBar.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

static NSInteger const BalanceButtonTag = 120;

static NSInteger const DeleteButtonTag = 121;

static NSInteger const SelectButtonTag = 122;

#import "JSCartBar.h"

@interface JSCartBar ()

@end

@implementation JSCartBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBarUI];
    }
    return self;
}

- (void)setBarUI{
    
    self.backgroundColor = KZSHColor0B0B0B;
    /* 背景 */
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    effectView.userInteractionEnabled = NO;
//    effectView.frame = self.bounds;
//    [self addSubview:effectView];
    
    CGFloat wd = KScreenWidth*2/7;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
    lineView.backgroundColor  = [UIColor colorWithHexString:@"1D1D1D"];
    [self addSubview:lineView];
    /* 结算 */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"141414"]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"141414"]] forState:UIControlStateDisabled];
    [button setTitle:@"去结算" forState:UIControlStateNormal];
    button.titleLabel.font = kPingFangMedium(17);
    [button setFrame:CGRectMake(KScreenWidth-wd, 0, wd, self.frame.size.height)];
    [button setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
    [button setTitleColor:KZSHColor929292 forState:UIControlStateDisabled];
    button.enabled = NO;
    button.tag = BalanceButtonTag;
    [self addSubview:button];
    _balanceButton = button;
    /* 删除 */
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [button1 setTitle:@"删除" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [button1 setFrame:CGRectMake(KScreenWidth-wd, 0, wd, self.frame.size.height)];
    button1.enabled = NO;
    button1.hidden = YES;
    button1.tag = DeleteButtonTag;
    [self addSubview:button1];
    _deleteButton = button1;
    /* 全选 */
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"全选"
             forState:UIControlStateNormal];
    [button3 setTitleColor:KZSHColor929292
                  forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"goods_choose_normal"]
             forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"goods_choose_press"]
             forState:UIControlStateSelected];
    [button3 setFrame:CGRectMake(0, 0, 78, self.frame.size.height)];
    [button3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    button3.titleLabel.font = kPingFangLight(12);
    button3.tag = SelectButtonTag;
    [self addSubview:button3];
    _selectAllButton = button3;
    /* 价格 */
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(wd, 0, KScreenWidth-wd*2-5, self.frame.size.height)];
    label1.text = [NSString stringWithFormat:@"总计￥:%@",@(00.00)];
    label1.textColor = KZSHColor929292;
    label1.font = kPingFangLight(15);
    label1.textAlignment = NSTextAlignmentRight;
    [self addSubview:label1];
    _allMoneyLabel = label1;
    
    /* assign value */
    kWeakSelf(self);
    [RACObserve(self, money) subscribeNext:^(NSNumber *x) {
        kStrongSelf(self);
        self.allMoneyLabel.text = [NSString stringWithFormat:@"总计￥:%.2f",x.floatValue];
    }];
    
    /*  RAC BLIND  */
    RACSignal *comBineSignal = [RACSignal combineLatest:@[RACObserve(self, money)]
                                                 reduce:^id(NSNumber *moeny){
                                                     if (moeny.floatValue == 0) {
                                                         self.selectAllButton.selected = NO;
                                                     }
                                                     return @(moeny.floatValue>0);
                                                 }];

    RAC(self.balanceButton,enabled) = comBineSignal;
    RAC(self.deleteButton,enabled) = comBineSignal;
    
    [RACObserve(self, isNormalState) subscribeNext:^(NSNumber *x) {
        kStrongSelf(self);
        BOOL isNormal =  x.boolValue;
        self.balanceButton.hidden = !isNormal;
        self.allMoneyLabel.hidden = !isNormal;
        self.deleteButton.hidden = isNormal;
    }];
}

@end
