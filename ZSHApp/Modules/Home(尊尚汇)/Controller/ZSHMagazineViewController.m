//
//  ZSHMagazineViewController.m
//  ZSHApp
//
//  Created by mac on 05/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHMagazineViewController.h"
#import "ZSHHomeLogic.h"

@interface ZSHMagazineViewController ()

@property (nonatomic, strong) UIImageView  *headImageView;
@property (nonatomic, strong) UIImageView  *headBgImageView;
@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) UILabel      *contentLabel;
@property (nonatomic, strong) UILabel      *relevantLable;
@property (nonatomic, strong) ZSHHomeLogic *homeLogic;

@end

@implementation ZSHMagazineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData {
    _homeLogic = [[ZSHHomeLogic alloc] init];
    [self requestData];
}


- (void)createUI {
    self.title = @"荣耀杂志";
    
    _headBgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"home_magazine1"]applyDarkEffect]];
    [self.view addSubview:_headBgImageView];
    [_headBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(225);
    }];
    
    _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_magazine1"]];
    [_headBgImageView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headBgImageView).offset(7.5);
        make.bottom.mas_equalTo(_headBgImageView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(kRealValue(120),139.5));
    }];
    
    
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"《时代》：充分了解世界大事", @"font":kPingFangRegular(14)}];
    [_headBgImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImageView.mas_right).offset(kRealValue(10.5));
        make.centerY.mas_equalTo(_headBgImageView).offset(20);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(_headBgImageView).offset(kRealValue(-8));
    }];
    
    _contentLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"font":kPingFangRegular(14)}];
    _contentLabel.numberOfLines = 0;
    NSString *string = @"《时代》追溯孤立事件的来龙去脉，介绍外国国家，讲它们的版图与俄勒冈或蒙大拿一样大小，援引它们的政治情况，帮助读者克服拼读名称方面的困难，以及使用报纸从未用过的图表等";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:string];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    CGSize detailLabelSize = [string boundingRectWithSize:CGSizeMake(kScreenWidth-kRealValue(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    [_contentLabel setAttributedText:setString];
    
    [self.view addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(KLeftMargin);
        make.top.mas_equalTo(_headBgImageView.mas_bottom).offset(29.5);
        make.right.mas_equalTo(self.view).offset(-KLeftMargin);
        make.height.mas_equalTo(detailLabelSize);
    }];
    
    _relevantLable = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"相关推荐", @"font":kPingFangMedium(15)}];
    [self.view addSubview:_relevantLable];
    [_relevantLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(_contentLabel);
        make.height.mas_equalTo(16);
        
    }];
    
    // 等宽排列
    CGFloat space = (KScreenWidth - kRealValue(30 + 80*4))/3;
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_magazine1"]];
        imageView.tag = 180106+i;
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(KLeftMargin+(kRealValue(80)+space)*i);
            make.top.mas_equalTo(_relevantLable.mas_bottom).offset(KLeftMargin);
            make.size.mas_equalTo(CGSizeMake(kRealValue(80), 100));
        }];
    }

}

- (void)requestData {
    kWeakSelf(self);
    NSDictionary *dic = self.paramDic[@"magazine"];
    [_homeLogic loadMagzineOneWithDic:@{@"MAGAZINE_ID":dic[@"MAGAZINE_ID"], @"MAGAZINETYPE":dic[@"MAGAZINETYPE"]} success:^(id response) {
        NSArray *imageList = response[@"list"];
        NSDictionary *dic = response[@"magazine"];
        [weakself updateData:dic list:imageList];
    }];
}

- (void)updateData:(NSDictionary *)dic list:(NSArray *)list {
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"SHOWIMG"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            _headBgImageView.image = [image applyDarkEffect];
        }
    }];

    _titleLabel.text = dic[@"TITLE"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:dic[@"INTRODUCE"]];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [dic[@"INTRODUCE"] length])];
    [_contentLabel setAttributedText:setString];
    for (int i = 0; i < list.count; i++) {
        UIImageView *imageView = [self.view viewWithTag:180106+i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:list[i][@"SHOWIMG"]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
