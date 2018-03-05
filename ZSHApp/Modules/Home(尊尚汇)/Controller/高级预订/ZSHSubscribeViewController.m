//
//  ZSHSubscribeViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSubscribeViewController.h"
#import "ZSHMoreLogic.h"

@interface ZSHSubscribeViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView  *headImageView;
@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) UIImageView  *middleImageView;
@property (nonatomic, strong) UIImageView  *bottomImageView;
@property (nonatomic, strong) UILabel      *subTitleLabel;
@property (nonatomic, strong) UILabel      *contentLabel;
@property (nonatomic, strong) UILabel      *noticeLabel;
@property (nonatomic, strong) UILabel      *noticeDetailLabel;
@property (nonatomic, strong) UIButton     *stewardBtn;


@property (nonatomic, strong) NSArray      *dataArr;
@property (nonatomic, strong) ZSHMoreLogic *moreLogic;
@property (nonatomic, strong) NSArray      *listDataDicArr;
@property (nonatomic, strong) NSArray      *listDic;
@property (nonatomic, strong) NSArray      *imageArr;

@end

@implementation ZSHSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self requestListData];
}

- (void)requestListData{
    kWeakSelf(self);
    _moreLogic = [[ZSHMoreLogic alloc]init];
    ZSHShopType shopType = [self.paramDic[@"localDic"][KFromClassType] integerValue];
    NSDictionary *requestDic = self.paramDic[@"requestDic"];
   
    NSDictionary *paramDic = nil;
    if (!shopType) {//飞机
        shopType = kFromClassTypeValue;
    }
    
    switch (shopType) {
        case ZSHHorseType:{//马术
            paramDic = @{@"HORSESHOP_ID":requestDic[@"HORSESHOP_ID"]};
            [_moreLogic requestHorseDetailWithParamDic:paramDic success:^(NSArray *dataArr) {
                _listDataDicArr = dataArr;
                _imageArr = _listDataDicArr[0][@"HORSEDETIMGS"];
                _subTitleLabel.text = _listDataDicArr[0][@"HORSEDETINTRO"];
                [weakself updateUI];
            } fail:nil];
            
            break;
        }
        case ZSHShipType:{//游艇
            if (self.paramDic[@"shopId"]) {//主页推荐-游艇
                paramDic = @{@"YACHTSHOP_ID":self.paramDic[@"shopId"]};
            } else {//更多特权-列表-详情
               paramDic = @{@"YACHTSHOP_ID":requestDic[@"YACHTSHOP_ID"]};
            }
            [_moreLogic requestYachtDetailWithParamDic:paramDic success:^(NSArray *dataArr) {
                _listDataDicArr = dataArr;
                _imageArr = _listDataDicArr[0][@"YACHTDETIMGS"];
                _subTitleLabel.text = _listDataDicArr[0][@"YACHTDETINTRO"];
                [weakself updateUI];
            } fail:nil];
            
            break;
        }
        case ZSHGolfType:{//高尔夫汇
            paramDic = @{@"GOLFSHOP_ID":requestDic[@"GOLFSHOP_ID"]};
            [_moreLogic requestGolfDetailWithParamDic:paramDic success:^(NSArray *dataArr) {
                _listDataDicArr = dataArr;
                _imageArr = _listDataDicArr[0][@"GOLFDETIMGS"];
                _subTitleLabel.text = _listDataDicArr[0][@"GOLFDETINTRO"];
                [weakself updateUI];
            } fail:nil];
            
            break;
        }
        case ZSHLuxcarType:{//豪车
           paramDic = @{@"LUXCARSHOP_ID":requestDic[@"LUXCARSHOP_ID"]};
            [_moreLogic requestLuxcarDetailWithParamDic:paramDic success:^(NSArray *dataArr) {
               _listDataDicArr = dataArr;
               _imageArr = _listDataDicArr[0][@"LUXCARDETIMGS"];
               _subTitleLabel.text = _listDataDicArr[0][@"LUXCARDETINTRO"];
               [weakself updateUI];
            } fail:nil];
            
            break;
        }
        case ZSHPlaneType:{//飞机
            [_moreLogic requestPlaneDetailWithParamDic:nil success:^(NSArray *dataArr) {
                _listDataDicArr = dataArr;
                _imageArr = _listDataDicArr[0][@"PLANEDETIMGS"];
                _subTitleLabel.text = _listDataDicArr[0][@"PLANEDETINTRO"];
                [weakself updateUI];
            } fail:nil];
            
            break;
        }
        case ZSHServiceType:{//服务
            paramDic = @{@"SERVER_ID":self.paramDic[@"shopId"], @"SHOPTYPE":self.paramDic[@"SHOPTYPE"]};
            [_moreLogic requestServiceDetailDataWithParamDic:paramDic Success:^(NSArray *dataArr) {
                _listDataDicArr = dataArr;
                if ([paramDic[@"SHOPTYPE"] isEqualToString:@"马术"]) {
                    _imageArr = _listDataDicArr[0][@"HORSEDETIMGS"];
                    _subTitleLabel.text = _listDataDicArr[0][@"HORSEDETINTRO"];
                    [weakself updateUI];
                } else if([paramDic[@"SHOPTYPE"] isEqualToString:@"飞机"]) {
                    _imageArr = _listDataDicArr[0][@"PLANEDETIMGS"];
                    _subTitleLabel.text = _listDataDicArr[0][@"PLANEDETINTRO"];
                    [weakself updateUI];
                } else if([paramDic[@"SHOPTYPE"] isEqualToString:@"豪车"]) {
                    _imageArr = _listDataDicArr[0][@"LUXCARDETIMGS"];
                    _subTitleLabel.text = _listDataDicArr[0][@"LUXCARDETINTRO"];
                    [weakself updateUI];
                } 

            } fail:nil];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)createUI{
    
    // height 1167
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.scrollEnabled = true;
    _scrollView.contentSize = CGSizeMake(KScreenWidth, 0);
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _headImageView = [[UIImageView alloc] init];
//    _headImageView.image = [UIImage imageNamed:self.dataArr[0]];
    [_scrollView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(_scrollView);
        make.height.mas_equalTo(kRealValue(225));
        make.width.mas_equalTo(KScreenWidth);
    }];
    
    //self.dataArr[1]
    NSDictionary *titleLabelDic = @{@"text":@"", @"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    _titleLabel.numberOfLines = 0;
    [_scrollView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImageView).offset(kRealValue(235));
        make.centerX.mas_equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(345), kRealValue(37)));
    }];
    
    
    _middleImageView = [[UIImageView alloc] init];
//    _middleImageView.image = [UIImage imageNamed:self.dataArr[2]];
    [_scrollView addSubview:_middleImageView];
    [_middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel).offset(kRealValue(51));
        make.centerX.mas_equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(375), kRealValue(240)));
    }];
    
    //self.dataArr[4],
    NSDictionary *subTitleDic = @{@"text":@"", @"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _subTitleLabel = [ZSHBaseUIControl createLabelWithParamDic:subTitleDic];
    _subTitleLabel.numberOfLines = 0;
    [_scrollView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_middleImageView).offset(kRealValue(260));
        make.centerX.mas_equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(345), kRealValue(51)));
    }];
    
    
    _bottomImageView = [[UIImageView alloc] init];
//    _bottomImageView.image = [UIImage imageNamed:self.dataArr[3]];
    [_scrollView addSubview:_bottomImageView];
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_subTitleLabel).offset(kRealValue(60));
        make.centerX.mas_equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(375), kRealValue(240)));
    }];
    

    NSDictionary *contentLabelDic = @{@"text":@"", @"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _contentLabel = [ZSHBaseUIControl createLabelWithParamDic:contentLabelDic];
    _contentLabel.numberOfLines = 0;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5.0; //设置行间距
    NSDictionary *dic = @{
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@0.11f
                          };
//    self.dataArr[5]
    _contentLabel.attributedText = [[NSAttributedString alloc] initWithString:@"aa" attributes:dic];
    [_scrollView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bottomImageView).offset(kRealValue(250));
        make.centerX.mas_equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(346), kRealValue(54)));
    }];
    
    NSDictionary *noticeLabelDic = @{@"text":@"注意事项", @"font":kPingFangMedium(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    _noticeLabel = [ZSHBaseUIControl createLabelWithParamDic:noticeLabelDic];
    [_scrollView addSubview:_noticeLabel];
    [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentLabel).offset(kRealValue(74));
        make.centerX.mas_equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(62), kRealValue(16)));
    }];
    
    
    NSDictionary *noticeDetailLabelDic = @{@"text":@"", @"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _noticeDetailLabel = [ZSHBaseUIControl createLabelWithParamDic:noticeDetailLabelDic];
    _noticeDetailLabel.numberOfLines = 0;
    [_scrollView addSubview:_noticeDetailLabel];
    [_noticeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_noticeLabel).offset(kRealValue(26));
        make.centerX.mas_equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(345), kRealValue(100)));
        make.bottom.mas_equalTo(_scrollView).offset(-132);
    }];
    
    NSDictionary *stewardBtnDic = @{@"title":@"召唤管家",@"titleColor":KZSHColor929292,@"font":kPingFangMedium(17),@"backgroundColor":KBlackColor};
    _stewardBtn = [ZSHBaseUIControl createBtnWithParamDic:stewardBtnDic];
    [self.view addSubview:_stewardBtn];
    [_stewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(kRealValue(KScreenWidth));
        make.height.mas_equalTo(kRealValue(49));
    }];
}

- (void)updateUI{
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]]];
    [_middleImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[1]]];
    [_bottomImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[2]]];
    
    _titleLabel.text = _listDataDicArr[0][@"PUPINTROTITLE"];
    _contentLabel.text = _listDataDicArr[0][@"PUPINTROCONTENT"];
    _noticeLabel.text = _listDataDicArr[0][@"PDOWNINTROTITLE"];
    _noticeDetailLabel.text = _listDataDicArr[0][@"PDOWNINTROCONTENT"];
    
    NSMutableParagraphStyle *titleLBStyle = [[NSMutableParagraphStyle alloc] init];
    [titleLBStyle setLineSpacing:6];
    NSMutableAttributedString *titleLBSetString = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
    [titleLBSetString addAttribute:NSParagraphStyleAttributeName value:titleLBStyle range:NSMakeRange(0, [_titleLabel.text length])];
    [_titleLabel setAttributedText:titleLBSetString];
    
    
    NSMutableParagraphStyle *contentLBStyle = [[NSMutableParagraphStyle alloc] init];
    [contentLBStyle setLineSpacing:6];
    NSMutableAttributedString *contentLBSetString = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
    [contentLBSetString addAttribute:NSParagraphStyleAttributeName value:contentLBStyle range:NSMakeRange(0, [_contentLabel.text length])];
    [_contentLabel setAttributedText:contentLBSetString];
    
    NSMutableParagraphStyle *subTitleLBStyle = [[NSMutableParagraphStyle alloc] init];
    [subTitleLBStyle setLineSpacing:6];
    NSMutableAttributedString *subTitleLBSetString = [[NSMutableAttributedString alloc] initWithString:_subTitleLabel.text];
    [subTitleLBSetString addAttribute:NSParagraphStyleAttributeName value:contentLBStyle range:NSMakeRange(0, [_subTitleLabel.text length])];
    [_subTitleLabel setAttributedText:subTitleLBSetString];
    
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:5];
    [paragraphStyle setParagraphSpacing:22];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:_listDataDicArr[0][@"PDOWNINTROCONTENT"]];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_listDataDicArr[0][@"PDOWNINTROCONTENT"] length])];
    [_noticeDetailLabel setAttributedText:setString];
    
}

@end
