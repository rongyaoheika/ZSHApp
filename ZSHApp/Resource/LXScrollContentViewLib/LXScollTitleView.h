//
//  LXScollTitleView.h
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 TitleSelectedBlock

 @param index 选中第几个标题
 */
typedef void(^BMPageTitleViewSelectedBlock)(NSInteger index);

@interface LXScollTitleView : UIView


@property (nonatomic, strong) UIScrollView        *scrollView;

@property (nonatomic, strong) NSMutableArray      *titleButtons;
/**
 文字未选中颜色，默认black
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 文字选中和下方滚动条颜色，默认red
 */
@property (nonatomic, strong) UIColor *selectedColor;


/**
 button 默认边框颜色
 */
@property (nonatomic, strong) UIColor *normalBorderColor;

/**
 button 选中时边框颜色
 */
@property (nonatomic, strong) UIColor *selectedBorderColor;


//背景图片

/**
 button 默认状态背景图片
 */
@property (nonatomic, strong) UIImage *normalBgImage;

/**
 button 选中时背景图片
 */
@property (nonatomic, strong) UIImage *selectedBgImage;

/**
 button 默认状态背景图片数组
 */
@property (nonatomic, strong) NSArray *normalBgImageArr;

/**
 button 选中时背景图片数组
 */
@property (nonatomic, strong) NSArray *selectedBgImageArr;


// button.imageview图片

/**
 button.imageview 默认状态图片
 */
@property (nonatomic, strong) UIImage *normalImage;

/**
 button.imageview 选中状态图片
 */
@property (nonatomic, strong) UIImage *selectedImage;

/**
 button.imageview 默认状态图片数组
 */
@property (nonatomic, strong) NSArray *normalImageArr;

/**
 button.imageview 选中状态图片数组
 */
@property (nonatomic, strong) NSArray *selectedImageArr;


@property (nonatomic, assign) XYButtonEdgeInsetsStyle  imageStyle;
@property (nonatomic, assign) CGFloat                  imageTitleSpace;

/**
 第几个标题处于选中状态，默认为0
 */
@property (nonatomic, assign) NSInteger selectedIndex;


/**
 每个标题宽度,默认85.f
 */
@property (nonatomic, assign) CGFloat titleWidth;


/**
 标题字体font，默认14.f
 */
@property (nonatomic, strong) UIFont *normalTitleFont;

/**
 选中标题字体font，默认14.f
 */
@property (nonatomic, strong) UIFont *selectedTitleFont;

/**
 下方滚动指示条高度，默认2.f
 */
@property (nonatomic, assign) CGFloat indicatorHeight;

/**
 下方滚动指示条高度，默认和标题宽度一致
 */
@property (nonatomic, assign) CGFloat indicatorWidth;

/**
 选中标题回调block
 */
@property (nonatomic, copy) BMPageTitleViewSelectedBlock selectedBlock;


/**
 刷新界面

 @param titles 标题数组
 */
- (void)reloadViewWithTitles:(NSArray *)titles;

@end
