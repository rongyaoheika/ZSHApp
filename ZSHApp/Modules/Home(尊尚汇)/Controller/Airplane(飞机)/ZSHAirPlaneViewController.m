//
//  ZSHAirPlaneViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHAirPlaneViewController.h"
#import "ZSHTicketPlaceCell.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHTitleContentViewController.h"
#import "ZSHPickView.h"
#import "ZSHTrainSearchResultController.h"

@interface ZSHAirPlaneViewController ()

@property (nonatomic, strong) ZSHBottomBlurPopView      *bottomBlurPopView;
@property (nonatomic, strong) ZSHPickView               *pickView;

@end

static NSString *ZSHTicketPlaceCellID = @"ZSHTicketPlaceCell";
static NSString *ZSHBaseTicketDateCellID = @"ZSHBaseTicketDateCell";
@implementation ZSHAirPlaneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
}

- (void)createUI{
    self.title = self.paramDic[@"title"];
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    self.tableView.frame = CGRectMake(kRealValue(37.5), KNavigationBarHeight+kRealValue(32), kScreenWidth - 2*kRealValue(37.5), kRealValue(240));
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHTicketPlaceCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseTicketDateCellID];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"开始搜索" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(searchTicketAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    cellModel.height = kRealValue(60);
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        //起始位置
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHTicketPlaceCellID];
        ZSHTicketPlaceCell *ticketView = [[ZSHTicketPlaceCell alloc]initWithFrame:CGRectZero paramDic:nil];
        ticketView.tag = 2;
        [cell.contentView addSubview:ticketView];
        [ticketView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell);
        }];
        
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    
    if (kFromClassTypeValue == ZSHHomeAirPlaneVCToAirPlaneVC) {
        //出发日期,席别
        NSArray *titleArr = @[@"出发日期",@"席别"];
        NSArray *valueArr = @[@"2017-9-25",@"经济舱"];
        for (int i = 0; i<2; i++) {
            cellModel = [[ZSHBaseTableViewCellModel alloc] init];
            cellModel.height = kRealValue(60);
            [sectionModel.cellModelArray addObject:cellModel];
            cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
                ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseTicketDateCellID];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = titleArr[i];
                NSDictionary *dateLabelDic = @{@"text":valueArr[i]};
                UILabel *dateLabel = [ZSHBaseUIControl createLabelWithParamDic:dateLabelDic];
                dateLabel.tag = 3;
                [cell.contentView addSubview:dateLabel];
                [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell).offset(kRealValue(100));
                    make.height.mas_equalTo(cell);
                    make.top.mas_equalTo(cell);
                    make.right.mas_equalTo(cell).offset(-kRealValue(50));
                }];
                
                return cell;
            };
            
            cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
                if (indexPath.row == 1) {//出发日期
                    self.bottomBlurPopView = [weakself createBottomBlurPopViewWith:ZSHFromAirplaneCalendarVCToBottomBlurPopView];
                    [kAppDelegate.window addSubview:self.bottomBlurPopView];
                }  else if (indexPath.row == 2) {//席别
                    NSArray *seatArr = @[@"不限",@"经济仓",@"头等／商务舱"];
                    NSDictionary *nextParamDic = @{@"type":@(WindowTogether),@"midTitle":@"席别选择",@"dataArr":seatArr};
                    weakself.pickView = [weakself createPickViewWithParamDic:nextParamDic];
                    [weakself.pickView show:WindowTogether];
                }
            };
        }
        
        cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(60);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:ZSHBaseTicketDateCellID];
            NSDictionary *childBtnDic = @{@"title":@"携带儿童",@"font":kPingFangRegular(12),@"withImage":@(YES),@"normalImage":@"airplane_press"};
            UIButton *childBtn = [ZSHBaseUIControl createBtnWithParamDic:childBtnDic];
            [cell.contentView addSubview:childBtn];
            [childBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell).offset(KLeftMargin);
                make.height.mas_equalTo(cell).offset(KLeftMargin);
                make.width.mas_equalTo(kRealValue(65));
                make.top.mas_equalTo(cell);
            }];
            
            [childBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(5)];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
        
    } else if (kFromClassTypeValue == ZSHFromHomeTrainVCToAirPlaneVC) {
        // 出发日期
        cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(60);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseTicketDateCellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"出发日期";
            NSDictionary *dateLabelDic = @{@"text":@"2017-9-25"};
            UILabel *dateLabel = [ZSHBaseUIControl createLabelWithParamDic:dateLabelDic];
            dateLabel.tag = 3;
            [cell.contentView addSubview:dateLabel];
            [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell).offset(kRealValue(100));
                make.height.mas_equalTo(cell);
                make.top.mas_equalTo(cell);
                make.right.mas_equalTo(cell).offset(-kRealValue(50));
            }];
            
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            if (indexPath.row == 1) {//出发日期
                self.bottomBlurPopView = [weakself createBottomBlurPopViewWith:ZSHFromAirplaneCalendarVCToBottomBlurPopView];
                [kAppDelegate.window addSubview:self.bottomBlurPopView];
            }
        };
        
        cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(60);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:ZSHBaseTicketDateCellID];
            NSDictionary *childBtnDic = @{@"title":@"学生票",@"font":kPingFangRegular(12),@"withImage":@(YES),@"normalImage":@"airplane_press"};
            UIButton *childBtn = [ZSHBaseUIControl createBtnWithParamDic:childBtnDic];
            [cell.contentView addSubview:childBtn];
            [childBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell).offset(KLeftMargin);
                make.height.mas_equalTo(cell);
                make.width.mas_equalTo(kRealValue(65));
                make.top.mas_equalTo(cell);
            }];
            
            [childBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(5)];
            
            NSDictionary *conBtnDic = @{@"title":@"只看高铁／动车",@"font":kPingFangRegular(12),@"withImage":@(YES),@"normalImage":@"airplane_press"};
            UIButton *conBtn = [ZSHBaseUIControl createBtnWithParamDic:conBtnDic];
            [cell.contentView addSubview:conBtn];
            [conBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell).offset(kRealValue(160));
                make.top.mas_equalTo(cell);
                make.height.mas_equalTo(cell);
                make.width.mas_equalTo(kRealValue(110));
            }];
            [conBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(5)];
            
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };

        
    }
    
    
    
   
    return sectionModel;
}

//搜索机票
- (void)searchTicketAction{
    
    switch ([self.paramDic[KFromClassType]integerValue]) {
        case ZSHHomeAirPlaneVCToAirPlaneVC:{
            NSDictionary *nextParamDic = @{KFromClassType:@(FromPlaneTicketVCToTitleContentVC)};
            ZSHTitleContentViewController *titleContentVC = [[ZSHTitleContentViewController alloc]initWithParamDic:nextParamDic];
            [self.navigationController pushViewController:titleContentVC animated:YES];
        }
            break;
        case ZSHFromHomeTrainVCToAirPlaneVC:{
            ZSHTrainSearchResultController *searchResultVC = [[ZSHTrainSearchResultController alloc]init];
            [self.navigationController pushViewController:searchResultVC animated:YES];
        }
            break;
        default:
            break;
    }
    

    
}

#pragma getter
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWith:(ZSHFromVCToBottomBlurPopView)fromClassType{
    NSDictionary *nextParamDic = @{KFromClassType:@(fromClassType)};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    bottomBlurPopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [bottomBlurPopView setBlurEnabled:NO];
    return bottomBlurPopView;
}

-(ZSHPickView *)createPickViewWithParamDic:(NSDictionary *)paramDic{
    ZSHPickView *pickView = [[ZSHPickView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) paramDic:paramDic];
    pickView.controller = self;
    return pickView;
}


@end
