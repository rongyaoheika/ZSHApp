//
//  GitHub: https://github.com/iphone5solo/PYSearch
//  Created by CoderKo1o.
//  Copyright © 2016 iphone5solo. All rights reserved.
//

#import "PYSearchViewController.h"
#import "ZSHRecommendView.h"

#define PYSEARCH_MARGIN 10
#define PYRectangleTagMaxCol 3
#define PYSEARCH_COLORPolRandomColor self.colorPol[arc4random_uniform((uint32_t)self.colorPol.count)]

@interface PYSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>//PYSearchSuggestionViewDataSource

/**
 The header view of search view
 */
@property (nonatomic, weak) UIView *headerView;

/**
 The view of popular search
 */
@property (nonatomic, weak) UIView *hotSearchView;

/**
 The view of search history
 */
@property (nonatomic, weak) UIView *searchHistoryView;

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
 The search suggestion view contoller
 */
@property (nonatomic, weak) PYSearchSuggestionViewController *searchSuggestionVC;

/**
 The content view of popular search tags
 */
@property (nonatomic, weak) UIView *hotSearchTagsContentView;

/**
 The tags of rank
 */
@property (nonatomic, copy) NSArray<UILabel *> *rankTags;

/**
 The text labels of rank
 */
@property (nonatomic, copy) NSArray<UILabel *> *rankTextLabels;

/**
 The view of rank which contain tag and text label.
 */
@property (nonatomic, copy) NSArray<UIView *> *rankViews;

/**
 The content view of search history tags.
 */
@property (nonatomic, weak) UIView *searchHistoryTagsContentView;

/**
 The base table view  of search view controller
 */
@property (nonatomic, strong) UITableView *baseSearchTableView;

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



@end

@implementation PYSearchViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.baseSearchTableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight - KNavigationBarHeight);
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

#pragma mark - Lazy
- (UITableView *)baseSearchTableView
{
    if (!_baseSearchTableView) {
        UITableView *baseSearchTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        baseSearchTableView.backgroundColor = [UIColor clearColor];
        baseSearchTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if ([baseSearchTableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) { // For the adapter iPad
            baseSearchTableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
        baseSearchTableView.delegate = self;
        baseSearchTableView.dataSource = self;
        [self.view addSubview:baseSearchTableView];
        _baseSearchTableView = baseSearchTableView;
    }
    return _baseSearchTableView;
}

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

- (UILabel *)searchHistoryHeader
{
    if (!_searchHistoryHeader) {
        UILabel *titleLabel = [self setupTitleLabel:@"搜索历史"];
        [self.searchHistoryView addSubview:titleLabel];
        _searchHistoryHeader = titleLabel;
    }
    return _searchHistoryHeader;
}

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

- (NSMutableArray *)searchHistories
{
    if (!_searchHistories) {
        _searchHistories = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath]];
    }
    return _searchHistories;
}

- (NSMutableArray *)colorPol
{
    if (!_colorPol) {
        NSArray *colorStrPol = @[@"009999", @"0099cc", @"0099ff", @"00cc99", @"00cccc", @"336699", @"3366cc", @"3366ff", @"339966", @"666666", @"666699", @"6666cc", @"6666ff", @"996666", @"996699", @"999900", @"999933", @"99cc00", @"99cc33", @"660066", @"669933", @"990066", @"cc9900", @"cc6600" , @"cc3300", @"cc3366", @"cc6666", @"cc6699", @"cc0066", @"cc0033", @"ffcc00", @"ffcc33", @"ff9900", @"ff9933", @"ff6600", @"ff6633", @"ff6666", @"ff6699", @"ff3366", @"ff3333"];
        NSMutableArray *colorPolM = [NSMutableArray array];
        for (NSString *colorStr in colorStrPol) {
            UIColor *color = [UIColor colorWithHexString:colorStr];
            [colorPolM addObject:color];
        }
        _colorPol = colorPolM;
    }
    return _colorPol;
}

- (UIBarButtonItem *)cancelButton
{
    return self.navigationItem.rightBarButtonItem;
}

- (void)setup
{
    self.baseSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.titleView = self.searchView;
    self.searchView.searchBar.delegate = self;
    [self addNavigationItemWithTitles:@[@"取消"] isLeft:NO target:self action:@selector(cancelDidClick) tags:@[@(1)]];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    /**
     * Initialize settings
     */
    self.hotSearchStyle = PYHotSearchStyleDefault;
    self.searchHistoryStyle = PYHotSearchStyleDefault;
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
    
    self.baseSearchTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.zsh_width = KScreenWidth;
    
    UILabel *emptySearchHistoryLabel = [[UILabel alloc] init];
    emptySearchHistoryLabel.textColor = [UIColor darkGrayColor];
    emptySearchHistoryLabel.font = [UIFont systemFontOfSize:13];
    emptySearchHistoryLabel.userInteractionEnabled = YES;
    emptySearchHistoryLabel.text = @"清空搜索历史";
    emptySearchHistoryLabel.textAlignment = NSTextAlignmentCenter;
    emptySearchHistoryLabel.zsh_height = 49;
    [emptySearchHistoryLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptySearchHistoryDidClick)]];
    emptySearchHistoryLabel.zsh_width = footerView.zsh_width;
    emptySearchHistoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.emptySearchHistoryLabel = emptySearchHistoryLabel;
    [footerView addSubview:emptySearchHistoryLabel];
    footerView.zsh_height = emptySearchHistoryLabel.zsh_height;
    self.baseSearchTableView.tableFooterView = footerView;
    
    self.baseSearchTableView.tableFooterView = self.recommendView;
    
    self.hotSearches = nil;
}

- (UILabel *)setupTitleLabel:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = kPingFangMedium(15);
    titleLabel.tag = 1;
    titleLabel.textColor = KZSHColor929292;
    [titleLabel sizeToFit];
    titleLabel.zsh_x = 0;
    titleLabel.zsh_y = 0;
    return titleLabel;
}

- (void)setupHotSearchRectangleTags
{
    UIView *contentView = self.hotSearchTagsContentView;
    contentView.zsh_width = KScreenWidth;
    contentView.zsh_x = -PYSEARCH_MARGIN * 1.5;
    contentView.zsh_y += 2;
    contentView.backgroundColor = [UIColor whiteColor];
    self.baseSearchTableView.backgroundColor = KClearColor;
    // remove all subviews in hotSearchTagsContentView
    [self.hotSearchTagsContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  
    CGFloat rectangleTagH = 40;
    for (int i = 0; i < self.hotSearches.count; i++) {
        UILabel *rectangleTagLabel = [[UILabel alloc] init];
        rectangleTagLabel.userInteractionEnabled = YES;
        rectangleTagLabel.font = [UIFont systemFontOfSize:14];
        rectangleTagLabel.textColor = KZSHColor929292;
        rectangleTagLabel.backgroundColor = [UIColor clearColor];
        rectangleTagLabel.text = self.hotSearches[i];
        rectangleTagLabel.zsh_width = contentView.zsh_width / PYRectangleTagMaxCol;
        rectangleTagLabel.zsh_height = rectangleTagH;
        rectangleTagLabel.textAlignment = NSTextAlignmentCenter;
        [rectangleTagLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        rectangleTagLabel.zsh_x = rectangleTagLabel.zsh_width * (i % PYRectangleTagMaxCol);
        rectangleTagLabel.zsh_y = rectangleTagLabel.zsh_height * (i / PYRectangleTagMaxCol);
        [contentView addSubview:rectangleTagLabel];
    }
    contentView.zsh_height = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    
    self.hotSearchView.zsh_height = CGRectGetMaxY(contentView.frame) + PYSEARCH_MARGIN * 2;
    self.baseSearchTableView.tableHeaderView.zsh_height = self.headerView.zsh_height = MAX(CGRectGetMaxY(self.hotSearchView.frame), CGRectGetMaxY(self.searchHistoryView.frame));
    
    for (int i = 0; i < PYRectangleTagMaxCol - 1; i++) {
        UIImageView *verticalLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-content-line-vertical"]];
        verticalLine.zsh_height = contentView.zsh_height;
        verticalLine.alpha = 0.7;
        verticalLine.zsh_x = contentView.zsh_width / PYRectangleTagMaxCol * (i + 1);
        verticalLine.zsh_width = 0.5;
        [contentView addSubview:verticalLine];
    }
    
    for (int i = 0; i < ceil(((double)self.hotSearches.count / PYRectangleTagMaxCol)) - 1; i++) {
        UIImageView *verticalLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell-content-line"]];
        verticalLine.zsh_height = 0.5;
        verticalLine.alpha = 0.7;
        verticalLine.zsh_y = rectangleTagH * (i + 1);
        verticalLine.zsh_width = contentView.zsh_width;
        [contentView addSubview:verticalLine];
    }
    [self layoutForDemand];
    // Note：When the operating system for the iOS 9.x series tableHeaderView height settings are invalid, you need to reset the tableHeaderView
    [self.baseSearchTableView setTableHeaderView:self.baseSearchTableView.tableHeaderView];
}

- (void)setupHotSearchRankTags
{
    UIView *contentView = self.hotSearchTagsContentView;
    [self.hotSearchTagsContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *rankTextLabelsM = [NSMutableArray array];
    NSMutableArray *rankTagM = [NSMutableArray array];
    NSMutableArray *rankViewM = [NSMutableArray array];
    for (int i = 0; i < self.hotSearches.count; i++) {
        UIView *rankView = [[UIView alloc] init];
        rankView.zsh_height = 40;
        rankView.zsh_width = (self.baseSearchTableView.zsh_width - PYSEARCH_MARGIN * 3) * 0.5;
        rankView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [contentView addSubview:rankView];
        // rank tag
        UILabel *rankTag = [[UILabel alloc] init];
        rankTag.textAlignment = NSTextAlignmentCenter;
        rankTag.font = [UIFont systemFontOfSize:10];
        rankTag.layer.cornerRadius = 3;
        rankTag.clipsToBounds = YES;
        rankTag.text = [NSString stringWithFormat:@"%d", i + 1];
        [rankTag sizeToFit];
        rankTag.zsh_width = rankTag.zsh_height += PYSEARCH_MARGIN * 0.5;
        rankTag.zsh_y = (rankView.zsh_height - rankTag.zsh_height) * 0.5;
        [rankView addSubview:rankTag];
        [rankTagM addObject:rankTag];
        // rank text
        UILabel *rankTextLabel = [[UILabel alloc] init];
        rankTextLabel.text = self.hotSearches[i];
        rankTextLabel.userInteractionEnabled = YES;
        [rankTextLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        rankTextLabel.textAlignment = NSTextAlignmentLeft;
        rankTextLabel.backgroundColor = [UIColor clearColor];
        rankTextLabel.textColor = KZSHColor929292;
        rankTextLabel.font = [UIFont systemFontOfSize:14];
        rankTextLabel.zsh_x = CGRectGetMaxX(rankTag.frame) + PYSEARCH_MARGIN;
        rankTextLabel.zsh_width = (self.baseSearchTableView.zsh_width - PYSEARCH_MARGIN * 3) * 0.5 - rankTextLabel.zsh_x;
        rankTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        rankTextLabel.zsh_height = rankView.zsh_height;
        [rankTextLabelsM addObject:rankTextLabel];
        [rankView addSubview:rankTextLabel];
        
        UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell-content-line"]];
        line.zsh_height = 0.5;
        line.alpha = 0.7;
        line.zsh_x = -KScreenWidth * 0.5;
        line.zsh_y = rankView.zsh_height - 1;
        line.zsh_width = self.baseSearchTableView.zsh_width;
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [rankView addSubview:line];
        [rankViewM addObject:rankView];
        
        // set tag's background color and text color
        switch (i) {
            case 0: // NO.1
                rankTag.backgroundColor = [UIColor colorWithHexString:self.rankTagBackgroundColorHexStrings[0]];
                rankTag.textColor = [UIColor whiteColor];
                break;
            case 1: // NO.2
                rankTag.backgroundColor = [UIColor colorWithHexString:self.rankTagBackgroundColorHexStrings[1]];
                rankTag.textColor = [UIColor whiteColor];
                break;
            case 2: // NO.3
                rankTag.backgroundColor = [UIColor colorWithHexString:self.rankTagBackgroundColorHexStrings[2]];
                rankTag.textColor = [UIColor whiteColor];
                break;
            default: // Other
                rankTag.backgroundColor = [UIColor colorWithHexString:self.rankTagBackgroundColorHexStrings[3]];
                rankTag.textColor = KZSHColor929292;
                break;
        }
    }
    self.rankTextLabels = rankTextLabelsM;
    self.rankTags = rankTagM;
    self.rankViews = rankViewM;
    
    for (int i = 0; i < self.rankViews.count; i++) { // default is two column
        UIView *rankView = self.rankViews[i];
        rankView.zsh_x = (PYSEARCH_MARGIN + rankView.zsh_width) * (i % 2);
        rankView.zsh_y = rankView.zsh_height * (i / 2);
    }
    
    contentView.zsh_height = CGRectGetMaxY(self.rankViews.lastObject.frame);
    self.hotSearchView.zsh_height = CGRectGetMaxY(contentView.frame) + PYSEARCH_MARGIN * 2;
    self.baseSearchTableView.tableHeaderView.zsh_height = self.headerView.zsh_height = MAX(CGRectGetMaxY(self.hotSearchView.frame), CGRectGetMaxY(self.searchHistoryView.frame));
    [self layoutForDemand];
    
    // Note：When the operating system for the iOS 9.x series tableHeaderView height settings are invalid, you need to reset the tableHeaderView
    [self.baseSearchTableView setTableHeaderView:self.baseSearchTableView.tableHeaderView];
}

- (void)setupHotSearchNormalTags
{
    self.hotSearchTags = [self addAndLayoutTagsWithTagsContentView:self.hotSearchTagsContentView tagTexts:self.hotSearches];
    [self setHotSearchStyle:self.hotSearchStyle];
}

- (void)setupSearchHistoryTags
{
    self.baseSearchTableView.tableFooterView = self.showRecommendView ? self.recommendView:nil;
    self.searchHistoryTagsContentView.zsh_y = PYSEARCH_MARGIN;
    self.emptyButton.zsh_y = self.searchHistoryHeader.zsh_y - PYSEARCH_MARGIN * 0.5;
    self.searchHistoryTagsContentView.zsh_y = CGRectGetMaxY(self.emptyButton.frame) + PYSEARCH_MARGIN;
    self.searchHistoryTags = [self addAndLayoutTagsWithTagsContentView:self.searchHistoryTagsContentView tagTexts:[self.searchHistories copy]];
}

- (ZSHRecommendView *)recommendView{
    if (!_recommendView) {
        _recommendView = [[ZSHRecommendView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight*0.7)];
    }
    return _recommendView;
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
    self.baseSearchTableView.tableHeaderView.zsh_height = self.headerView.zsh_height = MAX(CGRectGetMaxY(self.hotSearchView.frame), CGRectGetMaxY(self.searchHistoryView.frame));
    self.baseSearchTableView.tableHeaderView.hidden = NO;
    
    // Note：When the operating system for the iOS 9.x series tableHeaderView height settings are invalid, you need to reset the tableHeaderView
    [self.baseSearchTableView setTableHeaderView:self.baseSearchTableView.tableHeaderView];
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
        [self.baseSearchTableView reloadData];
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

- (void)setCancelButton:(UIBarButtonItem *)cancelButton
{
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath
{
    _searchHistoriesCachePath = [searchHistoriesCachePath copy];
    
    self.searchHistories = nil;
    if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
        [self.baseSearchTableView reloadData];
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

- (void)setSearchBarBackgroundColor:(UIColor *)searchBarBackgroundColor
{
    _searchBarBackgroundColor = searchBarBackgroundColor;
    self.searchView.searchTextField.backgroundColor = searchBarBackgroundColor;
}

- (void)setRankTagBackgroundColorHexStrings:(NSArray<NSString *> *)rankTagBackgroundColorHexStrings
{
    if (rankTagBackgroundColorHexStrings.count < 4) {
        NSArray *colorStrings = @[@"#f14230", @"#ff8000", @"#ffcc01", @"#ebebeb"];
        _rankTagBackgroundColorHexStrings = colorStrings;
    } else {
        _rankTagBackgroundColorHexStrings = @[rankTagBackgroundColorHexStrings[0], rankTagBackgroundColorHexStrings[1], rankTagBackgroundColorHexStrings[2], rankTagBackgroundColorHexStrings[3]];
    }
    
    self.hotSearches = self.hotSearches;
}

- (void)setHotSearches:(NSArray *)hotSearches
{
    _hotSearches = hotSearches;
    if (0 == hotSearches.count || !self.showHotSearch) {
        self.hotSearchHeader.hidden = YES;
        self.hotSearchTagsContentView.hidden = YES;
        if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
            UIView *tableHeaderView = self.baseSearchTableView.tableHeaderView;
            tableHeaderView.zsh_height = PYSEARCH_MARGIN * 1.5;
            [self.baseSearchTableView setTableHeaderView:tableHeaderView];
        }
        return;
    };
    
    self.baseSearchTableView.tableHeaderView.hidden = NO;
    self.hotSearchHeader.hidden = NO;
    self.hotSearchTagsContentView.hidden = NO;
    if (PYHotSearchStyleDefault == self.hotSearchStyle
        || PYHotSearchStyleColorfulTag == self.hotSearchStyle
        || PYHotSearchStyleBorderTag == self.hotSearchStyle
        || PYHotSearchStyleARCBorderTag == self.hotSearchStyle) {
        [self setupHotSearchNormalTags];
    } else if (PYHotSearchStyleRankTag == self.hotSearchStyle) {
        [self setupHotSearchRankTags];
    } else if (PYHotSearchStyleRectangleTag == self.hotSearchStyle) {
        [self setupHotSearchRectangleTags];
    }
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
    
    switch (searchHistoryStyle) {
        case PYSearchHistoryStyleColorfulTag:
            for (UILabel *tag in self.searchHistoryTags) {
                tag.textColor = [UIColor whiteColor];
                tag.layer.borderColor = nil;
                tag.layer.borderWidth = 0.0;
                tag.backgroundColor = PYSEARCH_COLORPolRandomColor;
            }
            break;
        case PYSearchHistoryStyleBorderTag:
            for (UILabel *tag in self.searchHistoryTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = KZSHColor929292.CGColor;
                tag.layer.borderWidth = 0.3;
            }
            break;
        case PYSearchHistoryStyleARCBorderTag:
            for (UILabel *tag in self.searchHistoryTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = KZSHColor929292.CGColor;
                tag.layer.borderWidth = 0.3;
                tag.layer.cornerRadius = tag.zsh_height * 0.3;
            }
            break;
        default:
            break;
    }
}

- (void)setHotSearchStyle:(PYHotSearchStyle)hotSearchStyle
{
    _hotSearchStyle = hotSearchStyle;
    
    switch (hotSearchStyle) {
        case PYHotSearchStyleColorfulTag:
            for (UILabel *tag in self.hotSearchTags) {
                tag.textColor = [UIColor whiteColor];
                tag.layer.borderColor = nil;
                tag.layer.borderWidth = 0.0;
                tag.backgroundColor = PYSEARCH_COLORPolRandomColor;
            }
            break;
        case PYHotSearchStyleBorderTag:
            for (UILabel *tag in self.hotSearchTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = KZSHColor929292.CGColor;
                tag.layer.borderWidth = 0.3;
            }
            break;
        case PYHotSearchStyleARCBorderTag:
            for (UILabel *tag in self.hotSearchTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = KZSHColor929292.CGColor;
                tag.layer.borderWidth = 0.5;
                tag.layer.cornerRadius = tag.zsh_height * 0.3;
            }
            break;
        case PYHotSearchStyleRectangleTag:
            self.hotSearches = self.hotSearches;
            break;
        case PYHotSearchStyleRankTag:
            self.rankTagBackgroundColorHexStrings = nil;
            break;
            
        default:
            break;
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
    if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
        [self.baseSearchTableView reloadData];
    } else {
        self.searchHistoryStyle = self.searchHistoryStyle;
    }
    if (YES == self.swapHotSeachWithSearchHistory) {
        self.hotSearches = self.hotSearches;
    }
    
     [self.baseSearchTableView reloadData];
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

- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = kPingFangLight(14);
    label.text = title;
    label.textColor = KZSHColor929292;
    label.backgroundColor = KClearColor;
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.zsh_width += 20;
    label.zsh_height += 14;
    return label;
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
            [self.baseSearchTableView reloadData];
        } else {
            self.searchHistoryStyle = self.searchHistoryStyle;
        }
    }
    
    [self handleSearchResultShow];
}

- (void)handleSearchResultShow
{
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
                RLog(@"PYSearchDebug： searchResultController cannot be nil when searchResultShowMode is PYSearchResultShowModeEmbed.");
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
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
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
    return YES;
}

- (void)closeDidClick:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    [self.searchHistories removeObject:cell.textLabel.text];
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    [self.baseSearchTableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    self.baseSearchTableView.tableFooterView.hidden = 0 == self.searchHistories.count || !self.showSearchHistory;
    self.baseSearchTableView.tableFooterView.hidden = NO;
    return self.showSearchHistory && PYSearchHistoryStyleCell == self.searchHistoryStyle ? self.searchHistories.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PYSearchHistoryCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = KZSHColor929292;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor clearColor];
        
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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

@end
