//
//  ZSHDetailGoodReferralCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCollectionViewCell.h"

@interface ZSHDetailGoodReferralCell : ZSHBaseCollectionViewCell

/* 商品标题 */
@property (strong , nonatomic)UILabel *goodTitleLabel;
/* 商品价格 */
@property (strong , nonatomic)UILabel *goodPriceLabel;
/* 商品小标题 */
@property (strong , nonatomic)UILabel *goodSubtitleLabel;

/* 优惠按钮 */
@property (strong , nonatomic)UIButton *preferentialButton;


@end
