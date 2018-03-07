//
//  ZSHCityViewController.m
//  RLJKApp
//
//  Created by zhaoweiwei on 2017/9/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCityViewController.h"
#import "ChineseString.h"
#import "ZSHCityView.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
#import "PYSearchViewController.h"

#define btnHeight               kRealValue(30)
#define ySpacing                kRealValue(10)
#define leftSpacing             kRealValue(15)
#define kSectionIndexWidth      kRealValue(20)

@interface ZSHCityViewController ()<UITableViewDelegate,UITableViewDataSource,DSectionIndexViewDataSource,DSectionIndexViewDelegate,UISearchBarDelegate, PYSearchViewControllerDelegate, PYSearchViewControllerDataSource>

@property (nonatomic, strong) NSMutableArray    *indexArray;
@property (nonatomic, strong) NSMutableArray    *letterResultArr;
@property (nonatomic, strong) NSTimer           *timer;
@property (nonatomic, assign) CGFloat           cellHeight;
@property (nonatomic, assign) NSInteger         row;
@property (nonatomic, strong) DSectionIndexView *sectionIndexView;
@property (nonatomic, strong) NSMutableArray    *sections;

@property (nonatomic, strong) NSMutableArray    *searchDataSource;

@end

@implementation ZSHCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createData];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [((RootNavigationController *)self.navigationController) setupTransparentStyle];
    [self.sectionIndexView reloadItemViews];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _sectionIndexView.frame = CGRectMake(CGRectGetWidth(self.tableView.frame) - kSectionIndexWidth, kRealValue(71), kSectionIndexWidth,KScreenHeight - kRealValue(80));
    _sectionIndexView.backgroundColor = KClearColor;
    [_sectionIndexView setBackgroundViewFrame];
}

- (void)createData{
    _searchDataSource = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:@""];
    NSArray *areaArr = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *cities = [NSMutableArray array];
    for (NSDictionary *dic in areaArr) {
        for (NSDictionary *city in dic[@"cities"]) {
            [cities addObject:city[@"city"]];
        }
    }

    self.indexArray = [ChineseString IndexArray:cities];
    self.letterResultArr = [ChineseString LetterSortArray:cities];
    self.sections = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];

}

- (void)createUI{
    
    UIButton *searchBtn = [ZSHBaseUIControl  createBtnWithParamDic:@{@"title":@"搜索",@"font":kPingFangRegular(14),@"normalImage":@"nav_home_search"} target:self action:@selector(searchAction)];
    searchBtn.frame = CGRectMake(0, 0, kRealValue(270), 30);
    searchBtn.backgroundColor = KZSHColor1A1A1A;
    searchBtn.layer.cornerRadius = 5.0;
    searchBtn.layer.masksToBounds = YES;
    [self.navigationItem setTitleView:searchBtn];


    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight - KNavigationBarHeight-10);
    self.tableView.sectionIndexBackgroundColor = KClearColor;
    self.tableView.sectionIndexColor = KWhiteColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = KClearColor;
    [self.view addSubview:self.tableView];
    
    _sectionIndexView = [[DSectionIndexView alloc] init];
    _sectionIndexView.backgroundColor = KClearColor;
    _sectionIndexView.dataSource = self;
    _sectionIndexView.delegate = self;
    _sectionIndexView.isShowCallout = YES;
    _sectionIndexView.calloutViewType = CalloutViewTypeForUserDefined;
    _sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
    _sectionIndexView.calloutMargin = 100.f;
    [self.view addSubview:self.sectionIndexView];
    

}

- (void)searchAction{
   
}


#pragma mark - PYSearchViewControllerDataSource
- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSHBaseCell *cell = [searchSuggestionView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.searchDataSource[indexPath.row];
    return cell;
}

- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section {
    return _searchDataSource.count;
}

#pragma - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController
         searchTextDidChange:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText {    
}

- (void)didClickCancel:(PYSearchViewController *)searchViewController {
    [searchViewController.navigationController popViewControllerAnimated:true];
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [self.indexArray count];
    return _letterResultArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
    return [_letterResultArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZSHBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    cell.textLabel.text = self.letterResultArr[indexPath.section][indexPath.row];
    return cell;
    
//    NSInteger rowCount = ceil([self.letterResultArr[indexPath.section] count]/3);
//    CGFloat rowHeight = (rowCount-1)*ySpacing + rowCount*btnHeight;
//    
//    NSDictionary *nextParamDic = @{@"titleArr":self.letterResultArr[indexPath.section]};
//    ZSHCityView *cityView = [[ZSHCityView alloc]initWithFrame:CGRectMake(0, kRealValue(20), KScreenWidth, rowHeight) paramDic:nextParamDic];
//    [cell.contentView addSubview:cityView];
//    
//    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kRealValue(20);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(20))];
    headView.backgroundColor = [UIColor colorWithHexString:@"141414"];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.text = [self.indexArray objectAtIndex:section];
    lab.textColor = [UIColor whiteColor];
    [headView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(KLeftMargin);
        make.centerY.mas_equalTo(headView);
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(headView);
    }];
    return headView;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    NSInteger rowCount = ceil([self.letterResultArr[indexPath.section] count]/3.0 );
//    CGFloat rowHeight = (rowCount-1)*ySpacing + rowCount*btnHeight + kRealValue(40);
//    RLog(@"高度%f%@%ld",rowHeight,self.letterResultArr[indexPath.section],rowCount);
//    return rowHeight;
//}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = KClearColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_saveCityBlock) {
        _saveCityBlock(_letterResultArr[indexPath.section][indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView{
    return self.sections.count;
}

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section{
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    itemView.titleLabel.text = [self.sections objectAtIndex:section];
    itemView.titleLabel.textColor = KZSHColor929292;
    itemView.titleLabel.font = kPingFangMedium(15);
    return itemView;
}

- (UIView *)sectionIndexView:(DSectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 80, 80);
    label.backgroundColor = KWhiteColor;
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:36];
    label.text = [self.sections objectAtIndex:section];
    label.textAlignment = NSTextAlignmentCenter;
    
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:3.0f];
    [label.layer setShadowColor:[UIColor blackColor].CGColor];
    [label.layer setShadowOpacity:0.8];
    [label.layer setShadowRadius:5.0];
    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    return label;
}

- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section{
    return [self.sections objectAtIndex:section];
}

- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section{
    NSString *str = self.sections[section];
    if (![self.indexArray containsObject:str]) {
        return;
    } else {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.indexArray indexOfObject:str]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
