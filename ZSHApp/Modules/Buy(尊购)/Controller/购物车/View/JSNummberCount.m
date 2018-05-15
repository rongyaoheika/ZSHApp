//
//  JSNummberCount.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSNummberCount.h"

static CGFloat const Wd = 20;

@interface JSNummberCount()
//加
@property (nonatomic, strong) UIButton    *addButton;
//减
@property (nonatomic, strong) UIButton    *subButton;


@end

@implementation JSNummberCount

- (void)setup{
    
    self.currentCountNumber = 0;
    self.totalNum = 0;
    
    kWeakSelf(self);
    /************************** 减 ****************************/
    _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subButton.frame = CGRectMake(0, 0, Wd,Wd);
    [_subButton setBackgroundImage:[UIImage imageNamed:@"goods_sub"]
                          forState:UIControlStateNormal];
    [_subButton setBackgroundImage:[UIImage imageNamed:@"goods_sub"]
                          forState:UIControlStateDisabled];
    _subButton.tag = 0;
    [_subButton addTapBlock:^(UIButton *btn) {
        weakself.currentCountNumber--;
        weakself.numberTT.text = [NSString stringWithFormat:@"%@",@(weakself.currentCountNumber)];
        if (weakself.NumberChangeBlock) {
            weakself.NumberChangeBlock(weakself.currentCountNumber);
        }
    }];
    [self addSubview:_subButton];
    
    /************************** 内容 ****************************/
    self.numberTT = [[UITextField alloc]init];
    self.numberTT.frame = CGRectMake(CGRectGetMaxX(_subButton.frame), 0, Wd*1.5, _subButton.frame.size.height);
    self.numberTT.keyboardType=UIKeyboardTypeNumberPad;
    self.numberTT.text=[NSString stringWithFormat:@"%@",@(1)];
    self.numberTT.backgroundColor = KClearColor;
    self.numberTT.textColor = KZSHColor929292;
    self.numberTT.adjustsFontSizeToFitWidth = YES;
    self.numberTT.textAlignment=NSTextAlignmentCenter;
    self.numberTT.layer.borderColor = KZSHColor929292.CGColor;
    self.numberTT.layer.borderWidth = 0.5;
    self.numberTT.font= kPingFangRegular(12);
    [self addSubview:self.numberTT];
    
    /************************** 加 ****************************/
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(CGRectGetMaxX(_numberTT.frame), 0, Wd,Wd);
    [_addButton setBackgroundImage:[UIImage imageNamed:@"goods_add"]
                          forState:UIControlStateNormal];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"goods_add"]
                          forState:UIControlStateDisabled];
    _addButton.tag = 1;
    [_addButton addTapBlock:^(UIButton *btn) {
        
        weakself.currentCountNumber++;
        weakself.numberTT.text = [NSString stringWithFormat:@"%@",@(weakself.currentCountNumber)];
        if (weakself.NumberChangeBlock) {
            weakself.NumberChangeBlock(weakself.currentCountNumber);
        }
    }];
    [self addSubview:_addButton];
    
     /************************** 内容改变 ****************************/
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldChange:) name:@"UITextFieldTextDidEndEditingNotification" object:nil];
    [self.numberTT addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldEditChanged:(UITextField *)textField {
    
//    NSString *text = textField.text;
    
//    NSInteger changeNum = 0;
//    if (text.integerValue>self.totalNum&&self.totalNum!=0) {
//
//        self.currentCountNumber = self.totalNum;
//        self.numberTT.text = [NSString stringWithFormat:@"%@",@(self.totalNum)];
//        changeNum = self.totalNum;
//
//    } else if (text.integerValue<1){
//
//        self.numberTT.text = @"1";
//        changeNum = 1;
//
//    } else {
//
//        self.currentCountNumber = text.integerValue;
//        changeNum = self.currentCountNumber;
//
//    }
    if (self.NumberChangeBlock) {
        self.NumberChangeBlock([textField.text integerValue]);
    }

}

@end
