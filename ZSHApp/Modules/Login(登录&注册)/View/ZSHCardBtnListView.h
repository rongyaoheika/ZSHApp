//
//  ZSHCardBtnListView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"

typedef void (^ClickSameBtnBlock)(BOOL openBtnList);

@interface ZSHCardBtnListView : ZSHBaseView

@property (nonatomic, copy) ClickSameBtnBlock   clickSameBtn;

@end

