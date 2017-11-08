//
//  ZSHTextFieldCellView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/9/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"

typedef NS_ENUM(NSInteger,ZSHTextFieldViewType){
    ZSHTextFieldViewUser,
    ZSHTextFieldViewID,
    ZSHTextFieldViewPwd,
    ZSHTextFieldViewPhone,
    ZSHTextFieldViewCardNumer,
    ZSHTextFieldViewCaptcha,
    ZSHTextFieldViewGoldAlert,
    ZSHTextFieldViewNone
};

typedef void (^TextFieldChanged)(NSString *);

@interface ZSHTextFieldCellView : ZSHBaseView

@property (nonatomic,copy)TextFieldChanged textFieldChanged;
@end
