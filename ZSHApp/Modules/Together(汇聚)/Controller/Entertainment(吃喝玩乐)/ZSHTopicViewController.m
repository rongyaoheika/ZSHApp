//
//  ZSHTopicViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTopicViewController.h"
#import "ZSHTopicCell.h"
#import "ZSHTopicModel.h"

@interface ZSHTopicViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic)  UISearchController *searchController;
@property (strong, nonatomic)  NSMutableArray  *dataList;
@property (strong, nonatomic)  NSMutableArray  *searchList;
@property (copy,   nonatomic)  NSString        *searhText;
@property (assign, nonatomic)  BOOL            isSearchState;
@end

@implementation ZSHTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
    [self loadData];
}

- (void)loadData{
    _searchList = [NSMutableArray array];
    _dataList = [NSMutableArray array];
    
   NSArray *dataArr = [[NSMutableArray alloc]initWithObjects:@"ganen",@"#新年倒计时#",@"#舍不得删掉的聊天记录#",@"#冻死宝宝了#",@"#保护员工#",@"MicroSoft",@"Oracle",@"凯迪拉克",@"甲骨文",@"MSUNSOFT",@"数据",@"中国",@"联想",@"格力",@"苹果电脑",@"Iphone6s",@"中关村",@"东方明珠",@"美莲广场",@"火车站",nil];

    for (int i = 0; i<dataArr.count; i++) {
        ZSHTopicModel *topicModel = [[ZSHTopicModel alloc]init];
        NSString * PinYin = [dataArr[i] transformToPinyin];
        NSString * FirstLetter = [dataArr[i] transformToPinyinFirstLetter];

        topicModel.title = dataArr[i];
        topicModel.titlePinYin = PinYin;
        topicModel.titleFirstLetter = FirstLetter;
        
        [self.dataList addObject:topicModel];
    }
}

- (void)createUI{
    
    self.navigationItem.titleView = self.searchView;
    self.searchView.searchBar.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ZSHTopicCell class] forCellReuseIdentifier:@"ZSHTopicCell"];
    self.tableView.tableHeaderView = _searchController.searchBar;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = KZSHColor1D1D1D;
    
}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isSearchState) {
        if (self.searchList.count > 0) {
            return self.searchList.count;
        } else {//无搜索结果
            return 1;
        }
    } else {
        return self.dataList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kRealValue(80);
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ZSHTopicCell";
    ZSHTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    ZSHTopicModel *topicModel = nil;
    if (_isSearchState) {
        if (self.searchList.count) {
            topicModel = self.searchList[indexPath.row];
            cell.topLabel.text = topicModel.title;
        } else {
           
        }
    
    } else {
        topicModel = self.dataList[indexPath.row];
        cell.topLabel.text = topicModel.title;
    }
    
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (self.searchList.count > 0) {
        [self.searchList removeAllObjects];
    }
    
    // 开始搜索
    NSString *key = searchText.lowercaseString;
    NSMutableArray *tempArr = [NSMutableArray array];
    if (![key isEqualToString:@""] && ![key isEqual:[NSNull null]]) {
        [self.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZSHTopicModel * topicModel = self.dataList[idx];
            NSString * title = topicModel.title.lowercaseString;
            NSString * titlePinyin = topicModel.titlePinYin.lowercaseString;
            NSString * titleFirstLetter = topicModel.titleFirstLetter.lowercaseString;
            NSRange rang1 = [title rangeOfString:key];
            if (rang1.length > 0) {
                [tempArr addObject:topicModel];
            } else {
                if ([titleFirstLetter containsString:key]) {
                    [tempArr addObject:topicModel];
                } else {
                    if ([titleFirstLetter containsString:[key substringToIndex:1]]) {
                        if ([titlePinyin containsString:key]) {
                            [tempArr addObject:topicModel];
                        }
                    }
                }
            }
            
        }];
        
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![self.searchList containsObject:tempArr[idx]]) {
                [self.searchList addObject:tempArr[idx]];
            }
        }];
        
        self.isSearchState = YES;
        if (!self.searchList.count) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            ZSHTopicCell *cell = [self.tableView cellForRowAtIndexPath:index];
            cell.topLabel.text = searchText;
            
//            UILabel * noResultLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,KScreenWidth,kRealValue(80))];
//            noResultLab.font = [UIFont systemFontOfSize:20];
//            noResultLab.textColor = [UIColor lightGrayColor];
//            noResultLab.text = searchText;
//            [self.tableView addSubview:noResultLab];
            
        }
        
    } else {
        self.isSearchState = NO;
    }
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZSHTopicCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.didSelectRow) {
        self.didSelectRow(cell.topLabel.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
