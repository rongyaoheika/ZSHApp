//
//  ZSHBaseUIControl.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseUIControl.h"

@implementation ZSHBaseUIControl

// NSDictionary *titleLabelDic = @{@"text":@"回忆杀，不一样的三国《憨逗军团》",@"font":kPingFangMedium(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
+ (UILabel *)createLabelWithParamDic:(NSDictionary *)paramDic{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.tag = [paramDic[@"tag"]integerValue];
    label.text = paramDic[@"text"];
    label.font = paramDic[@"font"]?paramDic[@"font"]:kPingFangRegular(15);
    label.textColor = paramDic[@"textColor"]? paramDic[@"textColor"]:KZSHColor929292;
    label.textAlignment = [paramDic[@"textAlignment"]integerValue]? [paramDic[@"textAlignment"]integerValue]:NSTextAlignmentLeft;
   
    return label;
}

//NSDictionary *btnDic = @{@"title":titleArr[i],@"titleColor":KZSHColor929292,@"font":kPingFangRegular(14),@"backgroundColor":KClearColor,@"withImage":@(YES),@"normalImage":imageArr[i],@"selectedImage":imageArr[i]};

+ (UIButton *)createBtnWithParamDic:(NSDictionary *)paramDic{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
    btn.tag = [paramDic[@"tag"]integerValue];
    [btn setTitle:paramDic[@"title"] forState:UIControlStateNormal];
    
    UIColor *titleColor = paramDic[@"titleColor"]?paramDic[@"titleColor"]:KZSHColor929292;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    UIColor *bgColor = paramDic[@"backgroundColor"]?paramDic[@"backgroundColor"]:KClearColor;
    [btn setBackgroundColor:bgColor];
    
    UIFont *titleFont = paramDic[@"font"]? paramDic[@"font"]:kPingFangRegular(14);
    btn.titleLabel.font = titleFont;
    if ([paramDic[@"withImage"]integerValue]) {
        [btn setImage:[UIImage imageNamed:paramDic[@"normalImage"]] forState:UIControlStateNormal];
        
        UIImage *image = paramDic[@"selectedImage"]?paramDic[@"selectedImage"]:paramDic[@"selectedImage"];
        [btn setImage:image forState:UIControlStateSelected];
    }
    
    return btn;
}

+ (UITableView *)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KScreenHeight - kRealValue(200), KScreenWidth, kRealValue(200)) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = KClearColor;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = KClearColor;
    tableView.scrollsToTop = YES;
    return tableView;
}

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setBounds:lineView.bounds];
    
    if (isHorizonal) {
        
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
        
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {
        
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+ (UIButton *)createLabelBtnWithTopDic:(NSDictionary *)topDic bottomDic:(NSDictionary *)bottomDic {
    UIButton *labelBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    labelBtn.backgroundColor = KClearColor;
    
    UILabel *topLabel = [ZSHBaseUIControl createLabelWithParamDic:topDic];
    topLabel.tag = 1;
    [labelBtn addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(labelBtn);
        make.width.mas_equalTo(labelBtn);
        make.height.mas_equalTo( kRealValue([topDic[@"height"] integerValue]) );
        make.top.mas_equalTo(labelBtn);
    }];
    
    UILabel *bottomLabel = [ZSHBaseUIControl createLabelWithParamDic:bottomDic];
    bottomLabel.tag = 2;
    [labelBtn addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topLabel);
        make.width.mas_equalTo(labelBtn);
        make.height.mas_equalTo( kRealValue([bottomDic[@"height"] integerValue]) );
        make.bottom.mas_equalTo(labelBtn);
    }];
    
    return labelBtn;
}

+ (UIView *)createTabHeadLabelViewWithParamDic:(NSDictionary *)paramDic{
   UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    UILabel *headLabel = [ZSHBaseUIControl createLabelWithParamDic:paramDic];
    [headView addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView);
        make.height.mas_equalTo(headView);
        make.width.mas_equalTo(headView);
        make.centerY.mas_equalTo(headView);
    }];
    return headView;
}

@end
