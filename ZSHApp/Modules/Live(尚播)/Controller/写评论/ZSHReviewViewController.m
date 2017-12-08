//
//  ZSHReviewViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHReviewViewController.h"
#import "ZSHReviewCell.h"
#import "ZSHLiveLogic.h"
#import "XXtextView.h"

@interface ZSHReviewViewController ()

@property (nonatomic, strong) NSArray        *dataArr;
@property (nonatomic, strong) ZSHLiveLogic   *liveLogic;
@property (nonatomic, strong) XXTextView     *textView;

@end

@implementation ZSHReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self loadData];
    [self createUI];
}

- (void)loadData {
    self.title = @"评论";
    _liveLogic = [[ZSHLiveLogic alloc] init];
    [self initViewModel];
    [self requestData];
}


- (void)createUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, KBottomNavH, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHReviewCell class] forCellReuseIdentifier:NSStringFromClass([ZSHReviewCell class])];
    
    [self createBottomBar];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    kWeakSelf(self);
    for (int i = 0; i<self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        kWeakSelf(cellModel);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZSHReviewCell class]) forIndexPath:indexPath];
            ZSHCommentListModel *model = weakself.dataArr[indexPath.row];
            
            weakcellModel.height = [cell getCellHeightWithModel:model];
//            NSDictionary *ndextParamDic = @{KFromClassType:@(ZSHWeiboVCToWeiBoCell)};
//            [cell updateCellWithParamDic:ndextParamDic];
            [cell updateCellWithModel:model];
//            [cell setNeedsUpdateConstraints];
//            [cell updateConstraintsIfNeeded];
            return cell;
        };
    }
    
    return sectionModel;
}

- (void)createBottomBar {
    UIView *inputBackground = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-KBottomNavH, KScreenWidth, KBottomNavH)];
    [self.view addSubview:inputBackground];
    
    [inputBackground addSubview:self.textView];
    
    UIButton *sendBtn = [[UIButton alloc] init];
    sendBtn.frame = CGRectMake(KScreenWidth-45, 9.5, 30, 30);
    [sendBtn setImage:[UIImage imageNamed:@"weibo_send_4"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [inputBackground addSubview:sendBtn];
}

- (XXTextView *)textView {
    if (!_textView) {
        _textView  = [[XXTextView alloc] initWithFrame:CGRectMake(15, 9.5, KScreenWidth-80, 30)];
        _textView.backgroundColor = KZSHColor181818;
        _textView.textColor = KZSHColor929292;
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _textView.keyboardAppearance = UIKeyboardAppearanceDark;
        _textView.xx_placeholder = @"有什么想要说的吗......";
        _textView.xx_placeholderFont = [UIFont systemFontOfSize:12];
        _textView.xx_placeholderColor = KZSHColor929292;
        _textView.layer.cornerRadius = 15;
        _textView.layer.masksToBounds = true;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = KZSHColor929292.CGColor;
    }
    return _textView;
}

- (void)requestData {
    kWeakSelf(self);
    [_liveLogic requestCommentListWithCircleID:self.paramDic[@"CircleID"] success:^(id response) {
        weakself.dataArr = response;
        [weakself initViewModel];
    }];
}

- (void)sendAction {
    if (!_textView.text.length) {
        kWeakSelf(self);
        [_liveLogic requestAddCommentWithDic:@{@"HONOURUSER_ID":@"d6a3779de8204dfd9359403f54f7d27c",@"CIRCLE_ID":self.paramDic[@"CircleID"],@"COMCONTENT":_textView.text} success:^(id response) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [ac addAction:cancelAction];
            [weakself presentViewController:ac animated:YES completion:nil];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
