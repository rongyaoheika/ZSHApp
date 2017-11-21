//
//  ZSHNoticeViewCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHNoticeViewCell.h"
#import "ZSHNotCycleScrollView.h"
#import "ZSHBaseModel.h"
#import "ZSHHotelDetailViewController.h"

@interface ZSHNoticeViewCell()

@property (nonatomic, strong)  ZSHNotCycleScrollView      *itemScrollView;
@property (nonatomic ,strong)  NSMutableArray             *btnArr;
@property (nonatomic ,strong)  ZSHBaseModel               *model;
@property (nonatomic ,strong)  UIButton                   *giftTypeBtn;
@end

@implementation ZSHNoticeViewCell

- (void)setup {
    kWeakSelf(self);
    [self addSubview:self.itemScrollView];
    self.itemScrollView.selectedBlock = ^(NSInteger index){
        if (weakself.itemClickBlock) {
            weakself.itemClickBlock(index);
        }
    };
    
//    [self reloadListData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.itemScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(KScreenWidth);
    }];
}

- (ZSHNotCycleScrollView *)itemScrollView{
    if (!_itemScrollView) {
        _itemScrollView = [[ZSHNotCycleScrollView alloc] init];
        _itemScrollView.selectedColor = KClearColor;
        _itemScrollView.indicatorHeight = 0.0;
        _itemScrollView.itemWidth = kRealValue(95);
        _itemScrollView.normalTitleFont = kPingFangRegular(12);
        _itemScrollView.selectedTitleFont = kPingFangRegular(12);
    }
    return _itemScrollView;
}

- (void)updateCellWithParamDic:(NSDictionary *)paramDic{
    _btnArr = [[NSMutableArray alloc]init];
    if ([paramDic[KFromClassType]integerValue] == FromHomeNoticeVCToNoticeView) {
        _itemScrollView.itemWidth = kRealValue(95);
        NSArray *titleArr = @[@"2.4.6.8娱乐吧",@"逸林游艇",@"麦乐迪KTV",@"海帆酒吧"];
//        for (int i = 1; i<5; i++) {
//            NSString *imageName = [NSString stringWithFormat:@"home_notice%d",i];
//            UIButton *btn = [[UIButton alloc]init];
//            [btn setTitle:titleArr[i-1] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//            [btn setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
//            btn.titleLabel.font = kPingFangRegular(12);
//            [_btnArr addObject:btn];
//        }
        
        //数组字典
        NSArray *dataArr = paramDic[@"dataArr"];
        for (NSDictionary *dic in dataArr) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"IMAGES"]]];
            UIImage *image = [UIImage imageWithData:data]; // 取得图片
            UIButton *btn = [[UIButton alloc]init];
            [btn setTitle:dic[@"SHOPNAME"] forState:UIControlStateNormal];
            [btn setImage:image forState:UIControlStateNormal];
            [btn setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
            [_btnArr addObject:btn];
        }
        
        self.itemScrollView.selectedBlock = ^(NSInteger index) {
            if (index == 2) {
                NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromHomeKTVVCToHotelDetailVC)};
                ZSHHotelDetailViewController *hotelDetailVC = [[ZSHHotelDetailViewController alloc]initWithParamDic:nextParamDic];
                [[kAppDelegate getCurrentUIVC].navigationController pushViewController:hotelDetailVC animated:YES];
            }
        };
        
    } else if ([paramDic[KFromClassType]integerValue]  == FromHomeServiceVCToNoticeView) {
        _itemScrollView.itemWidth = kRealValue(130);
        for (int i = 1; i<4; i++) {
            NSString *imageName = [NSString stringWithFormat:@"home_service%d",i];
            UIButton *btn = [[UIButton alloc]init];
            [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [_btnArr addObject:btn];
        }

    }  else if ([paramDic[KFromClassType]integerValue]  == FromHomeMagazineVCToNoticeView) {
         _itemScrollView.itemWidth = kRealValue(95);
        
        for (int i = 1; i<5; i++) {
            NSString *imageName = [NSString stringWithFormat:@"home_magazine%d",i];
            UIButton *btn = [[UIButton alloc]init];
            [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [_btnArr addObject:btn];
        }
    } else if ([paramDic[KFromClassType]integerValue] == FromKTVCalendarVCToNoticeView) {
        _itemScrollView.itemWidth = kRealValue(70);
        _itemScrollView.fromClassType = FromKTVCalendarVCToNoticeView;
        NSArray *topTitleArr = @[@"今天",@"周三",@"周四",@"周五",@"周六",@"周日",@"周一"];
        NSArray *bottomTitleArr = @[@"10-10",@"10-11",@"10-12",@"10-13",@"10-14",@"10-15",@"10-16"];
        for (int i = 0; i<topTitleArr.count; i++) {
            NSDictionary *topDic = @{@"text":topTitleArr[i],@"font":kPingFangMedium(12),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(30)};
            NSDictionary *bottomDic = @{@"text":bottomTitleArr[i],@"font":kPingFangMedium(12),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(30)};
            UIButton *calendarBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:topDic bottomDic:bottomDic];
            [_btnArr addObject:calendarBtn];
        } 
    } else if ([paramDic[KFromClassType]integerValue]  == FromKTVRoomTypeVCToNoticeView) {
        
        NSArray *titleArr = @[@"小包（2-4人）",@"中包（4-6人）",@"大包（6-8人）",@"VIP小包（8-10人）"];
        _itemScrollView.itemWidth = kRealValue(85);
        _itemScrollView.fromClassType = FromKTVRoomTypeVCToNoticeView;
        for (int i = 0; i<titleArr.count; i++) {
            NSDictionary *roomTypeBtnDic = @{@"title":titleArr[i],@"font":kPingFangRegular(12)};
            UIButton *roomTypeBtn = [ZSHBaseUIControl createBtnWithParamDic:roomTypeBtnDic];
            roomTypeBtn.layer.cornerRadius = kRealValue(2.5);
            roomTypeBtn.layer.borderWidth = 0.5;
            roomTypeBtn.layer.borderColor = KZSHColor929292.CGColor;
            [_btnArr addObject:roomTypeBtn];
        }
    } else if ([paramDic[KFromClassType]integerValue] == FromMemberCenterVCToNoticeView) {
        _itemScrollView.itemWidth = kRealValue(145);
        _itemScrollView.fromClassType = FromMemberCenterVCToNoticeView;
        NSArray *titleArr = @[@"升级礼包",@"黑咖币返利",@"管家服务",@"生日礼包",];
        NSArray *imageArr = @[@"member_image_2",@"member_image_3",@"member_image_4",@"member_image_5"];
        for (int i = 0; i<titleArr.count; i++) {
            NSDictionary *btnDic = @{@"bgImage":imageArr[i],@"title":titleArr[i],@"detail":@"能量值700以上\n有机会获得福利"};
            UIButton *roomTypeBtn = [self createGiftTypeBtnWithParamDic:btnDic];
            [_btnArr addObject:roomTypeBtn];
        }
    }
    
     [self.itemScrollView reloadViewWithDataArr:_btnArr];
}

//会员中心卡片
- (UIButton *)createGiftTypeBtnWithParamDic:(NSDictionary *)paramDic{
    
    UIButton *btn  = [[UIButton alloc]init];
    [btn setBackgroundImage:[UIImage imageNamed:paramDic[@"bgImage"]] forState:UIControlStateNormal];
    
     NSDictionary *topTitleLabelDic = @{@"text":paramDic[@"title"],@"font":kPingFangRegular(12),@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *topTitleLabel = [ZSHBaseUIControl createLabelWithParamDic:topTitleLabelDic];
    [btn addSubview:topTitleLabel];
    [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btn);
        make.height.mas_equalTo(kRealValue(11));
        make.top.mas_equalTo(btn).offset(kRealValue(15));
        make.width.mas_equalTo(btn);
    }];
    
    NSDictionary *detailTitleLabelDic = @{@"text":paramDic[@"detail"],@"font":kPingFangRegular(10),@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *detailTitleLabel = [ZSHBaseUIControl createLabelWithParamDic:detailTitleLabelDic];
    detailTitleLabel.numberOfLines = 2;
    [detailTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [btn addSubview:detailTitleLabel];
    [detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btn);
        make.height.mas_equalTo(kRealValue(28));
        make.top.mas_equalTo(topTitleLabel.mas_bottom).offset(kRealValue(20));
        make.width.mas_equalTo(kRealValue(75));
    }];
    
    return btn;
}

@end
