//
//  ZSHEnterTainmentCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEnterTainmentCell.h"
#import "ZSHEntertainmentHeadView.h"
#import "ZSHEntertainmentModel.h"

@interface ZSHEnterTainmentCell()

@property (nonatomic, strong) ZSHEntertainmentHeadView          *headView;
@property (nonatomic, strong) UILabel                           *titleLabel;
@property (nonatomic, strong) UIView                            *detailView;
@property (nonatomic, strong) NSMutableArray                    *labelArr;
@property (nonatomic, strong) NSArray                           *titleArr;

@end

@implementation ZSHEnterTainmentCell

- (void)setup{
    //头部
    [self.contentView addSubview:self.headView];
    
    //博客标题
    NSDictionary *titleLabelDic = @{@"text":@"麦乐迪KTV嗨起来"};
    self.titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:self.titleLabel];
    
    self.detailView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.detailView];
    
    _titleArr = @[@"开始时间：2017年10月1日",@"结束时间：2017年10月8日",@"人数：一对一",@"方式：AA互动趴"];
    _labelArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<_titleArr.count; i++) {
        NSDictionary *titleLabelDic = @{@"text":_titleArr[i],@"font":kPingFangRegular(11)};
        UILabel *bottomLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
        [self.contentView addSubview:bottomLabel];
        [_labelArr addObject:bottomLabel];
    }
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.height.mas_equalTo(kRealValue(14));
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.top.mas_equalTo(self.headView.mas_bottom).offset(kRealValue(14));
    }];
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealValue(14));
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(82.5));
    }];
    
    int j = 0;
    for (UIImageView *subImageView in self.detailView.subviews) {
        [subImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.detailView);
            make.left.mas_equalTo(self.titleLabel).offset( (kRealValue(82.5)+kRealValue(5)) *j);
            make.width.and.height.mas_equalTo(kRealValue(82.5));
        }];
        j++;
    }
    
    int i = 0;
    for (UILabel *label in _labelArr) {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!(i%2)) {//左边
                make.left.mas_equalTo(self).offset(KLeftMargin);
            } else {
                make.left.mas_equalTo(self).offset(kRealValue(230));
            }
            make.width.mas_equalTo((KScreenWidth- 2*KLeftMargin)/2);
            make.top.mas_equalTo(_detailView.mas_bottom).offset(kRealValue(20) + (kRealValue(11)+kRealValue(10))*(i/2));
            make.height.mas_equalTo(kRealValue(11));
        }];
        i++;
    }

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)updateCellWithModel:(ZSHEntertainmentModel *)model{
    if (_detailView.subviews.count) {
        [_detailView removeAllSubviews];
    }
    for (int i = 0; i<model.CONVERGEIMGS.count; i++) {
        UIImageView *detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kRealValue(82.5), kRealValue(82.5))];
        [detailImageView sd_setImageWithURL:[NSURL URLWithString:model.CONVERGEIMGS[i]]];
        [_detailView addSubview:detailImageView];
    }
    
    if (model.CONVERGEIMGS.count) {
        [_detailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kRealValue(82.5));
        }];
    } else {
        if (_detailView.subviews.count) {
            [_detailView removeAllSubviews];
        }
        [_detailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kRealValue(1));
        }];
    }
    
    NSString *beginTime = [NSString stringWithFormat:@"开始时间：%@",model.STARTTIME];
    NSString *endTime = [NSString stringWithFormat:@"结束时间：%@",model.ENDTIME];
    NSString *personCount = [NSString stringWithFormat:@"人数：%@",model.CONVERGEPER];
    NSString *mode = [NSString stringWithFormat:@"方式：%@",model.CONVERGETYPE];
    
    _titleArr = @[beginTime,endTime,personCount,mode];
    int i = 0;
    for (UILabel *label in _labelArr) {
        label.text = _titleArr[i];
        i++;
    }
    self.headView.model = model;
    
    self.titleLabel.text = model.CONVERGETITLE;
    
    [self layoutIfNeeded];
    [self updateConstraintsIfNeeded];
}


- (void)setFromClassType:(ZSHFromVCToEnterTainmentCell)fromClassType{
    _fromClassType = fromClassType;
//    if (fromClassType == ZSHFromActivityVCToEnterTainmentCell) {
//        self.headView.hidden = YES;
//        self.headView.frame = CGRectZero;
//    }
}

#pragma getter
- (ZSHEntertainmentHeadView *)headView{
    if (!_headView) {
        _headView = [[ZSHEntertainmentHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(60)) paramDic:nil];
    }
     return _headView;
}



@end
