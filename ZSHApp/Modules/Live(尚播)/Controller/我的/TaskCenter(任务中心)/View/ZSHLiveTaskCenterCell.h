//
//  ZSHLiveTaskCenterCell.h
//  ZSHApp
//
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"

@interface ZSHLiveTaskCenterCell : ZSHBaseCell

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UIImageView *activityImage;
@property (nonatomic, strong) UIButton    *finishBtn;

@end
