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
#import "ZSHTrainModel.h"


@interface ZSHAirPlaneViewController ()

@property (nonatomic, strong) ZSHBottomBlurPopView      *bottomBlurPopView;
@property (nonatomic, strong) ZSHPickView               *pickView;
@property (nonatomic, strong) ZSHTrainModel             *trainModel;
@property (nonatomic, copy)   NSString                  *seatType;

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
    _trainModel = [[ZSHTrainModel alloc] init];
    _trainModel.from = @"北京";
    _trainModel.to = @"上海";
    _trainModel.date = @"2017-9-25";
    _trainModel.tt = @"D";
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
//    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseTicketDateCellID];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"开始搜索" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(searchTicketAction) forControlEvents:UIControlEventTouchUpInside];
 
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
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
        ticketView.saveBlock = ^(NSString *from, NSString *to) {
            weakself.trainModel.from = from;
            weakself.trainModel.to = to;
        };
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
        NSString *seatStr = _seatType?_seatType:@"经济舱";
        NSArray *valueArr = @[@"2017-9-25",seatStr];
        for (int i = 0; i<2; i++) {
            cellModel = [[ZSHBaseTableViewCellModel alloc] init];
            cellModel.height = kRealValue(60);
            [sectionModel.cellModelArray addObject:cellModel];
            cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
                ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AirHead"];
                if (!cell) {
                    cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"AirHead"];
                    UILabel *dateLabel = [ZSHBaseUIControl createLabelWithParamDic:@{}];
                    dateLabel.tag = 3;
                    [cell.contentView addSubview:dateLabel];
                    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell).offset(kRealValue(100));
                        make.height.mas_equalTo(cell);
                        make.top.mas_equalTo(cell);
                        make.right.mas_equalTo(cell).offset(-kRealValue(50));
                    }];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = titleArr[i];
                UILabel *label = [cell.contentView viewWithTag:3];
                label.text = valueArr[i];
                
                return cell;
            };
            
            cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
                if (indexPath.row == 1) {//出发日期
                    self.bottomBlurPopView = [weakself createBottomBlurPopViewWith:ZSHFromTrainCalendarVCToBottomBlurPopView];
                    weakself.bottomBlurPopView.confirmOrderBlock = ^(NSDictionary *dic) {
                        weakself.trainModel.date = dic[@"trainDate"];
                        [weakself initViewModel];
                    };
                    [kAppDelegate.window addSubview:self.bottomBlurPopView];
                }  else if (indexPath.row == 2) {//席别
                    NSArray *seatArr = @[@"不限",@"经济仓",@"头等／商务舱"];
                    NSDictionary *nextParamDic = @{@"type":@(WindowTogether),@"midTitle":@"席别选择",@"dataArr":seatArr};
                    weakself.pickView = [weakself createPickViewWithParamDic:nextParamDic];
                    [weakself.pickView show:WindowTogether];
                    [weakself.pickView setSaveChangeBlock:^(NSString *str, NSInteger tag, NSDictionary *moreDic) {
                        _seatType = str;
                        [weakself initViewModel];
                    }];
                }
            };
        }
        
        cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(60);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"child"];
            if (!cell) {
                cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"child"];
                NSDictionary *childBtnDic = @{@"title":@"携带儿童",@"font":kPingFangRegular(12),@"normalImage":@"airplane_normal",@"selectedImage":@"airplane_press"};
                UIButton *childBtn = [ZSHBaseUIControl  createBtnWithParamDic:childBtnDic target:self action:@selector(ticketBtnAction:)];
                [cell.contentView addSubview:childBtn];
                [childBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell).offset(KLeftMargin);
                    make.height.mas_equalTo(cell).offset(KLeftMargin);
                    make.width.mas_equalTo(kRealValue(65));
                    make.top.mas_equalTo(cell);
                }];
                [childBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(5)];
                childBtn.tag = 1824;
            }
            
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
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trainDate"];
            if (!cell) {
                cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"trainDate"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                NSDictionary *dateLabelDic = @{@"text":dateString};
                UILabel *dateLabel = [ZSHBaseUIControl createLabelWithParamDic:@{}];
                dateLabel.tag = 8;
                [cell.contentView addSubview:dateLabel];
                [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell).offset(kRealValue(100));
                    make.height.mas_equalTo(cell);
                    make.top.mas_equalTo(cell);
                    make.right.mas_equalTo(cell).offset(-kRealValue(50));
                }];
            }

            cell.textLabel.text = @"出发日期";
            NSString *dateString = @"";
            if (weakself.trainModel.date.length) {
                dateString = weakself.trainModel.date;
            } else {
                dateString = @"2017-9-25";
            }
            UILabel *label = [cell.contentView viewWithTag:8];
            label.text = dateString;
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            if (indexPath.row == 1) {//出发日期
                self.bottomBlurPopView = [weakself createBottomBlurPopViewWith:ZSHFromTrainCalendarVCToBottomBlurPopView];
                weakself.bottomBlurPopView.confirmOrderBlock = ^(NSDictionary *dic) {
                    weakself.trainModel.date = dic[@"trainDate"];
                    [weakself initViewModel];
                };
                [kAppDelegate.window addSubview:self.bottomBlurPopView];
            }
        };
        
        cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(60);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSHStudent"];
            if (!cell) {
                cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZSHStudent"];
                
                NSDictionary *childBtnDic = @{@"title":@"学生票",@"font":kPingFangRegular(12),@"normalImage":@"airplane_normal", @"selectedImage":@"airplane_press"};
                UIButton *childBtn = [ZSHBaseUIControl  createBtnWithParamDic:childBtnDic target:self action:@selector(ticketBtnAction:)];
                [cell.contentView addSubview:childBtn];
                [childBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell).offset(KLeftMargin);
                    make.height.mas_equalTo(cell);
                    make.width.mas_equalTo(kRealValue(65));
                    make.top.mas_equalTo(cell);
                }];
                
                [childBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(5)];
                
                NSDictionary *conBtnDic = @{@"title":@"只看高铁／动车",@"font":kPingFangRegular(12),@"normalImage":@"airplane_normal", @"selectedImage":@"airplane_press"};
                UIButton *conBtn = [ZSHBaseUIControl  createBtnWithParamDic:conBtnDic target:self action:@selector(ticketBtnAction:)];
                [cell.contentView addSubview:conBtn];
                [conBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell).offset(kRealValue(160));
                    make.top.mas_equalTo(cell);
                    make.height.mas_equalTo(cell);
                    make.width.mas_equalTo(kRealValue(110));
                }];
                [conBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(5)];
            }
            
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    return sectionModel;
}

- (void)ticketBtnAction:(UIButton *)ticketBtn{
    ticketBtn.selected = !ticketBtn.selected;
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
            ZSHTrainSearchResultController *searchResultVC = [[ZSHTrainSearchResultController alloc]initWithParamDic:@{@"trainModel":_trainModel}];
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
