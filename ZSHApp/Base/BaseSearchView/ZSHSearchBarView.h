//
//  ZSHSearchBarView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"

@interface ZSHSearchBarView : UISearchBar

@property (nonatomic,strong) UIColor        *cursorColor;                   //光标颜色
@property (nonatomic,strong) UITextField    *searchBarTextField;            //搜索框TextField
@property (nonatomic,strong) UIImage        *clearButtonImage;              //输入框清除按钮图片
@property (nonatomic,assign) BOOL           hideSearchBarBackgroundImage;   //隐藏SearchBar背景灰色部分 默认显示
@property (nonatomic,strong) UIButton       *cancleButton;                  //取消按钮 showsCancelButton = YES 才能获取到
@property(nonatomic, assign) CGSize         intrinsicContentSize;

@end
