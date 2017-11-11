//
//  ZSHGuideCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGuideCell.h"

@interface ZSHGuideCell ()


@property (nonatomic,weak) UIButton *guideBtn;          //开始按钮
@property (nonatomic,weak) UIImageView *imageView;         //可以复用的imageView

@end

@implementation ZSHGuideCell

-(UIButton *)guideBtn
{
    if (_guideBtn == nil) {
       NSDictionary *guideBtnDic = @{@"title":@"在线申请",@"titleColor":KWhiteColor,@"font":kPingFangRegular(12),@"backgroundColor":KClearColor};
        _guideBtn = [ZSHBaseUIControl createBtnWithParamDic:guideBtnDic];
        [ZSHSpeedy zsh_chageControlCircularWith:_guideBtn AndSetCornerRadius:0 SetBorderWidth:1.0 SetBorderColor:KWhiteColor canMasksToBounds:YES];
        [_guideBtn sizeToFit];
        _guideBtn.center = CGPointMake(self.width * 0.5, self.height * 0.9);
        [self.contentView addSubview:_guideBtn];
    }
    return _guideBtn;
}

-(UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.frame = self.bounds;
        _imageView = imageview;
        [self.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

-(void)setPage:(NSInteger)page
{
    _page = page;
//    if (page == 4) {
//        self.guideBtn.hidden = NO;
//    }else{
//        self.guideBtn.hidden = YES;
//    }
}

@end
