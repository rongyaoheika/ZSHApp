//
//  GitHub: https://github.com/iphone5solo/PYSearch
//  Created by CoderKo1o.
//  Copyright © 2016 iphone5solo. All rights reserved.
//

#import "PYSearchViewController.h"
#import "ZSHRecommendView.h"
#import "ZSHLiveLogic.h"

#define PYSEARCH_MARGIN 10
#define PYRectangleTagMaxCol 3
#define PYSEARCH_COLORPolRandomColor self.colorPol[arc4random_uniform((uint32_t)self.colorPol.count)]

@interface PYSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

/**
 The header view of search view
 */
@property (nonatomic, weak) UIView *headerView;

/**
 The view of popular search
 */
@property (nonatomic, weak) UIView *hotSearchView;

/**
 The content view of popular search tags
 */
@property (nonatomic, weak) UIView *hotSearchTagsContentView;

/**
 The view of search history
 */
@property (nonatomic, weak) UIView *searchHistoryView;

/**
 The content view of search history tags.
 */
@property (nonatomic, weak) UIView *searchHistoryTagsContentView;

/**
 The records of search
 */
@property (nonatomic, strong) NSMutableArray *searchHistories;

/**
 Whether keyboard is showing.
 */
@property (nonatomic, assign) BOOL keyboardShowing;

/**
 The height of keyborad
 */
@property (nonatomic, assign) CGFloat keyboardHeight;


/**
 Whether did press suggestion cell
 */
@property (nonatomic, assign) BOOL didClickSuggestionCell;

/**
 The current orientation of device
 */
@property (nonatomic, assign) UIDeviceOrientation currentOrientation;

/**
 为您推荐
 */
@property (nonatomic, strong) ZSHRecommendView    *recommendView;

//是否为搜索界面
@property (nonatomic, assign) BOOL isSearch;

// search 数据源
@property (nonatomic, strong) NSArray *searchDataArr;

// search tableview
@property (nonatomic, strong) UITableView *searchTableView;


@end

@implementation PYSearchViewController

/*******************系统初始化方法********************/
- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.currentOrientation != [[UIDevice currentDevice] orientation]) { // orientation changed, reload layout
        self.hotSearches = self.hotSearches;
        self.searchHistories = self.searchHistories;
        self.currentOrientation = [[UIDevice currentDevice] orientation];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchView.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchView.searchBar resignFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder recommendArr:(NSArray *)recommendArr
{
    PYSearchViewController *searchVC = [[PYSearchViewController alloc] init];
    searchVC.hotSearches = hotSearches;
    searchVC.searchView.searchBar.placeholder = placeholder;
    searchVC.recommendArr = recommendArr;
    return searchVC;
}

+ (instancetype)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder recommendArr:(NSArray *)recommendArr didSearchBlock:(PYDidSearchBlock)block
{
    PYSearchViewController *searchVC = [self searchViewControllerWithHotSearches:hotSearches searchBarPlaceholder:placeholder recommendArr:recommendArr];
    searchVC.didSearchBlock = [block copy];
    return searchVC;
}
/******************************/

#pragma mark - Lazy
- (UIButton *)emptyButton
{
    if (!_emptyButton) {
        NSDictionary *emptyBtnDic = @{@"title":@"清空",@"font":kPingFangRegular(14),@"withImage":@(YES),@"normalImage":@"address_delete"};
        UIButton *emptyButton = [ZSHBaseUIControl createBtnWithParamDic:emptyBtnDic];
        [emptyButton addTarget:self action:@selector(emptySearchHistoryDidClick) forControlEvents:UIControlEventTouchUpInside];
        [emptyButton sizeToFit];
        emptyButton.zsh_width += PYSEARCH_MARGIN;
        emptyButton.zsh_height += PYSEARCH_MARGIN;
        emptyButton.zsh_centerY = self.searchHistoryHeader.zsh_centerY;
        emptyButton.zsh_x = self.searchHistoryView.zsh_width - emptyButton.zsh_width;
        emptyButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [emptyButton layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(5.0)];
        [self.searchHistoryView addSubview:emptyButton];
        _emptyButton = emptyButton;
    }
    return _emptyButton;
}

- (ZSHRecommendView *)recommendView{
    if (!_recommendView) {
        _recommendView = [[ZSHRecommendView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight*0.7)];
    }
    return _recommendView;
}

/**********搜索历史********************/
//搜索历史：背景view
- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        UIView *searchHistoryView = [[UIView alloc] init];
        searchHistoryView.zsh_x = self.hotSearchView.zsh_x;
        searchHistoryView.zsh_y = self.hotSearchView.zsh_y;
        searchHistoryView.zsh_width = self.headerView.zsh_width - searchHistoryView.zsh_x * 2;
        searchHistoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.headerView addSubview:searchHistoryView];
        _searchHistoryView = searchHistoryView;
    }
    return _searchHistoryView;
}

//搜索历史：头部标题
- (UILabel *)searchHistoryHeader
{
    if (!_searchHistoryHeader) {
        UILabel *titleLabel = [self setupTitleLabel:@"搜索历史"];
        [self.searchHistoryView addSubview:titleLabel];
        _searchHistoryHeader = titleLabel;
    }
    return _searchHistoryHeader;
}

//搜索历史：tag内容UI
- (UIView *)searchHistoryTagsContentView
{
    if (!_searchHistoryTagsContentView) {
        UIView *searchHistoryTagsContentView = [[UIView alloc] init];
        searchHistoryTagsContentView.zsh_width = self.searchHistoryView.zsh_width;
        searchHistoryTagsContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        searchHistoryTagsContentView.zsh_y = CGRectGetMaxY(self.hotSearchTagsContentView.frame) + PYSEARCH_MARGIN;
        [self.searchHistoryView addSubview:searchHistoryTagsContentView];
        _searchHistoryTagsContentView = searchHistoryTagsContentView;
    }
    return _searchHistoryTagsContentView;
}

//搜索历史：tag内容数据
- (NSMutableArray *)searchHistories
{
    if (!_searchHistories) {
        _searchHistories = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath]];
    }
    return _searchHistories;
}

/**********UI初始化********************/
- (void)setup
{
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight - KNavigationBarHeight - KBottomHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.titleView = self.searchView;
    self.searchView.searchBar.delegate = self;
    [self addNavigationItemWithTitles:@[@"取消"] isLeft:NO target:self action:@selector(cancelDidClick) tags:@[@(1)]];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    /**
     * Initialize settings
     */
    self.hotSearchStyle = PYHotSearchStyleARCBorderTag;
    self.searchHistoryStyle = PYSearchHistoryStyleARCBorderTag;
    self.searchResultShowMode = PYSearchResultShowModeDefault;
    self.searchHistoriesCachePath = PYSEARCH_SEARCH_HISTORY_CACHE_PATH;
    self.searchHistoriesCount = 20;
    self.showSearchHistory = YES;
    self.showHotSearch = YES;
    self.showSearchResultWhenSearchTextChanged = NO;
    self.showSearchResultWhenSearchBarRefocused = NO;
    self.removeSpaceOnSearchString = YES;
    
    //热门搜索
    UIView *headerView = [[UIView alloc] init];
    headerView.zsh_width = KScreenWidth;
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.headerView = headerView;
    
    UIView *hotSearchView = [[UIView alloc] init];
    hotSearchView.zsh_x = PYSEARCH_MARGIN * 1.5;
    hotSearchView.zsh_width = headerView.zsh_width - hotSearchView.zsh_x * 2;
    hotSearchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.hotSearchView = hotSearchView;
    
    UILabel *titleLabel = [self setupTitleLabel:@"热门搜索"];
    self.hotSearchHeader = titleLabel;
    [hotSearchView addSubview:titleLabel];
   
    UIView *hotSearchTagsContentView = [[UIView alloc] init];
    hotSearchTagsContentView.zsh_width = hotSearchView.zsh_width;
    hotSearchTagsContentView.zsh_y = CGRectGetMaxY(titleLabel.frame) + PYSEARCH_MARGIN;
    hotSearchTagsContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [hotSearchView addSubview:hotSearchTagsContentView];
    [headerView addSubview:hotSearchView];
    self.hotSearchTagsContentView = hotSearchTagsContentView;
    
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.zsh_width = KScreenWidth;
    self.tableView.tableFooterView = self.recommendView;
    
    self.hotSearches = nil;
    
    
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchTableView.backgroundColor = KBlackColor;
    _searchTableView.hidden = true;
    [self.view addSubview:_searchTableView];
}

#pragma action
//tableview 头部标题
- (UILabel *)setupTitleLabel:(NSString *)title
{
    NSDictionary *titleLBDic = @{@"text":title,@"font":kPingFangMedium(15)};
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLBDic];
    titleLabel.tag = 1;
    [titleLabel sizeToFit];
    titleLabel.zsh_x = 0;
    titleLabel.zsh_y = 0;
    return titleLabel;
}

//tags标题
- (UILabel *)labelWithTitle:(NSString *)title
{
    NSDictionary *labelDic = @{@"text":title,@"font":kPingFangLight(14),@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *label = [ZSHBaseUIControl createLabelWithParamDic:labelDic];
    label.userInteractionEnabled = YES;
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    [label sizeToFit];
    label.zsh_width += 20;
    label.zsh_height += 14;
    return label;
}

- (void)setupHotSearchNormalTags
{
    self.hotSearchTags = [self addAndLayoutTagsWithTagsContentView:self.hotSearchTagsContentView tagTexts:self.hotSearches];
    [self setHotSearchStyle:self.hotSearchStyle];
}

- (void)setupSearchHistoryTags
{
    self.tableView.tableFooterView = self.showRecommendView ? self.recommendView:nil;
    self.searchHistoryTagsContentView.zsh_y = PYSEARCH_MARGIN;
    self.emptyButton.zsh_y = self.searchHistoryHeader.zsh_y - PYSEARCH_MARGIN * 0.5;
    self.searchHistoryTagsContentView.zsh_y = CGRectGetMaxY(self.emptyButton.frame) + PYSEARCH_MARGIN;
    self.searchHistoryTags = [self addAndLayoutTagsWithTagsContentView:self.searchHistoryTagsContentView tagTexts:[self.searchHistories copy]];
}

- (NSArray *)addAndLayoutTagsWithTagsContentView:(UIView *)contentView tagTexts:(NSArray<NSString *> *)tagTexts;
{
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < tagTexts.count; i++) {
        UILabel *label = [self labelWithTitle:tagTexts[i]];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [contentView addSubview:label];
        [tagsM addObject:label];
    }
    
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    
    for (int i = 0; i < contentView.subviews.count; i++) {
        UILabel *subView = contentView.subviews[i];
        // When the number of search words is too large, the width is width of the contentView
        if (subView.zsh_width > contentView.zsh_width) subView.zsh_width = contentView.zsh_width;
        if (currentX + subView.zsh_width + PYSEARCH_MARGIN * countRow > contentView.zsh_width) {
            subView.zsh_x = 0;
            subView.zsh_y = (currentY += subView.zsh_height) + PYSEARCH_MARGIN * ++countCol;
            currentX = subView.zsh_width;
            countRow = 1;
        } else {
            subView.zsh_x = (currentX += subView.zsh_width) - subView.zsh_width + PYSEARCH_MARGIN * countRow;
            subView.zsh_y = currentY + PYSEARCH_MARGIN * countCol;
            countRow ++;
        }
    }
    
    contentView.zsh_height = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    if (self.hotSearchTagsContentView == contentView) { // popular search tag
        self.hotSearchView.zsh_height = CGRectGetMaxY(contentView.frame) + PYSEARCH_MARGIN * 2;
    } else if (self.searchHistoryTagsContentView == contentView) { // search history tag
        self.searchHistoryView.zsh_height = CGRectGetMaxY(contentView.frame) + PYSEARCH_MARGIN * 2;
    }
    
    [self layoutForDemand];
    self.tableView.tableHeaderView.zsh_height = self.headerView.zsh_height = MAX(CGRectGetMaxY(self.hotSearchView.frame), CGRectGetMaxY(self.searchHistoryView.frame));
    self.tableView.tableHeaderView.hidden = NO;
    
    // Note：When the operating system for the iOS 9.x series tableHeaderView height settings are invalid, you need to reset the tableHeaderView
    [self.tableView setTableHeaderView:self.tableView.tableHeaderView];
    return [tagsM copy];
}

- (void)layoutForDemand {
    if (NO == self.swapHotSeachWithSearchHistory) {
        self.hotSearchView.zsh_y = PYSEARCH_MARGIN * 2;
        self.searchHistoryView.zsh_y = self.hotSearches.count > 0 && self.showHotSearch ? CGRectGetMaxY(self.hotSearchView.frame) : PYSEARCH_MARGIN * 1.5;
    } else { // swap popular search whith search history
        self.searchHistoryView.zsh_y = PYSEARCH_MARGIN * 1.5;
        self.hotSearchView.zsh_y = self.searchHistories.count > 0 && self.showSearchHistory ? CGRectGetMaxY(self.searchHistoryView.frame) : PYSEARCH_MARGIN * 2;
    }
}

#pragma mark - setter
- (void)setSwapHotSeachWithSearchHistory:(BOOL)swapHotSeachWithSearchHistory
{
    _swapHotSeachWithSearchHistory = swapHotSeachWithSearchHistory;
    
    self.hotSearches = self.hotSearches;
    self.searchHistories = self.searchHistories;
}

- (void)setHotSearchTitle:(NSString *)hotSearchTitle
{
    _hotSearchTitle = [hotSearchTitle copy];
    
    self.hotSearchHeader.text = _hotSearchTitle;
}

- (void)setSearchHistoryTitle:(NSString *)searchHistoryTitle
{
    _searchHistoryTitle = [searchHistoryTitle copy];
    
    if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
        [self.tableView reloadData];
    } else {
        self.searchHistoryHeader.text = _searchHistoryTitle;
    }
}

- (void)setShowSearchResultWhenSearchTextChanged:(BOOL)showSearchResultWhenSearchTextChanged
{
    _showSearchResultWhenSearchTextChanged = showSearchResultWhenSearchTextChanged;
}

- (void)setShowHotSearch:(BOOL)showHotSearch
{
    _showHotSearch = showHotSearch;
    
    [self setHotSearches:self.hotSearches];
    [self setSearchHistoryStyle:self.searchHistoryStyle];
}

- (void)setShowSearchHistory:(BOOL)showSearchHistory
{
    _showSearchHistory = showSearchHistory;
    
    [self setHotSearches:self.hotSearches];
    [self setSearchHistoryStyle:self.searchHistoryStyle];
}

- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath
{
    _searchHistoriesCachePath = [searchHistoriesCachePath copy];
    
    self.searchHistories = nil;
    if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
        [self.tableView reloadData];
    } else {
        [self setSearchHistoryStyle:self.searchHistoryStyle];
    }
}

- (void)setHotSearchTags:(NSArray<UILabel *> *)hotSearchTags
{
    // popular search tagLabel's tag is 1, search history tagLabel's tag is 0.
    for (UILabel *tagLabel in hotSearchTags) {
        tagLabel.tag = 1;
    }
    _hotSearchTags = hotSearchTags;
}

- (void)setHotSearches:(NSArray *)hotSearches
{
    _hotSearches = hotSearches;
    if (hotSearches.count == 0 || !self.showHotSearch) {
        self.hotSearchHeader.hidden = YES;
        self.hotSearchTagsContentView.hidden = YES;
        if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
            UIView *tableHeaderView = self.tableView.tableHeaderView;
            tableHeaderView.zsh_height = PYSEARCH_MARGIN * 1.5;
            [self.tableView setTableHeaderView:tableHeaderView];
        }
        return;
    };
    
    self.tableView.tableHeaderView.hidden = NO;
    self.hotSearchHeader.hidden = NO;
    self.hotSearchTagsContentView.hidden = NO;
    [self setupHotSearchNormalTags];
    [self setSearchHistoryStyle:self.searchHistoryStyle];
}

- (void)setSearchHistoryStyle:(PYSearchHistoryStyle)searchHistoryStyle
{
    _searchHistoryStyle = searchHistoryStyle;
    
    if (!self.searchHistories.count || !self.showSearchHistory || UISearchBarStyleDefault == searchHistoryStyle) {
        self.searchHistoryHeader.hidden = YES;
        self.searchHistoryTagsContentView.hidden = YES;
        self.searchHistoryView.hidden = YES;
        self.emptyButton.hidden = YES;
        return;
    };
    
    self.searchHistoryHeader.hidden = NO;
    self.searchHistoryTagsContentView.hidden = NO;
    self.searchHistoryView.hidden = NO;
    self.emptyButton.hidden = NO;
    [self setupSearchHistoryTags];
    for (UILabel *tag in self.searchHistoryTags) {
        tag.backgroundColor = [UIColor clearColor];
        tag.layer.borderColor = KZSHColor929292.CGColor;
        tag.layer.borderWidth = 0.3;
        tag.layer.cornerRadius = tag.zsh_height * 0.3;
    }
}

- (void)setHotSearchStyle:(PYHotSearchStyle)hotSearchStyle
{
    _hotSearchStyle = hotSearchStyle;
    //PYHotSearchStyleARCBorderTag
    for (UILabel *tag in self.hotSearchTags) {
        tag.backgroundColor = [UIColor clearColor];
        tag.layer.borderColor = KZSHColor929292.CGColor;
        tag.layer.borderWidth = 0.5;
        tag.layer.cornerRadius = tag.zsh_height * 0.3;
    }
}

- (void)setRecommendArr:(NSArray *)recommendArr{
    _recommendArr = recommendArr;
    [self.recommendView updateViewWithParamDic:@{@"imageArr":_recommendArr}];
}

- (void)cancelDidClick
{
    [self.searchView.searchBar resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(didClickCancel:)]) {
        [self.delegate didClickCancel:self];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)keyboardDidShow:(NSNotification *)noti
{
    NSDictionary *info = noti.userInfo;
    self.keyboardHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardShowing = YES;
}


- (void)emptySearchHistoryDidClick
{
    [self.searchHistories removeAllObjects];
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    self.searchHistoryStyle = self.searchHistoryStyle;
    if (YES == self.swapHotSeachWithSearchHistory) {
        self.hotSearches = self.hotSearches;
    }
    
     [self.tableView reloadData];
}

- (void)tagDidCLick:(UITapGestureRecognizer *)gr
{
    UILabel *label = (UILabel *)gr.view;
    
    self.searchView.searchBar.text = label.text;
    // popular search tagLabel's tag is 1, search history tagLabel's tag is 0.
    if (1 == label.tag) {
        if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectHotSearchAtIndex:searchText:)]) {
            [self.delegate searchViewController:self didSelectHotSearchAtIndex:[self.hotSearchTags indexOfObject:label] searchText:label.text];
            [self saveSearchCacheAndRefreshView];
        } else {
            [self searchBarSearchButtonClicked:self.searchView.searchBar];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchHistoryAtIndex:searchText:)]) {
            [self.delegate searchViewController:self didSelectSearchHistoryAtIndex:[self.searchHistoryTags indexOfObject:label] searchText:label.text];
            [self saveSearchCacheAndRefreshView];
        } else {
            [self searchBarSearchButtonClicked:self.searchView.searchBar];
        }
    }
}

- (void)saveSearchCacheAndRefreshView
{
    UISearchBar *searchBar = self.searchView.searchBar;
    [searchBar resignFirstResponder];
    NSString *searchText = searchBar.text;
    if (self.removeSpaceOnSearchString) { // remove sapce on search string
       searchText = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if (self.showSearchHistory && searchText.length > 0) {
        [self.searchHistories removeObject:searchText];
        [self.searchHistories insertObject:searchText atIndex:0];
        
        if (self.searchHistories.count > self.searchHistoriesCount) {
            [self.searchHistories removeLastObject];
        }
        [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
        
        if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
            [self.tableView reloadData];
        } else {
            self.searchHistoryStyle = self.searchHistoryStyle;
        }
    }
    
    [self handleSearchResultShow];
}

- (void)handleSearchResultShow
{
    if (_isSearch) {
        _searchTableView.hidden = false;
        [_searchTableView reloadData];
    } else {
        _searchTableView.hidden = true;
    }
    
    switch (self.searchResultShowMode) {
        case PYSearchResultShowModePush:
            self.searchResultController.view.hidden = NO;
            [self.navigationController pushViewController:self.searchResultController animated:YES];
            break;
        case PYSearchResultShowModeEmbed:
            if (self.searchResultController) {
                [self.view addSubview:self.searchResultController.view];
                [self addChildViewController:self.searchResultController];
                self.searchResultController.view.hidden = NO;
                self.searchResultController.view.zsh_y = NO == self.navigationController.navigationBar.translucent ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
                self.searchResultController.view.zsh_height = self.view.zsh_height - self.searchResultController.view.zsh_y;
            } else {
            }
            break;
        case PYSearchResultShowModeCustom:
            
            break;
        default:
            break;
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSearchWithSearchBar:searchText:)]) {
        [self.delegate searchViewController:self didSearchWithSearchBar:searchBar searchText:searchBar.text];
        [self saveSearchCacheAndRefreshView];
        return;
    }
    if (self.didSearchBlock) self.didSearchBlock(self, searchBar, searchBar.text);
    [self saveSearchCacheAndRefreshView];
    [self requestData:searchBar.text];
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _isSearch = 0 != searchText.length;
    
    _searchDataArr = nil;
    if (PYSearchResultShowModeEmbed == self.searchResultShowMode && self.showSearchResultWhenSearchTextChanged) {
        [self handleSearchResultShow];
        self.searchResultController.view.hidden = 0 == searchText.length;
    } else if (self.searchResultController) {
        self.searchResultController.view.hidden = YES;
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
 
    if (PYSearchResultShowModeEmbed == self.searchResultShowMode) {
        self.searchResultController.view.hidden = 0 == searchBar.text.length || !self.showSearchResultWhenSearchBarRefocused;
    }
    _isSearch = 0 != searchBar.text.length;
    return YES;
}

- (void)closeDidClick:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    [self.searchHistories removeObject:cell.textLabel.text];
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    self.tableView.tableFooterView.hidden = 0 == self.searchHistories.count || !self.showSearchHistory;
    if (tableView == _searchTableView) {
        return _searchDataArr.count;
    } else {
        self.tableView.tableFooterView.hidden = NO;
        return self.showSearchHistory && PYSearchHistoryStyleCell == self.searchHistoryStyle ? self.searchHistories.count : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchTableView) {
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PYSearchSuggestCellID"];
        if (!cell) {
            cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PYSearchSuggestCellID"];
        }
        cell.textLabel.text = _searchDataArr[indexPath.row][@"NICKNAME"];
        return cell;
    } else {
        static NSString *cellID = @"PYSearchHistoryCellID";
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            UIButton *closetButton = [[UIButton alloc] init];
            closetButton.zsh_size = CGSizeMake(cell.zsh_height, cell.zsh_height);
            [closetButton setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
            UIImageView *closeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_close"]];
            [closetButton addTarget:self action:@selector(closeDidClick:) forControlEvents:UIControlEventTouchUpInside];
            closeView.contentMode = UIViewContentModeCenter;
            cell.accessoryView = closetButton;
            UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell-content-line"]];
            line.zsh_height = 0.5;
            line.alpha = 0.7;
            line.zsh_x = PYSEARCH_MARGIN;
            line.zsh_y = 43;
            line.zsh_width = tableView.zsh_width;
            line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [cell.contentView addSubview:line];
        }
        
        cell.imageView.image = [UIImage imageNamed:@"search_history"];
        cell.textLabel.text = self.searchHistories[indexPath.row];
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.showSearchHistory && self.searchHistories.count && PYSearchHistoryStyleCell == self.searchHistoryStyle ? (self.searchHistoryTitle.length ? self.searchHistoryTitle : @"搜索历史") : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.searchHistories.count && self.showSearchHistory && PYSearchHistoryStyleCell == self.searchHistoryStyle ? 25 : 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSHBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchView.searchBar.text = cell.textLabel.text;
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchHistoryAtIndex:searchText:)]) {
        [self.delegate searchViewController:self didSelectSearchHistoryAtIndex:indexPath.row searchText:cell.textLabel.text];
        [self saveSearchCacheAndRefreshView];
    } else {
        [self searchBarSearchButtonClicked:self.searchView.searchBar];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.keyboardShowing) {
        // Adjust the content inset of suggestion view
        [self.searchView.searchBar resignFirstResponder];
    }
}

- (void)requestData:(NSString *)searchText {
    kWeakSelf(self);
    ZSHLiveLogic *liveLogic = [[ZSHLiveLogic alloc] init];
    [liveLogic requestLiveSearhWithDic:@{@"NICKNAME":searchText} success:^(id response) {
        weakself.searchDataArr = response[@"pd"];
        if(weakself.searchDataArr.count)
            [weakself.searchTableView reloadData];
    }];
}


@end
