//
//  ZSHPayView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"
typedef void (^RightBtnBlock)(UIButton *btn);

@interface ZSHPayView : ZSHBaseView

@property (nonatomic, assign) NSInteger           selectedCellRow;
@property (nonatomic, strong) UIButton            *rightBtn;
@property (nonatomic, copy)   RightBtnBlock       rightBtnBlcok;

- (ZSHBaseTableViewSectionModel *)storePaySection;
@end
