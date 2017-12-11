//
//  ZSHSimpleCellView.h
//  RLJKApp
//
//  Created by zhaoweiwei on 2017/9/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"

@interface ZSHSimpleCellView : ZSHBaseView

// 第一组
- (void)updateViewWithModel:(ZSHBaseModel *)model index:(NSInteger)index;
// 第二组
- (void)updateView2WithModel:(ZSHBaseModel *)model index:(NSInteger)index;

- (void)updateHeadImage:(UIImage *)image;
- (void)updateRightText:(NSString *)text;
@end
