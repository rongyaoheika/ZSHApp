//
//  ZSHSearchBarView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSearchBarView.h"

@interface ZSHSearchBarView()


@end

@implementation ZSHSearchBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.zsh_x = kRealValue(30);
    self.zsh_y = kRealValue(7);
    self.zsh_height = kRealValue(28);
    
    _searchBar = [[UISearchBar alloc] initWithFrame:self.bounds];
    _searchBar.placeholder = @"搜索";
    //光标颜色
    [[[_searchBar.subviews objectAtIndex:0].subviews objectAtIndex:1] setTintColor:KZSHColor929292];
    
    for (UIView *subView in [[_searchBar.subviews lastObject] subviews]) {
        if ([[subView class] isSubclassOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subView;
            textField.font = kPingFangLight(14);
            _searchTextField = textField;
            break;
        }
    }
   
    _searchTextField.layer.cornerRadius = 5.0;
    _searchTextField.layer.masksToBounds = YES;
    _searchTextField.layer.borderColor = KClearColor.CGColor;
    _searchTextField.layer.borderWidth = 0.0;
    [_searchTextField setBackgroundColor:KZSHColor1A1A1A];
    [_searchTextField setValue:KZSHColor8E8E93 forKeyPath:@"_placeholderLabel.textColor"];
    [_searchTextField setValue:kPingFangLight(14) forKeyPath:@"_placeholderLabel.font"];
    [self addSubview:_searchBar];
}

//设置输入框光标颜色
/*- (void)setCursorColor:(UIColor *)cursorColor
{
    if (cursorColor) {
        _cursorColor = cursorColor;
        //获取输入框
        UITextField *searchField = self.searchBarTextField;
        if (searchField) {
            //光标颜色
            [searchField setTintColor:cursorColor];
        }
    }
}

//获取输入框
- (UITextField *)searchBarTextField
{
    //获取输入框
    _searchBarTextField = [self valueForKey:@"searchField"];
    return _searchBarTextField;
}

//设置清除按钮图标
- (void)setClearButtonImage:(UIImage *)clearButtonImage
{
    if (clearButtonImage) {
        _clearButtonImage = clearButtonImage;
        //获取输入框
        UITextField *searchField = self.searchBarTextField;
        if (searchField) {
            //设置清除按钮图片
            UIButton *button = [searchField valueForKey:@"_clearButton"];
            [button setImage:clearButtonImage forState:UIControlStateNormal];
            searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
    }
}

- (void)setHideSearchBarBackgroundImage:(BOOL)hideSearchBarBackgroundImage {
    if (hideSearchBarBackgroundImage) {
        _hideSearchBarBackgroundImage = hideSearchBarBackgroundImage;
        self.backgroundImage = [[UIImage alloc] init];
    }
}

//获取取消按钮
- (UIButton *)cancleButton
{
    self.showsCancelButton = YES;
    for (UIView *view in [[self.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            _cancleButton = (UIButton *)view;
        }
    }
    return _cancleButton;
}*/

- (CGSize)intrinsicContentSize{
//    return CGSizeMake(kRealValue(270), kRealValue(35));
    return UILayoutFittingExpandedSize;
    
}


@end
