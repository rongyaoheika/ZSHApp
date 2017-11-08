//
//  ZSHGameCenterViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGameCenterViewController.h"

@interface ZSHGameCenterViewController ()

@end

@implementation ZSHGameCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
}

- (void)createUI{
    self.title = @"游戏中心";
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, kScreenWidth, kRealValue(350))];
    bgImageView.image = [UIImage imageNamed:@"game_bg"];
    [self.view addSubview:bgImageView];
    
    NSArray *imageArr = @[@"game_image_2",@"game_image_3",@"game_image_4",@"game_image_5",@"game_image_6",@"game_image_7"];
    for (int i = 0; i<imageArr.count; i++) {
        UIButton *gameBtn = [[UIButton alloc]init];
        UIImage *bgImage = [UIImage imageNamed:imageArr[i]];
        CGFloat top = kRealValue(57.5) + i/2 *(kRealValue(30) + bgImage.size.height);
        [gameBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [self.view addSubview:gameBtn];
        
        [gameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(bgImage.size);
            make.top.mas_equalTo(bgImageView).offset(top);
            if (!(i%2)) {//左边
                make.left.mas_equalTo(self.view).offset(kRealValue(19));
            }else {
                make.right.mas_equalTo(self.view).offset(-kRealValue(19));
            }
        }];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
