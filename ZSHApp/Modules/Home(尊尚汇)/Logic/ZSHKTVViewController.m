//
//  ZSHKTVViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHKTVViewController.h"
#import "ZSHKTVDetailViewController.h"
#import "ZSHKTVLogic.h"
#import "ZSHHotelCell.h"

@interface ZSHKTVViewController ()

@property (nonatomic, strong) ZSHKTVLogic  *KTVLogic;
@property (nonatomic, strong) NSArray      *KTVArr;
@property (nonatomic, strong) NSArray      *KTVModelArr;

@end

static NSString *ZSHHotelCellID = @"ZSHHotelCell";
@implementation ZSHKTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateListData:) name:KUpdateDataWithSort object:nil];
    [self createUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_KTVArr) {
         [self requestKTVListData];
    }
   
}


- (void)loadData{
    
    [self requestKTVListData];
    [self initViewModel];
}

- (void)requestKTVListData{
    kWeakSelf(self);
    _KTVLogic = [[ZSHKTVLogic alloc]init];
    [_KTVLogic loadKTVListDataWithParamDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue}];
    _KTVLogic.requestDataCompleted = ^(NSDictionary *paramDic){
        weakself.KTVModelArr = paramDic[@"KTVModelArr"];
        weakself.KTVArr = paramDic[@"KTVArr"];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        [weakself initViewModel];
    };
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
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < _KTVArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(110);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHotelCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelCellID forIndexPath:indexPath];
            if (i==_KTVArr.count-1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
            cell.shopType = ZSHKTVShopType;
            NSDictionary *paramDic = _KTVArr[indexPath.row];
            [cell updateCellWithParamDic:paramDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
//            ZSHKTVModel *KTVModel = _KTVModelArr[indexPath.row];
            NSDictionary *paramDic = _KTVArr[indexPath.row];
            NSDictionary *nextParamDic = @{@"shopId":paramDic[@"SORTKTV_ID"]};
            ZSHKTVDetailViewController *KTVDetailVC = [[ZSHKTVDetailViewController alloc]initWithParamDic:nextParamDic];
            [weakself.navigationController pushViewController:KTVDetailVC animated:YES];
        };
    }
    
    return sectionModel;
}

- (void)updateListData:(NSNotification *)notification{
    kWeakSelf(self);
    
    ZSHToTitleContentVC type = [notification.object[KFromClassType]integerValue];
    if (type != FromKTVVCToTitleContentVC) {
        return;
    }
    
    //类型
    NSString *midTitle = notification.object[@"midTitle"];
    //行数
    NSInteger row = [notification.object[@"row"] integerValue];
    //行标题
    NSString *rowTitle = notification.object[@"rowTitle"];
    
    NSDictionary *paramDic = nil;
    NSArray *paramArr = nil;
    if ([midTitle containsString:@"排序"]) {
        //0:推荐  1：距离由近到远  2：评分由高到低 3：价格由高到低 4：价格由低到高
        paramArr = @[@{},@{},
                     @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"COLUMN":@"KTVEVALUATE",@"SEQUENCE":@"DESC",@"BRAND":@"",@"STYLE":@""}, @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"COLUMN":@"KTVPRICE",@"SEQUENCE":@"DESC",@"BRAND":@"",@"STYLE":@""}, @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"COLUMN":@"KTVPRICE",@"SEQUENCE":@"ASC",@"BRAND":@"",@"STYLE":@""}];
        paramDic = paramArr[row];
        
    } else if ([midTitle containsString:@"品牌"]){
        paramDic =  @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"COLUMN":@"",@"SEQUENCE":@"",@"BRAND":rowTitle,@"STYLE":@""};
        
    } else if ([midTitle containsString:@"筛选"]){
        paramDic =  @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"COLUMN":@"",@"SEQUENCE":@"",@"BRAND":@"",@"STYLE":rowTitle};
    }
    
    [_KTVLogic loadKTVSortWithParamDic:paramDic success:^(id responseObject) {
        RLog(@"排序后的数据==%@",responseObject);
        _KTVArr = responseObject;
        [weakself initViewModel];
    } fail:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
