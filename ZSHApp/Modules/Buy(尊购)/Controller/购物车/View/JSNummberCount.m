//
//  JSNummberCount.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSNummberCount.h"

static CGFloat const Wd = 15;

@interface JSNummberCount()
//加
@property (nonatomic, strong) UIButton    *addButton;
//减
@property (nonatomic, strong) UIButton    *subButton;


@end

@implementation JSNummberCount

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setUI];
}

#pragma mark -  set UI

- (void)setUI{
    
    self.backgroundColor = [UIColor clearColor];
    self.currentCountNumber = 0;
    self.totalNum = 0;
    kWeakSelf(self);
    /************************** 加 ****************************/
    _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subButton.frame = CGRectMake(0, 0, Wd,Wd);
    [_subButton setBackgroundImage:[UIImage imageNamed:@"goods_sub"]
                          forState:UIControlStateNormal];
    [_subButton setBackgroundImage:[UIImage imageNamed:@"goods_sub"]
                          forState:UIControlStateDisabled];
    _subButton.tag = 0;
    [[self.subButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        kStrongSelf(self);
        self.currentCountNumber--;
        if (self.NumberChangeBlock) {
            self.NumberChangeBlock(self.currentCountNumber);
        }
        
    }];
    [self addSubview:_subButton];
    
    /************************** 内容 ****************************/
    self.numberTT = [[UITextField alloc]init];
    self.numberTT.frame = CGRectMake(CGRectGetMaxX(_subButton.frame), 0, Wd*1.5, _subButton.frame.size.height);
    self.numberTT.keyboardType=UIKeyboardTypeNumberPad;
    self.numberTT.text=[NSString stringWithFormat:@"%@",@(0)];
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
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        kStrongSelf(self);
        self.currentCountNumber++;
        if (self.NumberChangeBlock) {
            self.NumberChangeBlock(self.currentCountNumber);
        }
    }];
    
    [self addSubview:_addButton];
    
     /************************** 内容改变 ****************************/
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextFieldTextDidEndEditingNotification" object:self.numberTT] subscribeNext:^(NSNotification *x) {
        kStrongSelf(self);
        UITextField *t1 = [x object];
        NSString *text = t1.text;
        NSInteger changeNum = 0;
        if (text.integerValue>self.totalNum&&self.totalNum!=0) {
            
            self.currentCountNumber = self.totalNum;
            self.numberTT.text = [NSString stringWithFormat:@"%@",@(self.totalNum)];
            changeNum = self.totalNum;
            
        } else if (text.integerValue<1){
            
            self.numberTT.text = @"1";
            changeNum = 1;
            
        } else {
            
            self.currentCountNumber = text.integerValue;
            changeNum = self.currentCountNumber;

        }
        if (self.NumberChangeBlock) {
            self.NumberChangeBlock(changeNum);
        }
        
    }];
    
    
    /* 捆绑加减的enable */
    RACSignal *subSignal =  [RACObserve(self, currentCountNumber) map:^id(NSNumber *subValue) {
        return @(subValue.integerValue>1);
    }];
    RACSignal *addSignal =  [RACObserve(self, currentCountNumber) map:^id(NSNumber *addValue) {
        return @(addValue.integerValue<self.totalNum);
    }];
    RAC(self.subButton,enabled)  = subSignal;
    RAC(self.addButton,enabled)  = addSignal;
    /* 内容颜色显示 */
    RACSignal *numColorSignal = [RACObserve(self, totalNum) map:^id(NSNumber *totalValue) {
//        return totalValue.integerValue==0?[UIColor redColor]:KZSHColor929292;
        return KZSHColor929292;
    }];
    RAC(self.numberTT,textColor) = numColorSignal;
    /*  */
    RACSignal *textSigal = [RACObserve(self, currentCountNumber) map:^id(NSNumber *Value) {
        return [NSString stringWithFormat:@"%@",Value];
    }];
    RAC(self.numberTT,text) = textSigal;
}


@end
