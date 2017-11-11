//
//  ZSHGuideCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSHGuideCell : UICollectionViewCell

// ** 图片  */
@property (nonatomic,strong) UIImage *image;

// ** 页数,到尾页显示开始按钮 */
@property (nonatomic,assign) NSInteger page;


@end
