//
//  ZSHToplineViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHToplineViewController.h"
#import "ZSHToplineCell.h"
#import "ZSHMoreLogic.h"
static NSString *ZSHToplineCellID = @"ZSHToplineCellID";

@interface ZSHToplineViewController ()

@property (nonatomic, copy)   NSString                  *shopId;
@property (nonatomic, strong) ZSHMoreLogic              *moreLogic;
@property (nonatomic, strong) NSDictionary              *dataDic;
@property (nonatomic, strong) UILabel                   *titleLabel;
@property (nonatomic, strong) UIImageView               *contentView;
@property (nonatomic, strong) UILabel                   *contentLabel;

@end

@implementation ZSHToplineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.shopId = self.paramDic[@"shopId"];
    [self requestData];
    [self initViewModel];
}

- (void)requestData{
    kWeakSelf(self);
    _moreLogic = [[ZSHMoreLogic alloc]init];
    NSDictionary *paramDic = @{@"NEWS_ID":self.shopId};
    [_moreLogic requestNewsDetailWithParamDic:paramDic Success:^(id responseObject) {
        RLog(@"新闻详情的数据==%@",responseObject);
        _dataDic = responseObject;
        
        [weakself updateUI];
        [weakself initViewModel];
        
    } fail:nil];
}

- (void)createUI{
    
    self.title = @"头条";

    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, KBottomNavH, 0));
    }];
    [self.tableView registerClass:[ZSHToplineCell class] forCellReuseIdentifier:ZSHToplineCellID];
    [self.tableView setTableHeaderView:[self createTableViewHead]];
    
    [self createBottomLine];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

- (void)createBottomLine {
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = kPingFangRegular(15);
    textField.textColor = KZSHColor929292;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"有什么想要说的吗......" attributes:@{NSForegroundColorAttributeName:KZSHColor929292, NSFontAttributeName:kPingFangRegular(12)}];
    textField.layer.borderWidth = 0.5;
    textField.layer.cornerRadius = 15;
    textField.layer.borderColor  = KZSHColor929292.CGColor;
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(kRealValue(KLeftMargin));
        make.bottom.mas_equalTo(self.view).offset(kRealValue(-(9.5+KBottomHeight)));
        make.size.mas_equalTo(CGSizeMake(kRealValue(285), kRealValue(31)));
    }];
    
    UIButton *commentBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"withImage":@(YES),@"normalImage":@"head_image_1"}];
    [self.view addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(textField);
        make.trailing.mas_equalTo(self.view).offset(kRealValue(-46));
        make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(30)));
    }];
    
    
    UIButton *shareBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"withImage":@(YES),@"normalImage":@"head_image_2"}];
    [self.view addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(textField);
        make.trailing.mas_equalTo(self.view).offset(kRealValue(-11));
        make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(30)));
    }];
}

- (UIView *)createTableViewHead {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(375))];
    
    
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"",@"font": kPingFangMedium(15)}];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(kRealValue(10));
        make.left.mas_equalTo(view).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(300), kRealValue(16)));
    }];
    _titleLabel = titleLabel;

    UIImageView *contentView = [[UIImageView alloc] init];
    [view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(kRealValue(45));
        make.left.mas_equalTo(view).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(345), kRealValue(200)));
    }];
    _contentView = contentView;
    
    
    UILabel *contentLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"font": kPingFangRegular(12)}];
    contentLabel.numberOfLines = 0;
    [view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(kRealValue(263));
        make.left.mas_equalTo(view).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(345), kRealValue(112)));
    }];
    _contentLabel = contentLabel;
    
    return view;
}


//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *titleArr = [NSArray array];
    NSArray *subtitleArr = [NSArray array];
    NSArray *imageArr = [NSArray array];
    if (_dataDic) {
        titleArr =  @[_dataDic[@"TITLEPIECEONE"],_dataDic[@"TITLEPIECETWO"],_dataDic[@"TITLEPIECETHREE"]];
        subtitleArr = @[_dataDic[@"CONTENTPIECEONE"],_dataDic[@"CONTENTPIECETWO"],_dataDic[@"CONTENTPIECETHREE"]];
        imageArr = @[_dataDic[@"IMGPIECEONE"],_dataDic[@"IMGPIECETWO"],_dataDic[@"IMGPIECETHREE"]];
    }
    for (int i = 0; i < titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(270);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHToplineCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHToplineCellID forIndexPath:indexPath];
            [cell updateCellWithParamDic:@{@"title":titleArr[indexPath.row],@"subtitle":subtitleArr[indexPath.row], @"image":imageArr[indexPath.row]}];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}


- (void)updateUI{
    _titleLabel.text = _dataDic[@"NEWSTITLE"];
    
    _contentLabel.text = _dataDic[@"NEWSCONTENT"];
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:5];
    [paragraphStyle setParagraphSpacing:22];
    NSString *str = _contentLabel.text;
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:str];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    [_contentLabel  setAttributedText:setString];
    
    
    [_contentView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"NEWSIMG"]]];
}

@end
