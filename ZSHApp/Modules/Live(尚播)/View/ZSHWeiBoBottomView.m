//
//  ZSHWeiBoBottomView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHWeiBoBottomView.h"
#import "ZSHLiveLogic.h"
#import "ZSHReviewViewController.h"

@interface ZSHWeiBoBottomView ()

@property (nonatomic, strong) ZSHLiveLogic            *liveLogic;
@property (nonatomic, strong) ZSHWeiBoCellModel       *weiboCellModel;
@end

@implementation ZSHWeiBoBottomView

- (void)setup{
    
    self.backgroundColor = KClearColor;
    NSArray *imageArr = @[@"weibo_love",@"weibo_comment",@"weibo_present"];
    NSArray *titleArr = @[@"0",@"0",@"0"];
    for (int i = 0; i<3; i++) {
        NSDictionary *btnDic = @{@"title":titleArr[i],@"titleColor":KZSHColor929292,@"font":kPingFangRegular(18),@"backgroundColor":KClearColor};
        UIButton *btn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
        btn.tag = i+1;
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*KScreenWidth/3);
            make.width.mas_equalTo(KScreenWidth/3);
            make.height.mas_equalTo(kRealValue(22));
            make.centerY.mas_equalTo(self);
        }];
        
        [btn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(10)];
    }

}

- (void)btnAction:(UIButton*)btn{
    if (btn.tag == 1) {// 点赞
        [_liveLogic requestDotAgreeWithDic:@{@"HONOURUSER_ID":@"d6a3779de8204dfd9359403f54f7d27c",@"CIRCLE_ID":_weiboCellModel.CIRCLE_ID} success:^(id response) {
            UIButton *btn = [self viewWithTag:1];
            NSInteger count = [btn.titleLabel.text integerValue]+1;
            [btn setTitle:NSStringFormat(@"%zd", count) forState:UIControlStateNormal];
        }];
    } else if (btn.tag == 2) { // 评论
        ZSHReviewViewController *reviewVC = [[ZSHReviewViewController alloc] initWithParamDic:@{@"CircleID":_weiboCellModel.CIRCLE_ID,@"HONOURUSER_ID":_weiboCellModel.HONOURUSER_ID}];
        [[kAppDelegate getCurrentUIVC].navigationController pushViewController:reviewVC animated:true];
    } else if (btn.tag == 3) { // 礼物
        
    }
}

- (void)updateCellWithModel:(ZSHWeiBoCellModel *)model {
    UIButton *btn = [self viewWithTag:1];
    [btn setTitle:model.dotAgreeCount forState:UIControlStateNormal];
    UIButton *btn1 = [self viewWithTag:2];
    [btn1 setTitle:model.commentCount forState:UIControlStateNormal];
    UIButton *btn2 = [self viewWithTag:3];
    [btn2 setTitle:model.commentCount forState:UIControlStateNormal];
    self.weiboCellModel = model;
}

@end
