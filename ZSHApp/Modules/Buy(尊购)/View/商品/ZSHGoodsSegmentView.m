//
//  ZSHGoodsSegmentView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsSegmentView.h"

@interface ZSHGoodsSegmentView()
@property (nonatomic, strong)NSMutableArray  *btnArr;
@property (nonatomic, strong)UIView          *tmpPointView;
@property (nonatomic, strong)NSMutableArray  *pointViewArr;

@end

@implementation ZSHGoodsSegmentView

- (void)setup{
    _btnArr = [[NSMutableArray alloc]init];
    _pointViewArr = [[NSMutableArray alloc]init];
    
    //水平线
    UIView *horizontalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
    horizontalView.backgroundColor = KZSHColor1D1D1D;
    [self addSubview:horizontalView];
    
    for (int i = 1; i<5; i++) {
    //垂直分割线
        if (i<4) {
            UIView *verticalLineView = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/4 *i, 0.5, 0.5, kRealValue(50))];
            verticalLineView.backgroundColor = KZSHColor1D1D1D;
            [self addSubview:verticalLineView];
            [verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KScreenWidth/4 * i);
                make.top.mas_equalTo(horizontalView.mas_bottom);
                make.width.mas_equalTo(kRealValue(0.5));
                make.bottom.mas_equalTo(self);
            }];
        }
       
        
        //中间button
        UIButton *typeBtn = [[UIButton alloc]init];
        typeBtn.tag = i;
        [typeBtn addTarget:self action:@selector(changeGoodsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [typeBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"goods_seg%d",i]] forState:UIControlStateNormal];
        [self addSubview:typeBtn];
        [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KScreenWidth/4 * (i-1));
            make.width.mas_equalTo(KScreenWidth/4);
            make.height.mas_equalTo(kRealValue(50));
            make.top.mas_equalTo(self);
        }];
        [_btnArr addObject:typeBtn];
        
        //右上角原点
        UIView *pointView = [[UIView alloc]init];
        pointView.tag = i+1;
        pointView.hidden = YES;
        pointView.layer.cornerRadius = kRealValue(8)/2;
        pointView.clipsToBounds = YES;
        pointView.backgroundColor = [UIColor colorWithHexString:@"1F4BA5"];
        [self addSubview:pointView];
        [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(typeBtn.mas_right).offset(-kRealValue(10));
            make.top.mas_equalTo(typeBtn.mas_top).offset(kRealValue(10));
            make.size.mas_equalTo(CGSizeMake(kRealValue(8), kRealValue(8)));
        }];
        [_pointViewArr addObject:pointView];
    }
    
    [self selectedByIndex:3];
}

- (void)changeGoodsBtnAction:(UIButton *)btn{
    [self selectedByIndex:btn.tag];
    if (self.btnClickBlock) {
        self.btnClickBlock(btn);
    }
}

- (void)selectedByIndex:(NSUInteger)index {
    [_btnArr enumerateObjectsUsingBlock:^(UIButton *btn , NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn.tag == index) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }];
    
    [_pointViewArr enumerateObjectsUsingBlock:^(UIView *pointView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pointView.tag == index+1) {
            pointView.hidden = NO;
        } else {
             pointView.hidden = YES;
        }
    }];
}


@end
