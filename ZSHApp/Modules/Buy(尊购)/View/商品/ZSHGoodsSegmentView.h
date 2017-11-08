//
//  ZSHGoodsSegmentView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"

typedef void(^BtnClickBlock)(UIButton *btn);

@interface ZSHGoodsSegmentView : ZSHBaseView

@property (nonatomic, copy)   BtnClickBlock   btnClickBlock;

- (void)selectedByIndex:(NSUInteger)index;
@end
