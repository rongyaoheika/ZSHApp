//
//  ZSHBaseCollectionViewCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSHBaseModel;
@interface ZSHBaseCollectionViewCell : UICollectionViewCell

- (void)setup;

//更新cell内容
- (void)updateCellWithParamDic:(NSDictionary *)dic;
- (void)updateCellWithModel:(ZSHBaseModel *)model;
@end
