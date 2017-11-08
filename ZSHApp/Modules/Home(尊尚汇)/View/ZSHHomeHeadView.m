//
//  ZSHHomeHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHomeHeadView.h"

@interface ZSHHomeHeadView()
@property (nonatomic, strong)NSMutableArray  *btnArr;
@end


@implementation ZSHHomeHeadView

- (void)setup {
    _btnArr = [[NSMutableArray alloc]init];
    
    NSArray *titleArr = @[@"美食",@"酒店",@"火车票",@"机票",@"马术",@"游艇",@"豪车",@"更多"];
    NSArray *imageArr = @[@"home_food",@"home_hotel",@"home_train",@"home_plane",@"home_horse",@"home_ship",@"home_car",@"home_more"];
    
    for (int i = 0; i<titleArr.count; i++) {
//        UIButton *btn = [self createXYBtnWithImageName:imageArr[i] title:titleArr[i]];
//        btn.tag = i+10;
//        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:btn];
//        [_btnArr addObject:btn];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = kPingFangLight(14);
        [btn setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
        btn.tag = i+10;
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [_btnArr addObject:btn];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    int i = 0;
    for (UIButton *btn in _btnArr) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset((i/4) * CGRectGetHeight(self.frame)*0.5 );
            make.width.mas_equalTo(floor(KScreenWidth/4));
            make.height.mas_equalTo(self).multipliedBy(0.5);
            make.left.mas_equalTo(self).offset(((i%4)*(floor(KScreenWidth/4))));
        }];
        [btn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleTop imageTitleSpace:kRealValue(6)];
        
        i++;
    }
    
}

- (UIButton *)createXYBtnWithImageName:(NSString *)imageName title:(NSString *)title{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [btn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn).offset(kRealValue(30));
        make.centerX.mas_equalTo(btn);
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
    }];
    
    
   NSDictionary *titleLabelDic = @{@"text":title,@"font": kPingFangLight(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [btn addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(btn).offset(-kRealValue(5));
        make.centerX.mas_equalTo(btn);
        make.width.mas_equalTo(btn);
        make.height.mas_equalTo(kRealValue(14));
    }];
    
    return btn;
}

- (void)headBtnClick:(UIButton *)headBtn{
    if (self.btnClickBlock) {
        self.btnClickBlock(headBtn.tag-10);
    }
}
@end
