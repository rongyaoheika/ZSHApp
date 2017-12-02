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

#define btnHeight               kRealValue(30)
#define ySpacing                kRealValue(10)
#define leftSpacing             kRealValue(15)
#define kSectionIndexWidth      kRealValue(20)

@interface ZSHCityViewController ()<UITableViewDelegate,UITableViewDataSource,DSectionIndexViewDataSource,DSectionIndexViewDelegate,UISearchBarDelegate>

@property(nonatomic,strong) NSMutableArray    *indexArray;
@property(nonatomic,strong) NSMutableArray    *letterResultArr;
@property(nonatomic,strong) NSTimer           *timer;
@property(nonatomic,assign) CGFloat           cellHeight;
@property(nonatomic,assign) NSInteger         row;
@property (nonatomic,retain)DSectionIndexView *sectionIndexView;
@property (nonatomic,strong)NSMutableArray    *sections;

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
    NSArray *stringsToSort = [NSArray arrayWithObjects:
                              @"鞍山",@"安康",@"安阳",
                              @"安庆",@"安顺",@"澳门",
                              @"北京",@"白城",@"白山",
                              @"本溪",@"包头",@"巴彦卓尔",
                              @"保定",@"宝鸡",@"滨州",
                              @"巴音郭楞",@"博尔塔拉",@"白银",
                              @"蚌埠",@"亳州",@"毕节",
                              @"巴中",@"保山",@"百色",
                              @"重庆",@"长春",@"朝阳",
                              @"赤峰",@"承德",@"沧州",
                              @"长治",@"昌吉",@"常州",
                              @"滁州",@"池州",@"长沙",
                              @"郴州",@"常德",@"成都",
                              @"潮州",@"楚雄",@"崇左",
                              nil];
    self.indexArray = [ChineseString IndexArray:stringsToSort];
    self.letterResultArr = [ChineseString LetterSortArray:stringsToSort];
    self.sections = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];

}

- (void)createUI{
    self.navigationItem.titleView = self.searchView;
    self.searchView.searchBar.delegate = self;
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight+10, KScreenWidth, KScreenHeight - KNavigationBarHeight-10);
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

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSHBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSInteger rowCount = ceil([self.letterResultArr[indexPath.section] count]/3);
    CGFloat rowHeight = (rowCount-1)*ySpacing + rowCount*btnHeight;
    
    NSDictionary *nextParamDic = @{@"titleArr":self.letterResultArr[indexPath.section]};
    ZSHCityView *cityView = [[ZSHCityView alloc]initWithFrame:CGRectMake(0, kRealValue(20), KScreenWidth, rowHeight) paramDic:nextParamDic];
    [cell.contentView addSubview:cityView];
    
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = ceil([self.letterResultArr[indexPath.section] count]/3.0 );
    CGFloat rowHeight = (rowCount-1)*ySpacing + rowCount*btnHeight + kRealValue(40);
    RLog(@"高度%f%@%ld",rowHeight,self.letterResultArr[indexPath.section],rowCount);
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = KClearColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
