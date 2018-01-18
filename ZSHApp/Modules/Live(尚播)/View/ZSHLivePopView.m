//
//  ZSHLivePopView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLivePopView.h"
#import "TLMenuButtonView.h"
#import "ZSHWeiboViewController.h"
#import "ZSHVideoViewController.h"
#import "ZSHPersonalDetailViewController.h"

@interface ZSHLivePopView ()

@property (nonatomic, assign) BOOL              ISShowMenuButton;
@property (nonatomic, weak)   TLMenuButtonView  *tlMenuView;
@property (nonatomic, strong) UIButton          *centerBtn;

@end

@implementation ZSHLivePopView

- (void)setup{
    kWeakSelf(self);
     _ISShowMenuButton = YES;
    _centerBtn = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth-kRealValue(50))/2, kRealValue(150)-kRealValue(50), kRealValue(50), kRealValue(50))];
    _centerBtn.layer.cornerRadius = kRealValue(25);
    [_centerBtn addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [_centerBtn setImage:[UIImage imageNamed:@"live_add"] forState:UIControlStateNormal];
    [self addSubview:_centerBtn];
    
    TLMenuButtonView *tlMenuView = [[TLMenuButtonView alloc]init];
    tlMenuView.centerPoint = _centerBtn.center;
    tlMenuView.clickLiveSubButton = ^(NSInteger tag){
        _ISShowMenuButton = YES;
        [weakself clickButton:tag];
    };
    _tlMenuView = tlMenuView;
    [self addSubview:tlMenuView];
    [tlMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_centerBtn);
        make.width.mas_equalTo(KScreenWidth);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(_centerBtn.mas_top);
    }];
    
//    CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI / 4 );
//    [_centerBtn setTransform:rotate];
    [_tlMenuView showItems];
}

#pragma getter
- (void)clickButton:(NSInteger)index {
    //ZSHBeginShowViewController
//    NSArray *VCS = @[@"ZSHWeiboWriteController",@"AlivcLivePushConfigViewController",@"ZSHVideoRecViewController"];
//    NSArray *fromclassTypes = @[@(FromTabbarToWeiboVC),@(FromTabbarToVideoVC), @(FromTabbarToPersonalDetailVC)];
    
   
    NSArray *VCS = @[@"ZSHWeiboWriteController",@"AlivcLivePusherViewController",@"ZSHVideoRecViewController"];
    NSArray *fromclassTypes = @[@(FromTabbarToWeiboVC),@"", @(FromTabbarToPersonalDetailVC)];
    
    Class className = NSClassFromString(VCS[index-1]);
    if (index != 2) {
         RootViewController *vc =  [[className alloc] initWithParamDic:@{KFromClassType:fromclassTypes[index-1]}];
        [ZSHBaseUIControl setAnimationWithHidden:YES view:self.superview completedBlock:^{
            [[kAppDelegate getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }];
    } else {//跳转直播预览页
         [[NSNotificationCenter defaultCenter] postNotificationName:KPresentPreviewVC object:nil];
    }

}


- (void)clickAddButton:(UIButton *)sender{
    [_tlMenuView dismiss];
    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionTransitionFlipFromTop  animations:^{
        
    } completion:^(BOOL finished) {
        [ZSHBaseUIControl setAnimationWithHidden:YES view:self.superview completedBlock:^{
        }];
    }];
   
//    if (!_ISShowMenuButton) {
//        [UIView animateWithDuration:0.2 animations:^{
////            CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI / 4 );
////            [sender setTransform:rotate];
//        }];
//        [_tlMenuView showItems];
//    }else{
//        [UIView animateWithDuration:0.2 animations:^{
//            CGAffineTransform rotate = CGAffineTransformMakeRotation( 0 );
//            [sender setTransform:rotate];
//        }];
//        [_tlMenuView dismiss];
//    }
//    _ISShowMenuButton = !_ISShowMenuButton;
}


@end
