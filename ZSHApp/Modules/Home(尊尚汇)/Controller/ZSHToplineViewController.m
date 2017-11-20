//
//  ZSHToplineViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHToplineViewController.h"
#import "ZSHToplineCell.h"

static NSString *ZSHToplineCellID = @"ZSHToplineCellID";

@interface ZSHToplineViewController ()

@end

@implementation ZSHToplineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
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
}

- (void)createBottomLine {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = KBlackColor;
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, kRealValue(49)));
    }];
    
    
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
        make.bottom.mas_equalTo(self.view).offset(kRealValue(-9.5));
        make.size.mas_equalTo(CGSizeMake(kRealValue(285), kRealValue(31)));
    }];
    
    UIButton *commentBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"withImage":@(YES),@"normalImage":@"head_image_1"}];
    [self.view addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(kRealValue(-9.5));
        make.trailing.mas_equalTo(self.view).offset(kRealValue(-46));
        make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(30)));
    }];
    
    
    UIButton *shareBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"withImage":@(YES),@"normalImage":@"head_image_2"}];
    [self.view addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(kRealValue(-9.5));
        make.trailing.mas_equalTo(self.view).offset(kRealValue(-11));
        make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(30)));
    }];
}

- (UIView *)createTableViewHead {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(375))];
    
    
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"21cake蛋糕预订",@"font": kPingFangMedium(15)}];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(kRealValue(10));
        make.left.mas_equalTo(view).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(300), kRealValue(16)));
    }];

    UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_image_3"]];
    [view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(kRealValue(45));
        make.left.mas_equalTo(view).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(345), kRealValue(200)));
    }];
    
    UILabel *contentLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"font": kPingFangRegular(12)}];
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:5];
    [paragraphStyle setParagraphSpacing:22];
    NSString *str = @"我敬重每一枚出炉的糕点，除了感谢它带给我甜蜜的愉悦，吃完之后将体会到的宇宙级美好，还神经质的认为手上捧着的是三四个世纪前的配方，它融化在我的舌尖，世间万物在一瞬变得渺小。\n本周，荣耀黑卡特权局联合21cake为持卡人精选了8款定制蛋糕";
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:str];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    [contentLabel  setAttributedText:setString];
    contentLabel.numberOfLines = 0;
    [view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(kRealValue(263));
        make.left.mas_equalTo(view).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(345), kRealValue(112)));
    }];

    
    return view;
}


//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *titleArr = @[@"芒果姆斯", @"朗姆芝士", @"栗蓉暗香"];
    NSArray *subtitleArr = @[@"使用马达加斯加香草荚制作戚风香草坯", @"使用马达加斯加香草荚制作戚风香草坯", @"使用马达加斯加香草荚制作戚风香草坯"];
    NSArray *imageArr = @[@"head_image_4", @"head_image_5", @"head_image_6"];
    for (int i = 0; i < 3; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(270);
        [sectionModel.cellModelArray addObject:cellModel];
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


@end
