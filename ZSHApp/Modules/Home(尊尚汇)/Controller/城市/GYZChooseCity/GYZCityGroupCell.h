//
//  GYZCityGroupCell.h
//  GYZChooseCityDemo
//
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYZCity.h"
#import "GYZChooseCityDelegate.h"


#define     MIN_SPACE           10           // 城市button最小间隙
#define     MAX_SPACE           15

#define     WIDTH_LEFT          15          // button左边距
#define     WIDTH_RIGHT         28          // button右边距


@interface GYZCityGroupCell : ZSHBaseCell
@property (nonatomic,assign) id <GYZCityGroupCellDelegate> delegate;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  暂无数据
 */
@property (nonatomic, strong) UILabel *noDataLabel;
/**
 *  btn数组
 */
@property (nonatomic, strong) NSMutableArray *arrayCityButtons;
/**
 *  城市数据信息
 */
@property (nonatomic, strong) NSArray *cityArray;
/**
 *  返回cell高度
 *
 *  @param cityArray cell的数量
 *
 *  @return 返回cell高度
 */
+ (CGFloat) getCellHeightOfCityArray:(NSArray *)cityArray;

@end
