//
//  AudioPlayerController+methods.m
//  AudioPlayer
//
//  Created by ClaudeLi on 16/4/1.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "AudioPlayerController+methods.h"
#import "QQLrcDataTool.h"
@interface AudioPlayerController (methods) <UIScrollViewDelegate>
@end

@implementation AudioPlayerController (methods)

- (void)creatViews{
    self.rotatingView = [[RotatingView alloc] init];
    self.rotatingView.imageView.image = [UIImage imageNamed:@"音乐_播放器_默认唱片头像"];
    [self.view addSubview:self.rotatingView];
    
    self.lrcLabel = [[QQLrcLabel alloc]initWithFrame:CGRectMake(0, KScreenHeight - kRealValue(160), KScreenWidth, kRealValue(40))];
    self.lrcLabel.textColor = KWhiteColor;
    self.lrcLabel.numberOfLines = 1;
    self.lrcLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.lrcLabel];
    
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.userInteractionEnabled = NO;
    [self.view addSubview:self.HUD];
}

- (void)progressHUDWith:(NSString *)string{
    self.HUD.labelText = string;
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:2.0f];
}

- (void)setRotatingViewFrame{
    CGFloat height_i4 = KScreenHeight - topHeight - downHeight;
    if (KScreenHeight < 500) {
        self.rotatingView.frame = CGRectMake(0, 0, height_i4*0.8, height_i4*0.8);
    }else{
        self.rotatingView.frame = CGRectMake(0, 0, KScreenWidth *0.8, KScreenWidth*0.8);
    }
    self.rotatingView.center = CGPointMake(KScreenWidth/2, height_i4/2 + topHeight);
    [self.rotatingView setRotatingViewLayoutWithFrame:self.rotatingView.frame];
}



- (void)setImageWith:(MusicModel *)model{
    /**
     *  添加旋转动画
     */
    [self.rotatingView addAnimation];
    
    self.underImageView.image = [UIImage imageNamed:@"音乐_播放器_默认模糊背景"];
    [self.rotatingView.imageView sd_setImageWithURL:[NSURL URLWithString:model.pic_radio] placeholderImage:[UIImage imageNamed:@"音乐_播放器_默认唱片头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.underImageView.image = [image applyDarkEffect];
        }
    }];
}

/** 添加歌词视图*/
- (void)addLrcView{
    RLog(@"添加了歌词视图");
    self.lrcBackView = [[UIScrollView alloc]init];
    [self.view insertSubview:self.lrcBackView atIndex:0];
    
    // 歌词视图
    UIView *lrcView = [[UIView alloc] init];
    self.lrcView = lrcView;
    [self.lrcView addSubview:self.lrcTVC.tableView];
    self.lrcTVC.tableView.backgroundColor = [UIColor clearColor];
    [self.lrcBackView addSubview:lrcView];
    self.lrcBackView.delegate = self;
    
    // 歌词的背景视图
    self.lrcBackView.showsHorizontalScrollIndicator = NO;
    self.lrcBackView.pagingEnabled = YES;
   
}

/** 设置歌词视图的 frame*/
- (void)setUpLrcViewFrame{
    self.lrcBackView.frame = CGRectMake(0, kRealValue(100), kScreenWidth, KScreenHeight-kRealValue(100) - kRealValue(120));
    
    // 歌词视图
    self.lrcView.frame = self.lrcBackView.bounds;
    self.lrcView.zsh_x = self.lrcBackView.width;
    self.lrcTVC.tableView.frame = self.lrcView.bounds;
    
    
    // 歌词背景视图
    self.lrcBackView.contentSize = CGSizeMake(self.lrcBackView.width * 2, 0);
}



#pragma mark --------------------------
#pragma mark 动画处理

/** 处理透明度*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat alpha = 1 - 1.0 * scrollView.contentOffset.x / self.lrcBackView.width;
    self.rotatingView.alpha = alpha;
    self.lrcLabel.alpha = alpha;
    [self.view bringSubviewToFront:self.lrcBackView];
}


@end
