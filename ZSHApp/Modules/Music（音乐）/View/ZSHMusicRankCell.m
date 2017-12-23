//
//  ZSHMusicRankCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicRankCell.h"
#import "ZSHRankModel.h"
@interface ZSHMusicRankCell()

@property (nonatomic, strong)UIImageView      *rankIV;
@property (nonatomic, strong)NSMutableArray   *labelArr;

@end

@implementation ZSHMusicRankCell

- (void)setup{
    _rankIV = [[UIImageView alloc]init];
    _rankIV.image = [UIImage imageNamed:@"music_image_1"];
    [self.contentView addSubview:_rankIV];
    [_rankIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(110));
    }];
    
    _labelArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<3; i++) {
        NSDictionary *paramDic = @{@"text":[NSString stringWithFormat:@"%d.连名带姓 - 张惠妹",i+1]};
        UILabel *rankSongLabel = [ZSHBaseUIControl createLabelWithParamDic:paramDic];
        [self.contentView addSubview:rankSongLabel];
        [rankSongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(KLeftMargin + ((kRealValue(15) + kRealValue(17.5)))*i);
            make.height.mas_equalTo(kRealValue(15));
            make.left.mas_equalTo(_rankIV.mas_right).offset(KLeftMargin);
            make.right.mas_equalTo(self).offset(-KLeftMargin);
        }];
        [_labelArr addObject:rankSongLabel];
    }
}


- (void)updateCellWithParamDic:(NSDictionary *)dic{
    NSArray *rankModelArr = dic[@"rankModelArr"];
    for (int i = 0; i<rankModelArr.count; i++) {
        UILabel *label = _labelArr[i];
        ZSHRankModel *rankModel = rankModelArr[i];
        label.text = [NSString stringWithFormat:@"%d. %@ - %@",i+1, rankModel.title, rankModel.author];
    }
}

- (void)setImageUrl:(NSString *)imageUrl{
    [_rankIV sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

@end
