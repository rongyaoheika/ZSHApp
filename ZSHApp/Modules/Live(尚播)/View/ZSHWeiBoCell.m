//
//  ZSHWeiBoCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHWeiBoCell.h"
#import "ZSHWeiBoCellModel.h"
#import "ZSHWeiBoBottomView.h"
#import "KNPhotoBrowerImageView.h"
#import "KNPhotoBrower.h"

@interface ZSHWeiBoCell()<KNPhotoBrowerDelegate>{
    BOOL     _ApplicationStatusIsHidden;
}

// 九宫格
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSMutableArray *actionSheetArray; // 右上角弹出框的 选项 -->代理回调
@property (nonatomic, strong) KNPhotoBrower *photoBrower;
//控件声明
@property (nonatomic, strong) UIImageView         *avatarImageView;
@property (nonatomic, strong) UILabel             *nameLabel;
@property (nonatomic, strong) UILabel             *dateLabel;
@property (nonatomic, strong) UILabel             *detailLabel;
@property (nonatomic, strong) UIImageView         *detailImageView;
@property (nonatomic, strong) ZSHWeiBoBottomView  *bottomView;

@property (nonatomic, strong) MASConstraint       *topConstraint;

@end

@implementation ZSHWeiBoCell

- (void)setup{
    //子控件的创建
    self.avatarImageView = [[UIImageView alloc]init];
    [self.avatarImageView setClipsToBounds:YES];
    self.avatarImageView.layer.cornerRadius = kRealValue(40)/2;
    [self.contentView addSubview:self.avatarImageView];
    
    NSDictionary *nameLabelDic = @{@"text":@"姜小白",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft )};
    self.nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [self.contentView addSubview:self.nameLabel];
    
    NSDictionary *dateLabelDic = @{@"text":@"昨天16:36",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    self.dateLabel = [ZSHBaseUIControl createLabelWithParamDic:dateLabelDic];
    [self.contentView addSubview:self.dateLabel];
    
    NSDictionary *detailLabelDic = @{@"text":@"#跑车世界# 一枚宽体战神GTR ",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    self.detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailLabelDic];
    self.detailLabel.numberOfLines = 0;
    [self.detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:self.detailLabel];
    
    self.detailImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.detailImageView ];
    
    _bottomView = [[ZSHWeiBoBottomView alloc]initWithFrame:CGRectZero paramDic:nil];
    [self.contentView addSubview:self.bottomView];
    
    
    // 头像
    self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(kRealValue(15));
        make.top.mas_equalTo(self.contentView).offset(kRealValue(10));
        make.width.and.height.mas_equalTo(kRealValue(40));
    }];
    
    // 昵称
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(kRealValue(15));
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(kRealValue(10));
        make.height.mas_equalTo(kRealValue(14));
        make.right.mas_equalTo(self.contentView).offset(-kRealValue(10));
    }];
    
    // 时间
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kRealValue(6));
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(kRealValue(11));
        make.right.mas_equalTo(self.contentView).offset(-kRealValue(10));
    }];
    
    // 内容
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(kRealValue(17.5));
        make.left.mas_equalTo(self.avatarImageView);
        make.height.mas_equalTo(kRealValue(13l));
        make.right.mas_equalTo(self.contentView).offset(-kRealValue(15));
    }];

    
    // 图片
    self.detailImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(kRealValue(-KLeftMargin));
        make.width.mas_equalTo(kRealValue(110));
        make.height.mas_equalTo(kRealValue(100));
    }];
    
    
    // 点赞，评论，打赏
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kRealValue(22));
    }];
    
    if (kFromClassTypeValue == ZSHGoodsCommentSubVCToWeiBoCell) {
        self.bottomView.hidden = YES;
    }
    
    

}

- (void)updateCellWithModel:(ZSHWeiBoCellModel *)model{
    //子控件数据的更新
    if (!model.PORTRAIT) {
        self.avatarImageView.image = [UIImage imageNamed:@"list_user_1"];
    } else {
         [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.PORTRAIT]];
    }
    self.nameLabel.text = model.NICKNAME?model.NICKNAME:@"姜小白";
    self.dateLabel.text = model.PUBLISHTIME;
    
    if (![model.CONTENT isEqualToString:@""] && model.CONTENT != nil) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        NSString *detailStr = model.CONTENT;
        NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString: model.CONTENT];
        [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailStr length])];
        [self.detailLabel setAttributedText:setString];
        [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_lessThanOrEqualTo(model.hight-67.5);
        }];
    } else {
        self.detailLabel.text = @"";
    }
    
    for (KNPhotoItems *item in _itemsArray) {
        UIImageView *imageView = (UIImageView *)item.sourceView;
        [imageView removeFromSuperview];
    }
    [_itemsArray removeAllObjects];
    
    if ([model.SHOWIMAGES count]) {
        NSArray *urlArr = model.SHOWIMAGES;
        for (int i = 0; i<urlArr.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlArr[i]]];
            imageView.tag = i;
            CGFloat width = (self.contentView.frame.size.width - 40) / 3;
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = 10 + col * (10 + width);
            CGFloat y = model.hight + 10 + row * (10 + width);
            imageView.frame = CGRectMake(x, y, width, width);
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            items.sourceView = imageView;
            [self.itemsArray addObject:items];
            [self.contentView addSubview:imageView];
        }
    }

    [_bottomView updateCellWithModel:model];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    self.paramDic  = dic;
}

+ (CGFloat)getCellHeightWithModel:(ZSHWeiBoCellModel *)model{
//    ZSHWeiBoCell *cell = [[ZSHWeiBoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZSHWeiBoCell class])];
//    [cell updateCellWithModel:model];
    
    CGFloat detailLabelHeight = 0;
    if ([model.CONTENT isEqualToString:@""]) {
        detailLabelHeight = 12;
    } else {
        CGSize detailLabelSize = [model.CONTENT boundingRectWithSize:CGSizeMake(kScreenWidth-kRealValue(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:KZSHColor929292} context:nil].size;
        detailLabelHeight = detailLabelSize.height;
       
    }
    
    model.hight =  67.5 + detailLabelHeight;

    if ([model.SHOWIMAGES count]) {
        NSArray *urlArr = model.SHOWIMAGES; 
        return 67.5 + detailLabelHeight + 10.0+100*(urlArr.count/4+1)+15+22;
    } else {
        return 67.5 + detailLabelHeight + 10.0+15+22;
    }
}

- (NSMutableArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (NSMutableArray *)actionSheetArray{
    if (!_actionSheetArray) {
        _actionSheetArray = [NSMutableArray array];
    }
    return _actionSheetArray;
}

/****************************** == KNPhotoBrower 的 展现 == ********************************/
- (void)click:(UITapGestureRecognizer *)tap{
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    photoBrower.itemsArr = [_itemsArray copy];
    photoBrower.currentIndex = tap.view.tag;
    
    // 如果设置了 photoBrower中的 actionSheetArr 属性. 那么 isNeedRightTopBtn 就应该是默认 YES, 如果设置成NO, 这个actionSheetArr 属性就没有意义了
    //    photoBrower.actionSheetArr = [self.actionSheetArray mutableCopy];
    
    
    [photoBrower setIsNeedRightTopBtn:NO]; // 是否需要 右上角 操作功能按钮
    [photoBrower setIsNeedPictureLongPress:NO]; // 是否 需要 长按图片 弹出框功能 .默认:需要
    [photoBrower setIsNeedPageControl:YES];
    
    [photoBrower present];
    _photoBrower = photoBrower;
    
    // 设置代理方法 --->可不写
    [photoBrower setDelegate:self];
    
    // 这里是 设置 状态栏的 隐藏 ---> 可不写
    _ApplicationStatusIsHidden = YES;
}

// 下面方法 是让 '状态栏' 在 PhotoBrower 显示的时候 消失, 消失的时候 显示 ---> 根据项目需求而定
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden{
    if(_ApplicationStatusIsHidden){
        return YES;
    }
    return NO;
}

#pragma mark - Delegate

/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss{
    NSLog(@"Will Dismiss");
    _ApplicationStatusIsHidden = NO;
}

/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index{
    NSLog(@"operation:%zd",index);
}

/**
 *  删除当前图片
 *
 *  @param index 相对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index{
    NSLog(@"delete-Relative:%zd",index);
}

/**
 *  删除当前图片
 *
 *  @param index 绝对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index{
    NSLog(@"delete-Absolute:%zd",index);
}

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success{
    NSLog(@"saveImage:%zd",success);
}



@end
