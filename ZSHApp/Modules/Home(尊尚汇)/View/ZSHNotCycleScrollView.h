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

@property (nonatomic, strong) UIColor       *normalColor;               //未选中颜色
@property (nonatomic, strong) UIColor       *selectedColor;             //文字选中和下方滚动条颜色
@property (nonatomic, assign) NSInteger     selectedIndex;              //第几个item处于选中状态
@property (nonatomic, assign) CGFloat       itemWidth;                  //每个item宽度
@property (nonatomic, assign) CGFloat       indicatorHeight;            //item为title时下方滚动指示条高度

@property (nonatomic, strong) UIFont *normalTitleFont;                  //未选中字体
@property (nonatomic, strong) UIFont *selectedTitleFont;                //选中标题字体font

@property (nonatomic, assign) ZSHFromVCToHotelDetailVC   fromClassType;
@property (nonatomic, copy)   ZSHItemViewSelectedBlock   selectedBlock;    //选中item回调block

- (void)reloadViewWithDataArr:(NSMutableArray *)dataArr;                 //刷新界面

@end
