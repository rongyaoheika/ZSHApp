//
//  ZSHEnergyValueViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEnergyValueViewController.h"
#import "ZSHEnergyHeadCell.h"
#import "ZSHEnergyScoreCell.h"
#import "ZSHEnergyExchangeViewController.h"
#import "ZSHMineLogic.h"
#import "ZSHEnergyModel.h"

@interface ZSHEnergyValueViewController ()

@property (nonatomic, strong) NSArray             *pushVCsArr;
@property (nonatomic, strong) NSArray             *paramArr;
@property (nonatomic, strong) NSArray             *scoreSectionArr;
@property (nonatomic, strong) UIView              *headerView;

@property (nonatomic, strong) NSArray             *scoreRulesTitleArr;
@property (nonatomic, strong) NSArray             *scoreDetailArr;
@property (nonatomic, strong) ZSHMineLogic        *mineLogic;

@property (nonatomic, strong) NSArray             *energyModelArr;

@end

static NSString *ZSHEnergyHeadCellID = @"ZSHEnergyHeadCell";
static NSString *ZSHEnergyScoreCellID = @"ZSHEnergyScoreCell";
static NSString *ZSHEnergyDetailTopCellID = @"ZSHEnergyDetailTopCell";
static NSString *ZSHEnergyDetailBottomCellID = @"ZSHEnergyDetailBottomCell";
static NSString *ZSHEnergyRulesCellID = @"ZSHEnergyRulesCell";

@implementation ZSHEnergyValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    //分值组成
    _scoreSectionArr = @[
                         @{@"inCircleTopTitle":@"99",@"inCircleBottomTitle":@"购物分",@"leftColor":[UIColor colorWithHexString:@"D48B32"],
                           @"rightArr":@[@{@"rightColor":[UIColor colorWithHexString:@"D48B32"],@"rightTitle":@"购物分值  49"}]},
                         
                         @{@"inCircleTopTitle":@"99",@"inCircleBottomTitle":@"活动分",@"leftColor":[UIColor colorWithHexString:@"4B70C5"],
                           @"rightArr":@[@{@"rightColor":[UIColor colorWithHexString:@"89ADFF"],@"rightTitle":@"发起分值  49"},
                                         @{@"rightColor":[UIColor colorWithHexString:@"3A65C8"],@"rightTitle":@"参与分值  49"}]},
                         
                         @{@"inCircleTopTitle":@"99",@"inCircleBottomTitle":@"互动分",@"leftColor":[UIColor colorWithHexString:@"E34C4C"],
                           @"rightArr":@[@{@"rightColor":[UIColor colorWithHexString:@"F99696"],@"rightTitle":@"分享分值  49"},
                                         @{@"rightColor":[UIColor colorWithHexString:@"FE6F6F"],@"rightTitle":@"任务分值  49"},
                                         @{@"rightColor":[UIColor colorWithHexString:@"F14848"],@"rightTitle":@"签到分值  49"},
                                         @{@"rightColor":[UIColor colorWithHexString:@"C51818"],@"rightTitle":@"点攒分值  49"},
                                         @{@"rightColor":[UIColor colorWithHexString:@"7F1919"],@"rightTitle":@"打赏分值  49"}]},
                         
                         @{@"inCircleTopTitle":@"99",@"inCircleBottomTitle":@"基础分",@"leftColor":[UIColor colorWithHexString:@"EBE758"],
                           @"rightArr":@[@{@"rightColor":[UIColor colorWithHexString:@"FBF779"],@"rightTitle":@"实名认证  49"},
                                         @{@"rightColor":[UIColor colorWithHexString:@"F1C84B"],@"rightTitle":@"QQ绑定  49"},
                                         @{@"rightColor":[UIColor colorWithHexString:@"F6C53E"],@"rightTitle":@"微信绑定  49"},
                                         @{@"rightColor":[UIColor colorWithHexString:@"E39932"],@"rightTitle":@"微博绑定  49"},
                                         @{@"rightColor":[UIColor colorWithHexString:@"E57844"],@"rightTitle":@"支付宝绑定  49"}]},
                         
                         @{@"inCircleTopTitle":@"99",@"inCircleBottomTitle":@"荣耀分",@"leftColor":[UIColor colorWithHexString:@"69E2D3"],
                           @"rightArr":@[@{@"rightColor":[UIColor colorWithHexString:@"69E2D3"],@"rightTitle":@"慈善贡献  49"},
                                         @{@"rightColor":[UIColor colorWithHexString:@"3FC2B2"],@"rightTitle":@"互帮互助  49"},
                                         @{@"rightColor":[UIColor colorWithHexString:@"48B5CD"],@"rightTitle":@"参谋智者  49"},
                                         ]}
                         ];
    
    _scoreDetailArr = @[
                        @{@"headImageName":@"energy_icon_1",@"headTitle":@"购物分",@"detailTitle":@"购物分是购买金额的总和分值。每一笔订单、每日、每月、每一类商品、每一个店铺，可获得的最高可得分都不同，购买更多种类的、高信誉商家的商品可以得到更多分"},
                        @{@"headImageName":@"energy_icon_2",@"headTitle":@"活动分",@"detailTitle":@"活动分是发起活动和参与活动的总和分值。每一笔订单、每日、每月、每一类商品、每一个店铺，可获得的最高可得分都不同，购买更多种类的、高信誉商家的商品可以得到更多分"},
                        @{@"headImageName":@"energy_icon_3",@"headTitle":@"互动分",@"detailTitle":@"活动分是发起活动和参与活动的总和分值。每一笔订单、每日、每月、每一类商品、每一个店铺，可获得的最高可得分都不同，购买更多种类的、高信誉商家的商品可以得到更多分"},
                        @{@"headImageName":@"energy_icon_4",@"headTitle":@"荣耀分",@"detailTitle":@"活动分是发起活动和参与活动的总和分值。每一笔订单、每日、每月、每一类商品、每一个店铺，可获得的最高可得分都不同，购买更多种类的、高信誉商家的商品可以得到更多分"},
                        @{@"headImageName":@"energy_icon_5",@"headTitle":@"基础分",@"detailTitle":@"活动分是发起活动和参与活动的总和分值。每一笔订单、每日、每月、每一类商品、每一个店铺，可获得的最高可得分都不同，购买更多种类的、高信誉商家的商品可以得到更多分"}];
    
    _scoreRulesTitleArr = @[@"A  1-5000分免费兑换年度优礼品--价值1万元礼品包",@"B  5001-30000获得季度杂志【专刊一版】价值6万专访",@"C  30001-100000免费生日特定大礼包--价值3000元礼品包",@"D  100001-500000免费获得年度【黑咖之夜】价值1万元礼品包",@"E  500001-1000000获得黑咖企业推广一次--价值20万元广告礼品包"];
    [self initViewModel];
    _mineLogic = [[ZSHMineLogic alloc] init];
    [self requestEnergyList];

}

- (void)createUI{
    self.title = @"能量值";
    [self addNavigationItemWithTitles:@[@"去兑换"] isLeft:NO target:self action:@selector(exchangeAction) tags:@[@(1)]];
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight+kRealValue(10), KScreenWidth, kScreenHeight- KNavigationBarHeight-kRealValue(10));
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHEnergyHeadCell class] forCellReuseIdentifier:ZSHEnergyHeadCellID];
    [self.tableView registerClass:[ZSHEnergyScoreCell class] forCellReuseIdentifier:ZSHEnergyScoreCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHEnergyDetailTopCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHEnergyDetailBottomCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHEnergyRulesCellID];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeScoreSection]];
    
    for (int i = 0; i<[_scoreDetailArr count]; i++) {
        [self.tableViewModel.sectionModelArray addObject:[self storeScoreDetailSectionWithParamDic:_scoreDetailArr[i] index:i]];
    }
    
    [self.tableViewModel.sectionModelArray addObject:[self storeScoreRulesSection]];
    [self.tableView reloadData];
}

- (ZSHBaseTableViewSectionModel*)storeHeadSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(320);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHEnergyHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEnergyHeadCellID forIndexPath:indexPath];
        if (weakself.energyModelArr.count) {
            [cell updateCellWithDataArr:weakself.energyModelArr];
        }
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    return sectionModel;
}


// 分值组成
- (ZSHBaseTableViewSectionModel*)storeScoreSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(70);
    
    NSDictionary *headLabelDic = @{@"text":@"分值组成",@"font":kPingFangRegular(17)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headLabelDic];
    sectionModel.headerView.frame = CGRectMake(0, 0, KScreenWidth, kRealValue(70));
    for (int i = 0; i<self.scoreSectionArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(90);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHEnergyScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEnergyScoreCellID forIndexPath:indexPath];
            NSDictionary *nextParamDic = weakself.scoreSectionArr[indexPath.row];
            [cell updateCellWithParamDic:nextParamDic];
            if (weakself.energyModelArr.count) {
                ZSHEnergyModel *model = weakself.energyModelArr[indexPath.row];
                [cell updateCellWithModel:model];
            }
            return cell;
        };
    }
    return sectionModel;
}

- (ZSHBaseTableViewSectionModel*)storeScoreDetailSectionWithParamDic:(NSDictionary *)paramDic index:(NSInteger)index{
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    kWeakSelf(self);
    if (index == 0) {
        sectionModel.headerHeight = kRealValue(70);
        NSDictionary *headLabelDic = @{@"text":@"能量值详细介绍",@"font":kPingFangRegular(17),@"textAlignment":@(NSTextAlignmentCenter)};
        sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headLabelDic];
        sectionModel.headerView.frame = CGRectMake(0, 0, KScreenWidth, kRealValue(70));
    }
    
    sectionModel.footerHeight = kRealValue(20);
    sectionModel.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(20))];
    
    //第一行
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(46);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEnergyDetailTopCellID forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:paramDic[@"headImageName"]];
        cell.textLabel.text = paramDic[@"headTitle"];
        if (weakself.energyModelArr.count) {
            ZSHEnergyModel *model = weakself.energyModelArr[index];
            cell.textLabel.text = model.NAME;
        }
        cell.textLabel.font = kPingFangRegular(14);
        return cell;
    };
    
    //第二行
    cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    kWeakSelf(cellModel);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEnergyDetailBottomCellID forIndexPath:indexPath];
        if (![cell.contentView viewWithTag:1]) {
            NSDictionary *detailLabelDic = @{@"text":paramDic[@"detailTitle"],@"font":kPingFangRegular(12),@"textAlignment":@(NSTextAlignmentCenter)};
            UILabel  *detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailLabelDic];
            detailLabel.tag = 1;
            detailLabel.numberOfLines = 0;
            [detailLabel setLineBreakMode:NSLineBreakByWordWrapping];

            //行间距
            NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle  setLineSpacing:5];
            NSString *string = paramDic[@"detailTitle"];
            if (weakself.energyModelArr.count) {
                ZSHEnergyModel *model = weakself.energyModelArr[index];
                string = model.INTRODUCE;
            }
            
            NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:string];
            [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
            
            [detailLabel  setAttributedText:setString];
            [cell.contentView addSubview:detailLabel];
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell).offset(KLeftMargin);
                make.right.mas_equalTo(cell).offset(-KLeftMargin);
                make.top.mas_equalTo(cell);
            }];
            
            CGSize detailSize = [ZSHSpeedy zsh_calculateTextSizeWithText:detailLabel.text WithTextFont:detailLabel.font WithMaxW:KScreenWidth - kRealValue(30)];
            weakcellModel.height = detailSize.height + kRealValue(10);
        }
        return cell;
    };
    return sectionModel;
}

- (ZSHBaseTableViewSectionModel*)storeScoreRulesSection{
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(70);
    NSDictionary *headLabelDic = @{@"text":@"能量值使用规则",@"font":kPingFangRegular(17),@"textAlignment":@(NSTextAlignmentCenter)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headLabelDic];
    sectionModel.headerView.frame = CGRectMake(0, 0, KScreenWidth, kRealValue(70));
    
    for (int i = 0; i<_scoreRulesTitleArr.count; i++) {
        
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        kWeakSelf(cellModel);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEnergyRulesCellID forIndexPath:indexPath];
            if (![cell.contentView viewWithTag:3]) {
                NSDictionary *detailLabelDic = @{@"text":_scoreRulesTitleArr[i],@"font":kPingFangRegular(12)};
                UILabel  *detailLabel = [ZSHBaseUIControl createLabelWithParamDic:detailLabelDic];
                detailLabel.tag = 3;
                detailLabel.numberOfLines = 0;
                [detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
                
                //行间距
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle  setLineSpacing:5];
                NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:_scoreRulesTitleArr[i]];
                [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_scoreRulesTitleArr[i] length])];
                [detailLabel setAttributedText:setString];
                
                [cell.contentView addSubview:detailLabel];
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell).offset(KLeftMargin);
                    make.right.mas_equalTo(cell).offset(-KLeftMargin);
                    make.top.mas_equalTo(cell);
                }];
                
                CGSize detailSize = [ZSHSpeedy zsh_calculateTextSizeWithText:detailLabel.text WithTextFont:detailLabel.font WithMaxW:KScreenWidth - kRealValue(30)];
                weakcellModel.height = detailSize.height + kRealValue(18);
            }
           
            return cell;
        };
    }
    return sectionModel;
}


#pragma action
- (void)requestEnergyList {
    kWeakSelf(self);
    [_mineLogic requestEnergyList:^(id response) {
        weakself.energyModelArr = [ZSHEnergyModel mj_objectArrayWithKeyValuesArray:response[@"pd"]];
        [weakself initViewModel];
    }];
}




- (void)exchangeAction{
    ZSHEnergyExchangeViewController *eeVC = [[ZSHEnergyExchangeViewController alloc] init];
    [self.navigationController pushViewController:eeVC animated:true];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
