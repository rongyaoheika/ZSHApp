//
//  ZSHTopLineView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"
typedef void (^BtnBlock)(NSInteger);
@interface ZSHTopLineView : ZSHBaseView

@property (nonatomic, copy)   BtnBlock                  btnActionBlock;

@end
