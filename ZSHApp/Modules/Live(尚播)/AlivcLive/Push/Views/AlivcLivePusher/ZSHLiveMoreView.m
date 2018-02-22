//
//  ZSHLiveMoreView.m
//  ZSHApp
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHLiveMoreView.h"
#import <AlivcLivePusher/AlivcLivePusherHeader.h>

@interface ZSHLiveMoreView ()

@property (nonatomic, strong) AlivcLivePushConfig *config;

@end

@implementation ZSHLiveMoreView

- (void)setup{
    self.config = self.paramDic[@"config"];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.90];

    CGFloat height = CGRectGetHeight(self.frame);

    NSArray *btnDicArr = @[
  @[
  @{@"btnNormalImage":@"camera_id",@"btnSelectImage":@"camera_id",@"btnTitle":@"反转"},
  @{@"btnNormalImage":@"camera_flash_close",@"btnSelectImage":@"camera_flash_on",@"btnTitle":@"闪光灯"},
  @{@"btnNormalImage":@"music_button",@"btnSelectImage":@"music_button",@"btnTitle":@"音乐"},
  @{@"btnNormalImage":@"record_beauty_on",@"btnSelectImage":@"record_beauty_on",@"btnTitle":@"美颜"},
  ],
  
  @[
  @{@"btnNormalImage":@"camera_id",@"btnSelectImage":@"camera_id",@"btnTitle":@"反转"},
  @{@"btnNormalImage":@"camera_flash_close",@"btnSelectImage":@"camera_flash_on",@"btnTitle":@"闪光灯"},
  @{@"btnNormalImage":@"music_button",@"btnSelectImage":@"music_button",@"btnTitle":@"音乐"},
  @{@"btnNormalImage":@"camera_flash_close",@"btnSelectImage":@"camera_flash_on",@"btnTitle":@"闪光灯"},
  ],
  
  @[
  @{@"btnNormalImage":@"camera_id",@"btnSelectImage":@"camera_id",@"btnTitle":@"反转"},
  @{@"btnNormalImage":@"camera_flash_close",@"btnSelectImage":@"camera_flash_on",@"btnTitle":@"闪光灯"},
  @{@"btnNormalImage":@"music_button",@"btnSelectImage":@"music_button",@"btnTitle":@"音乐"},
  @{@"btnNormalImage":@"camera_flash_close",@"btnSelectImage":@"camera_flash_on",@"btnTitle":@"闪光灯"},
  ]
  ];
    
    for (int i = 0; i<3; i++) {
        for (int j = 0; j <4; j++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(j*kScreenWidth/4, i*(height/3), kScreenWidth/4,height/3)];
            [btn setImage:[UIImage imageNamed:btnDicArr[i][j][@"btnNormalImage"]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:btnDicArr[i][j][@"btnSelectImage"]] forState:UIControlStateSelected];
            [btn setTitle:btnDicArr[i][j][@"btnTitle"] forState:UIControlStateNormal];
            [btn setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
            [btn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleTop imageTitleSpace:kRealValue(5.0)];
            btn.titleLabel.font = kPingFangRegular(12);
            btn.tag = i*4+j;
            [btn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (btn.tag == 1) {//闪光灯
                [btn setSelected:self.config.flash];
                [btn setEnabled:self.config.cameraType==AlivcLivePushCameraTypeFront?NO:YES];
            }
        }
    }
}

- (void)moreBtnAction:(UIButton *)btn{
    if (self.btnClickBlock) {
        self.btnClickBlock(btn);
    }
}

@end
