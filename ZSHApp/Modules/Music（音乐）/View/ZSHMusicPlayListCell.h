//
//  ZSHMusicPlayListCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"
#import "ZSHRadioModel.h"
#import "ZSHSingerModel.h"
#import "ZSHRankModel.h"

@interface ZSHMusicPlayListCell : ZSHBaseCell

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, copy) NSString      *imageUrl;

- (void)updateCellWithRadioModel:(ZSHRadioModel *)radioModel;
- (void)updateCellWithSingerModel:(ZSHSingerModel *)singerModel;
- (void)updateCellWithLibraryRankModel:(ZSHRankModel *)rankModel;

@end
