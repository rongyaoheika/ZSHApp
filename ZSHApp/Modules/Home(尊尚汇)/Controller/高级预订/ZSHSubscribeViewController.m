//
//  ZSHSubscribeViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSubscribeViewController.h"
#import "ZSHMoreLogic.h"
#import "ZSHHotelCalendarCell.h"

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

@property (nonatomic, strong) ZSHHotelCalendarCell  *calendarCell;
@property (nonatomic, strong) ZSHBottomBlurPopView  *bottomBlurPopView;

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
    kWeakSelf(self);
    // height 1167
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.scrollEnabled = true;
    _scrollView.contentSize = CGSizeMake(KScreenWidth, 0);
    [self.view addSubview:_scrollView];
//    [_scrollView addGestureRecognizer:[]];
    
    
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
        make.top.mas_equalTo(_headImageView.mas_bottom).offset(kRealValue(10));
        make.left.mas_equalTo(self.view).offset(KLeftMargin);
        make.right.mas_equalTo(self.view).offset(-KLeftMargin);
    }];
    
    
    _middleImageView = [[UIImageView alloc] init];
//    _middleImageView.image = [UIImage imageNamed:self.dataArr[2]];
    [_scrollView addSubview:_middleImageView];
    [_middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(kRealValue(10));
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kRealValue(240)));
    }];
    
    //self.dataArr[4],
    NSDictionary *subTitleDic = @{@"text":@"", @"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _subTitleLabel = [ZSHBaseUIControl createLabelWithParamDic:subTitleDic];
    _subTitleLabel.numberOfLines = 0;
    [_scrollView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_middleImageView.mas_bottom).offset(kRealValue(10));
        make.centerX.mas_equalTo(_scrollView);
        make.left.mas_equalTo(self.view).offset(KLeftMargin);
        make.right.mas_equalTo(self.view).offset(-KLeftMargin);
    }];
    
    
    _bottomImageView = [[UIImageView alloc] init];
//    _bottomImageView.image = [UIImage imageNamed:self.dataArr[3]];
    [_scrollView addSubview:_bottomImageView];
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_subTitleLabel.mas_bottom).offset(kRealValue(10));
        make.centerX.mas_equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kRealValue(240)));
    }];
    

    NSDictionary *contentLabelDic = @{@"text":@"", @"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _contentLabel = [ZSHBaseUIControl createLabelWithParamDic:contentLabelDic];
    _contentLabel.numberOfLines = 0;
    [_scrollView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bottomImageView.mas_bottom).offset(kRealValue(10));
        make.left.mas_equalTo(self.view).offset(KLeftMargin);
        make.right.mas_equalTo(self.view).offset(-KLeftMargin);
    }];
    
    NSDictionary *noticeLabelDic = @{@"text":@"注意事项", @"font":kPingFangMedium(KLeftMargin),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    _noticeLabel = [ZSHBaseUIControl createLabelWithParamDic:noticeLabelDic];
    [_scrollView addSubview:_noticeLabel];
    [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentLabel.mas_bottom).offset(kRealValue(30));
        make.centerX.mas_equalTo(_scrollView);
        make.width.mas_equalTo(kRealValue(62));
        
    }];
    
    
    NSDictionary *noticeDetailLabelDic = @{@"text":@"", @"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _noticeDetailLabel = [ZSHBaseUIControl createLabelWithParamDic:noticeDetailLabelDic];
    _noticeDetailLabel.numberOfLines = 0;
    [_scrollView addSubview:_noticeDetailLabel];
    [_noticeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_noticeLabel.mas_bottom).offset(kRealValue(10));
        make.height.mas_equalTo(kRealValue(100));
        make.left.mas_equalTo(self.view).offset(KLeftMargin);
        make.right.mas_equalTo(self.view).offset(-KLeftMargin);
    }];
    
    _calendarCell = [[ZSHHotelCalendarCell alloc]init];
    [_scrollView addSubview:_calendarCell];
    [_calendarCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_noticeDetailLabel.mas_bottom).offset(kRealValue(10));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kRealValue(65));
    }];
    
    _calendarCell.dateViewTapBlock = ^(NSInteger tag) {//tag = 1入住
        NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromHotelDetailCalendarVCToBottomBlurPopView),@"btnTag":@(tag)};
        weakself.bottomBlurPopView = [weakself createBottomBlurPopViewWithParamDic:nextParamDic];
        [kAppDelegate.window addSubview:weakself.bottomBlurPopView];
    };
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.mas_equalTo(_calendarCell.mas_bottom).offset(kRealValue(20) + KBottomTabH);
    }];

    
    NSDictionary *requestDic = self.paramDic[@"requestDic"];
    [self.view addSubview:[ZSHBaseUIControl createBottomButton:^(NSInteger index) {//立即购买-生成订单
        if (index == 3) {
            NSString *beginDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"beginDate"];
            NSString *endDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"endDate"];
            NSString *days = [[NSUserDefaults standardUserDefaults]objectForKey:@"days"];
            NSString *liveInfoStr = [NSString stringWithFormat:@"%@开始，%@结束，%@",beginDate,endDate,days];
            
            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHSubscribeVCToBottomBlurPopView),@"requestDic":requestDic,@"shopType":@(ZSHShipType),@"liveInfoStr":liveInfoStr};
            weakself.bottomBlurPopView = [weakself createBottomBlurPopViewWithParamDic:nextParamDic];
            [weakself.view addSubview:weakself.bottomBlurPopView];
        }
    }]];
}

- (void)updateUI{
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]]];
    [_middleImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[1]]];
    [_bottomImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[2]]];
    
    _titleLabel.text = _listDataDicArr[0][@"PUPINTROTITLE"];
    _contentLabel.text = _listDataDicArr[0][@"PUPINTROCONTENT"];
    _noticeLabel.text = _listDataDicArr[0][@"PDOWNINTROTITLE"];
    _noticeDetailLabel.text = _listDataDicArr[0][@"PDOWNINTROCONTENT"];

    [_titleLabel setAttributedText:[self setAtrribute:_titleLabel.text lineSpacing:6 paragraphSpacing:0]];
    [_contentLabel setAttributedText:[self setAtrribute:_contentLabel.text lineSpacing:6 paragraphSpacing:0]];
    [_subTitleLabel setAttributedText:[self setAtrribute:_subTitleLabel.text lineSpacing:6 paragraphSpacing:0]];
    [_noticeDetailLabel setAttributedText:[self setAtrribute:_listDataDicArr[0][@"PDOWNINTROCONTENT"] lineSpacing:6 paragraphSpacing:22]];
    
}

- (NSMutableAttributedString *)setAtrribute:(NSString *)str lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing{
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:lineSpacing];
    [paragraphStyle setParagraphSpacing:paragraphSpacing];
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:str];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return setString;
}

#pragma getter
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWithParamDic:(NSDictionary *)paramDic{
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:paramDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    return bottomBlurPopView;
}

@end
