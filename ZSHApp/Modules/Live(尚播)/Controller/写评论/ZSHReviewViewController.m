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
@property (nonatomic, strong) NSString       *HONOURUSER_ID;

@end

@implementation ZSHReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self loadData];
    [self createUI];
}

- (void)loadData {
    self.title = @"评论";
    _liveLogic = [[ZSHLiveLogic alloc] init];
    _HONOURUSER_ID = self.paramDic[@"HONOURUSER_ID"];
    
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
//    sectionModel.footerHeight = 1;
    kWeakSelf(self);
    for (int i = 0; i<self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        ZSHCommentListModel *model = weakself.dataArr[i];
        cellModel.height = [ZSHReviewCell getCellHeightWithModel:model];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZSHReviewCell class]) forIndexPath:indexPath];
            if (i == self.dataArr.count -1) {
                cell.backgroundColor = [UIColor redColor];
            }
            ZSHCommentListModel *model = weakself.dataArr[indexPath.row];
            [cell updateCellWithModel:model];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            [weakself.textView becomeFirstResponder];
            ZSHCommentListModel *model = weakself.dataArr[indexPath.row];
            weakself.textView.xx_placeholder = NSStringFormat(@"回复@%@", model.COMMENTNICKNAME);
            weakself.HONOURUSER_ID = model.HONOURUSER_ID;
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



- (void)headerRereshing{
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRereshing{
    [self.tableView.mj_footer endRefreshing];
}


- (void)keyboardWillHide {
    [_textView setXx_placeholder:@"有什么想要说的吗......"];
    _textView.text = @"";
    _HONOURUSER_ID = self.paramDic[@"HONOURUSER_ID"];
}

- (void)requestData {
    kWeakSelf(self);
    [_liveLogic requestCommentListWithCircleID:self.paramDic[@"CircleID"] success:^(id response) {
        weakself.dataArr = response;
        [weakself initViewModel];
    }];
}

- (void)sendAction {
    kWeakSelf(self);
    if (_textView.text.length) {
        [_liveLogic requestAddCommentWithDic:@{@"HONOURUSER_ID":@"d6a3779de8204dfd9359403f54f7d27c",@"CIRCLE_ID":self.paramDic[@"CircleID"],@"COMCONTENT":_textView.text,@"REPLYHONOURUSER_ID":_HONOURUSER_ID} success:^(id response) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakself.textView  resignFirstResponder];
                [weakself.textView setXx_placeholder:@"有什么想要说的吗......"];
                weakself.textView.text = @"";
            }];
            [ac addAction:cancelAction];
            [weakself presentViewController:ac animated:YES completion:nil];
            [weakself requestData];

        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

@end
