//
//  ZSHPersonalDetailViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPersonalDetailViewController.h"
#import "ZSHLiveLogic.h"
static NSString *PersonalDetailIdentifier = @"PersonalDetailIdentifier";

@interface ZSHPersonalDetailViewController ()

@property (nonatomic, strong) NSArray       *titleArr;
@property (nonatomic, strong) NSArray       *dataArr;
@property (nonatomic, strong) ZSHLiveLogic  *liveLogic;
@end

@implementation ZSHPersonalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadData];

}

- (void)loadData{
    kWeakSelf(self);
    _liveLogic = [[ZSHLiveLogic alloc]init];
    self.titleArr = @[@"昵称", @"性别", @"生日", @"签名", @"等级"];
    [_liveLogic requestLiveUserDownDataWithDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id response) {
        weakself.dataArr = @[response[@"NICKNAME"], response[@"SEX"],response[@"BIRTHDAY"], response[@"SIGNNAME"], @"1级"];
        [weakself initViewModel];
    }];
   
}

- (void)createUI{
    self.title = @"资料";
    
    [self.view addSubview:self.tableView];
    if (kFromClassTypeValue == FromPersonalVCToPersonalDetailVC) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    } else if (kFromClassTypeValue == FromTabbarToPersonalDetailVC) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }

    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:PersonalDetailIdentifier];
   
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    for (int i = 0; i<self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(35);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSHBaseCellID"];
            if (!cell) {
                cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZSHBaseCellID"];
                NSDictionary *leftLBDic = @{@"text":@""};
                UILabel *leftLB = [ZSHBaseUIControl createLabelWithParamDic:leftLBDic];
                leftLB.frame = CGRectMake(KLeftMargin, 0, kRealValue(80), kRealValue(35));
                leftLB.tag = 10;
                [cell.contentView addSubview:leftLB];
                
                NSDictionary *rightLBDic = @{@"text":self.dataArr[indexPath.row]};
                UILabel *rightLB = [ZSHBaseUIControl createLabelWithParamDic:rightLBDic];
                rightLB.frame = CGRectMake(kRealValue(100), 0, KScreenWidth*0.6, kRealValue(35));
                rightLB.tag = 20;
                [cell.contentView addSubview:rightLB];
            }
            
            UILabel *leftLB = (UILabel *)[cell.contentView viewWithTag:10];
            leftLB.text = self.titleArr[indexPath.row];
            
            UILabel *rightLB = (UILabel *)[cell.contentView viewWithTag:20];
            rightLB.text = self.dataArr[indexPath.row];

            return cell;
        };
    }
    
    return sectionModel;
}




@end
