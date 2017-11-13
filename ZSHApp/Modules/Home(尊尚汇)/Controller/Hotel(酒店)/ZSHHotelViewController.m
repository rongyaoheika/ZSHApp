//
//  ZSHHotelViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelViewController.h"
#import "ZSHHotelCell.h"
#import "ZSHHotelDetailViewController.h"
#import "ZSHHotelDetailModel.h"

@interface ZSHHotelViewController ()<UISearchBarDelegate>

@property (nonatomic, strong)NSMutableArray           *dataArr;

@end

static NSString *ZSHHotelCellID = @"ZSHHotelCell";

@implementation ZSHHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    NSArray *baseDataArr = @[
                             @{@"imageName":@"hotel_image",@"title":@"如家-北京霍营地铁站店",@"address":@"昌平区回龙观镇科星西路47号",@"price":@"499",@"distance":@"23",@"comment":@"120",@"detailImageName":@"hotel_detail_big",@"hotelName":@"三亚大中华希尔顿酒店1"},
                             
                             @{@"imageName":@"hotel_image",@"title":@"如家-北京霍营地铁站店",@"address":@"昌平区回龙观镇科星西路48号",@"price":@"599",@"distance":@"55",@"comment":@"20",@"detailImageName":@"hotel_detail_big",@"hotelName":@"三亚大中华希尔顿酒店1"},
                             
                             @{@"imageName":@"hotel_image",@"title":@"如家-北京霍营地铁站店",@"address":@"昌平区回龙观镇科星西路49号",@"price":@"699",@"distance":@"63",@"comment":@"14",@"detailImageName":@"hotel_detail_big",@"hotelName":@"三亚大中华希尔顿酒店1"},
                             
                             @{@"imageName":@"hotel_image",@"title":@"如家-北京霍营地铁站店",@"address":@"昌平区回龙观镇科星西路50号",@"price":@"799",@"distance":@"90",@"comment":@"42",@"detailImageName":@"hotel_detail_big",@"hotelName":@"三亚大中华希尔顿酒店1"},
                             ];
    self.dataArr = [ZSHHotelDetailModel mj_objectArrayWithKeyValuesArray:baseDataArr];
     [self initViewModel];
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHHotelCell class] forCellReuseIdentifier:ZSHHotelCellID];
    
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(110);
        kWeakSelf(cellModel)
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHotelCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelCellID forIndexPath:indexPath];
            if (i==3) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
            ZSHHotelDetailModel *hotelModel = self.dataArr[indexPath.row];
            [cell updateCellWithModel:hotelModel];
            weakcellModel.height = hotelModel.cellHeight;
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
             ZSHHotelDetailModel *hotelModel = self.dataArr[indexPath.row];
            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromHotelVCToHotelDetailVC),@"model":hotelModel};
            ZSHHotelDetailViewController *hotelDetailVC = [[ZSHHotelDetailViewController alloc]initWithParamDic:nextParamDic];
            [weakself.navigationController pushViewController:hotelDetailVC animated:YES];
        };
    }
    
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
