//
//  ZSHBaseView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/9/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSHBaseModel.h"

typedef void(^DismissViewBlock) (id);
typedef void(^ConfirmBtnBlock) (id);
typedef void(^BtnClickBlock)(id);
@interface ZSHBaseView : UIView

@property (nonatomic, strong)NSDictionary     *paramDic;
@property (nonatomic, strong)ZSHBaseModel     *model;
@property (nonatomic, copy) DismissViewBlock  dissmissViewBlock;
@property (nonatomic, copy) ConfirmBtnBlock   goldConfrimBlock;
@property (nonatomic, copy) BtnClickBlock     btnClickBlock;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame paramDic:(NSDictionary *)paramDic;
- (void)updateViewWithParamDic:(NSDictionary *)paramDic;
- (void)setup;

@end
