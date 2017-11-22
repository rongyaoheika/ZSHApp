//
//  ZSHBaseCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSHBaseModel.h"

typedef void(^BtnClickBlock)(id);
@interface ZSHBaseCell : UITableViewCell

@property (nonatomic, strong) ZSHBaseModel *model;
@property (nonatomic, strong) NSDictionary *paramDic;
@property (nonatomic, copy)   NSString     *arrowImageName;


@property(nonatomic, assign, readonly) UITableViewCellStyle style;
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets textLabelEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets detailTextLabelEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets accessoryEdgeInsets;
@property (nonatomic, copy) BtnClickBlock  btnClickBlock;

//加载cell  控件
- (void)setup;

//更新cell内容
- (void)updateCellWithParamDic:(NSDictionary *)dic;
- (void)updateCellWithDataArr:(NSArray *)dataArr;
- (void)updateCellWithModel:(ZSHBaseModel *)model;


//获取cell高度
+ (CGFloat)getCellHeightWithModel:(ZSHBaseModel *)model;

//获取cell高度
-(CGFloat)rowHeightWithCellModel:(ZSHBaseModel *)model;
@end
