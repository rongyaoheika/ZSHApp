//
//  ZSHLivePersonInfoView.h
//  ZSHApp
//
//  Created by apple on 2017/11/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"
#import "ZSHTogetherLogic.h"


@interface ZSHLivePersonInfoView : ZSHBaseView

@property (nonatomic, strong) ZSHTogetherLogic    *togetherLogic;
@property (nonatomic, strong) UIButton            *addFriendBtn;

@end
