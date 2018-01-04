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
#import "ZSHLiveLogic.h"

@interface ZSHTopicViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) UISearchController                        *searchController;
@property (strong, nonatomic) NSArray<ZSHWeiboTopicModel *>             *dataList;
@property (strong, nonatomic) NSMutableArray<ZSHWeiboTopicModel *>      *searchList;
@property (copy,   nonatomic) NSString                                  *searhText;
@property (assign, nonatomic) BOOL                                      isSearchState;
@property (strong, nonatomic) ZSHLiveLogic                              *liveLogic;
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
    _liveLogic = [[ZSHLiveLogic alloc] init];
    
    [self requestData:@""];
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
        return self.searchList.count;
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
    if (_isSearchState) {
        if (kFromClassTypeValue == FromWeiboVCToTopicVC) {
            [cell updateCellWithModel:self.searchList[indexPath.row]];
        }
    } else {
        if (kFromClassTypeValue == FromWeiboVCToTopicVC) {
            [cell updateCellWithModel:self.dataList[indexPath.row]];
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectRow) {
        ZSHWeiboTopicModel *model = nil;
        if (_isSearchState) {
            model = _searchList[indexPath.row];
        } else {
            model = _dataList[indexPath.row];
        }
        NSString *topicID = model.TOPIC_ID;
        if (!topicID) {
            topicID = @"";
        }
        self.didSelectRow(model.TITLE, topicID);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self requestData:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length) {
        _isSearchState = true;
    } else {
        _isSearchState = false;
    }
    _searhText = searchText;
    //    if (self.searchList.count > 0) {
    //        [self.searchList removeAllObjects];
    //    }
    //
    //    // 开始搜索
    //    NSString *key = searchText.lowercaseString;
    //    NSMutableArray *tempArr = [NSMutableArray array];
    //    if (![key isEqualToString:@""] && ![key isEqual:[NSNull null]]) {
    //        [self.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            ZSHTopicModel * topicModel = self.dataList[idx];
    //            NSString * title = topicModel.title.lowercaseString;
    //            NSString * titlePinyin = topicModel.titlePinYin.lowercaseString;
    //            NSString * titleFirstLetter = topicModel.titleFirstLetter.lowercaseString;
    //            NSRange rang1 = [title rangeOfString:key];
    //            if (rang1.length > 0) {
    //                [tempArr addObject:topicModel];
    //            } else {
    //                if ([titleFirstLetter containsString:key]) {
    //                    [tempArr addObject:topicModel];
    //                } else {
    //                    if ([titleFirstLetter containsString:[key substringToIndex:1]]) {
    //                        if ([titlePinyin containsString:key]) {
    //                            [tempArr addObject:topicModel];
    //                        }
    //                    }
    //                }
    //            }
    //
    //        }];
    //
    //        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            if (![self.searchList containsObject:tempArr[idx]]) {
    //                [self.searchList addObject:tempArr[idx]];
    //            }
    //        }];
    //
    //        self.isSearchState = YES;
    //        if (!self.searchList.count) {
    //            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    //            ZSHTopicCell *cell = [self.tableView cellForRowAtIndexPath:index];
    //            cell.topLabel.text = searchText;
    //
    ////            UILabel * noResultLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,KScreenWidth,kRealValue(80))];
    ////            noResultLab.font = [UIFont systemFontOfSize:20];
    ////            noResultLab.textColor = [UIColor lightGrayColor];
    ////            noResultLab.text = searchText;
    ////            [self.tableView addSubview:noResultLab];
    //
    //        }
    //
    //    } else {
    //        self.isSearchState = NO;
    //    }
    //
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(NSString*)title {
    kWeakSelf(self);
    if (kFromClassTypeValue == FromWeiboVCToTopicVC) {
        [_liveLogic requestGetTopicListWithTitle:title success:^(id response) {
            if (_isSearchState) {
                weakself.searchList = [NSMutableArray arrayWithArray:response];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TITLE == %@", _searhText];
                NSArray *filteredArray = [response filteredArrayUsingPredicate:predicate];
                if (!filteredArray.count) {
                    ZSHWeiboTopicModel *model = [[ZSHWeiboTopicModel alloc] init];
                    model.TITLE = _searhText;
                    model.SHOWIMG = @"newTopic";
                    model.DESCRIPTION = @"新话题";
                    [weakself.searchList insertObject:model atIndex:0];
                }
            } else {
                weakself.dataList = response;
            }
            [weakself.tableView reloadData];
        }];
    }
}

@end
