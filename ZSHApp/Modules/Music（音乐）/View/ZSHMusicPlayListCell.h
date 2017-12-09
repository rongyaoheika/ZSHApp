//
//  ZSHMusicPlayListCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"
#import "ZSHRadioModel.h"
#import "ZSHRadioDetailModel.h"
@interface ZSHMusicPlayListCell : ZSHBaseCell

@property (nonatomic, copy) NSString    *imageUrl;

- (void)updateCellWithRadioModel:(ZSHRadioSubModel *)radioModel;
- (void)updateCellWithRadioDetailModel:(ZSHRadioDetailSubModel *)radioDetailSubModel;
@end
