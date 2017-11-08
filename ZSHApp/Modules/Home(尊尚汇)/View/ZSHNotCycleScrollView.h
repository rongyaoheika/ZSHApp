//
//  ZSHNotCycleScrollView.h
//  ZSHApp
//
//  Created by Apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZSHItemViewSelectedBlock)(NSInteger index);

@interface ZSHNotCycleScrollView : UIView

@property (nonatomic, assign) ZSHFromVCToHotelDetailVC                  fromClassType;                     //item为title标题时文字未选中颜色，默认black
@property (nonatomic, strong) UIColor *normalColor;                     //item为title标题时文字未选中颜色，默认black
@property (nonatomic, strong) UIColor *selectedColor;                   //item为title标题时文字选中和下方滚动条颜色，默认red
@property (nonatomic, assign) NSInteger selectedIndex;                  //第几个item处于选中状态，默认为0
@property (nonatomic, assign) CGFloat itemWidth;                        //每个item宽度,默认85.f

@property (nonatomic, assign) CGFloat indicatorHeight;                  //item 为title时下方滚动指示条高度，默认2.f
@property (nonatomic, copy) ZSHItemViewSelectedBlock selectedBlock;    //选中item回调block

/**
 标题字体font，默认14.f
 */
@property (nonatomic, strong) UIFont *normalTitleFont;

/**
 选中标题字体font，默认14.f
 */
@property (nonatomic, strong) UIFont *selectedTitleFont;


 //刷新界面
- (void)reloadViewWithDataArr:(NSMutableArray *)dataArr;

//- (void)reloadViewWithbtnDataArr:(NSMutableArray *)btnDataArr;

@end
