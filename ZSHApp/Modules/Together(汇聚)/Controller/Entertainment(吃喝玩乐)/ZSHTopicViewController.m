//
//  ZSHTopicViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTopicViewController.h"

@interface ZSHTopicViewController ()<UISearchControllerDelegate,UISearchResultsUpdating>

@property (strong, nonatomic)  UISearchController *searchController;
@property (strong, nonatomic)  NSMutableArray  *dataList;
@property (strong, nonatomic)  NSMutableArray  *searchList;

@end

@implementation ZSHTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
    [self loadData];
}

- (void)loadData{
    _dataList = [NSMutableArray array];
    _searchList = [NSMutableArray array];
    self.dataList = [NSMutableArray arrayWithCapacity:100];
    
    //产生100个“数字+三个随机字母”
    for (NSInteger i=0; i<100; i++) {
        [self.dataList addObject:[NSString stringWithFormat:@"%ld%@",(long)i,[self shuffledAlphabet]]];
    }
    
    
    [self initViewModel];
}

//产生3个随机字母
- (NSString *)shuffledAlphabet {
    NSMutableArray * shuffledAlphabet = [NSMutableArray arrayWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]];
    
    NSString *strTest = [[NSString alloc]init];
    for (int i=0; i<3; i++) {
        int x = arc4random() % 25;
        strTest = [NSString stringWithFormat:@"%@%@",strTest,shuffledAlphabet[x]];
    }
    return strTest;
}

- (void)createUI{

    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater= self;
    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    _searchController.obscuresBackgroundDuringPresentation = NO;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    
//    self.navigationItem.titleView = self.searchView;
//    self.searchView.searchBar.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:@"ZSHBaseCell"];
    self.tableView.tableHeaderView = _searchController.searchBar;
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *realDataArr = nil;
    if (self.searchController.active) {
        realDataArr =  self.searchList;
    } else {
        realDataArr = self.dataList;
    }
    
    
    
    for (int i = 0; i < realDataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(50);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSHBaseCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageWithColor:[UIColor redColor]];
            if (self.searchController.active) {
                [cell.textLabel setText:self.searchList[indexPath.row]];
            } else {
                [cell.textLabel setText:self.dataList[indexPath.row]];
            }
            
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
           
        };
    }
    
    return sectionModel;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    searchController.searchBar.showsCancelButton = YES;
    for (id searchbuttons in [[searchController.searchBar subviews][0] subviews]) //只需在此处修改即可
        
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            // 修改文字颜色
            [cancelButton setTitle:@"返回"forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    
    
    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
