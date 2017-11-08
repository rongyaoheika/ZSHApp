//
//  ZSHGoodsMineGridCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnClickBlock)(UIButton *);

@interface ZSHGoodsMineGridCell : UICollectionViewCell

@property (nonatomic,copy)BtnClickBlock     btnClickBlock;
@property (nonatomic,strong)NSDictionary    *modelDic;

@end
