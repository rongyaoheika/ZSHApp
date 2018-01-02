//
//  ZSHEntertainmentViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEntertainmentViewController.h"
#import "ZSHEnterTainmentCell.h"
#import "ZSHEntertainmentModel.h"
#import "ZSHEntertainmentDetailViewController.h"
#import "ZSHEntertainmentDisViewController.h"
#import "ZSHTogetherLogic.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHCardBtnListView.h"
#import "ZSHGuideView.h"
@interface ZSHEntertainmentViewController ()

@property (nonatomic, strong) ZSHGuideView         *guideView;
@property (nonatomic, strong) UIButton             *titleBtn;
@property (nonatomic, strong) ZSHBottomBlurPopView *topBtnListView;
@property (nonatomic, assign) NSInteger            typeIndex;
@property (nonatomic, strong) NSArray              *typeDicArr; //字典数组
@property (nonatomic, strong) NSArray              *typeArr;
@property (nonatomic, strong) NSMutableArray       *dataArr;
@property (nonatomic, strong) ZSHTogetherLogic     *togetherLogic;

@end

static NSString *ZSHEnterTainmentCellID = @"ZSHEnterTainmentCell";
@implementation ZSHEntertainmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
    [self requestData];
    
}

- (void)createUI{
    self.navigationItem.titleView = self.titleBtn;
    self.titleBtn.frame = CGRectMake(0, 0, 75, 20);
    [self.titleBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(15)];
    
    [self addNavigationItemWithTitles:@[@"去发布"] isLeft:NO target:self action:@selector(distributeAction) tags:@[@(1)]];

    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHEnterTainmentCell class] forCellReuseIdentifier:ZSHEnterTainmentCellID];
    self.tableView.tableHeaderView = self.guideView;

}

- (ZSHGuideView *)guideView {
    if(!_guideView) {
        NSDictionary *nextParamDic = @{KFromClassType:@(FromTogetherToGuideView),@"pageViewHeight":@(kRealValue(120)),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
        _guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(120)) paramDic:nextParamDic];
    }
    return _guideView;
}


- (UIButton *)titleBtn{
    if (!_titleBtn) {
        NSDictionary *titleBtnDic = @{@"title":self.paramDic[@"Title"],@"font":kPingFangMedium(17)};
        _titleBtn = [ZSHBaseUIControl createBtnWithParamDic:titleBtnDic];
        [_titleBtn addTarget:self action:@selector(titleBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtn setImage:[UIImage imageNamed:@"hotel_btn"] forState:UIControlStateNormal];
    }
    return _titleBtn;
}

- (void)titleBtnAction{
    _titleBtn.selected = !_titleBtn.selected;
    if (_titleBtn.selected) {
        [self changeButtonObject:_titleBtn TransformAngle:M_PI];
    } else {
        [self changeButtonObject:_titleBtn TransformAngle:0];
    }
}

-(void)changeButtonObject:(UIButton *)button TransformAngle:(CGFloat)angle{
    kWeakSelf(self);
    [UIView animateWithDuration:0.5 animations:^{
        button.imageView.transform =CGAffineTransformMakeRotation(angle);
        if (angle == M_PI ) {//下拉展开
            [weakself requestTogetherDataType];
        } else if(angle == 0){//收起
            [ZSHBaseUIControl setAnimationWithHidden:YES view:weakself.topBtnListView completedBlock:nil];
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma getter
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWith:(ZSHFromVCToBottomBlurPopView)fromClassType{
    
    NSDictionary *nextParamDic = @{KFromClassType:@(fromClassType),@"titleArr":self.typeArr};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight) paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    [bottomBlurPopView setBlurEnabled:YES];
    return bottomBlurPopView;
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<_togetherLogic.entertainModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        ZSHEntertainmentModel *model = _togetherLogic.entertainModelArr[i];
        if (model.CONVERGEIMGS.count) {
            cellModel.height = kRealValue(250);
        } else {
            cellModel.height = kRealValue(155);
        }
       
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHEnterTainmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEnterTainmentCellID];
            ZSHEntertainmentModel *model = weakself.togetherLogic.entertainModelArr[indexPath.row];
            if (indexPath.row == _togetherLogic.entertainModelArr.count-1) {
                
            }
            [cell updateCellWithModel:model];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHEntertainmentDetailViewController *enterTainMentDetailVC = [[ZSHEntertainmentDetailViewController alloc]initWithParamDic:@{@"CONVERGEDETAIL_ID":weakself.togetherLogic.entertainModelArr[indexPath.row].CONVERGEDETAIL_ID}];
            [weakself.navigationController pushViewController:enterTainMentDetailVC animated:YES];
        };
    }
    return sectionModel;
}


- (void)headerRereshing{
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.tableView.mj_header endRefreshing];
    });
}

- (void)footerRereshing{
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.tableView.mj_footer endRefreshing];
    });
}

#pragma action
- (void)distributeAction{
    ZSHEntertainmentDisViewController *disVC = [[ZSHEntertainmentDisViewController alloc]initWithParamDic:@{@"CONVERGE_ID":self.paramDic[@"CONVERGE_ID"]}];
    [self.navigationController pushViewController:disVC animated:YES];
}

- (void)requestData {
    kWeakSelf(self);
    _togetherLogic = [[ZSHTogetherLogic alloc] init];
    [_togetherLogic requestPartyListWithDic:@{@"CONVERGE_ID":self.paramDic[@"CONVERGE_ID"], @"HONOURUSER_ID":@"", @"STATUS":@""} success:^(id response) {
        [weakself initViewModel];
        [weakself.guideView updateViewWithParamDic:@{@"dataArr":response}];
    }];
}

//选中某类型
- (void)orderTypeBtnAction:(UIButton *)orderBtn {
    _typeIndex = orderBtn.tag-1;
    [_titleBtn setTitle:self.typeArr[_typeIndex] forState:UIControlStateNormal];
    switch (orderBtn.tag) {
        case 1:{//吃
            [self changeButtonObject:_titleBtn TransformAngle:0];
             _titleBtn.selected = !_titleBtn.selected;
            break;
        }
        case 2:// 喝
        case 3:// 玩
        case 4:{// 乐
            [self changeButtonObject:_titleBtn TransformAngle:0];
             _titleBtn.selected = !_titleBtn.selected;
            break;
        }
        default:
            break;
           
    }
}

- (void)requestTogetherDataType{//吃喝玩乐类型
    kWeakSelf(self);
    NSMutableArray *mTypeArr = [[NSMutableArray alloc]init];
    [_togetherLogic requestTogetherDataTypeWithACONVERGE_ID:self.paramDic[@"CONVERGE_ID"]  success:^(id response) {
        _typeDicArr = response;
        for (NSDictionary *dic in _typeDicArr) {
            [mTypeArr addObject:dic[@"NAME"]];
        }
        _typeArr = mTypeArr;
        weakself.topBtnListView = [weakself createBottomBlurPopViewWith:ZSHFromGoodsMineVCToToBottomBlurPopView];
        [ZSHBaseUIControl setAnimationWithHidden:NO view:weakself.topBtnListView completedBlock:nil];
        
        //订单列表button点击
        ZSHCardBtnListView *listView = [weakself.topBtnListView viewWithTag:2];
        listView.btnClickBlock = ^(UIButton *btn) {
            [weakself orderTypeBtnAction:btn];
        };
        
        //点击背景消失
        weakself.topBtnListView .dissmissViewBlock = ^(UIView *blurView, NSIndexPath *indexpath) {
            [ZSHBaseUIControl setAnimationWithHidden:YES view:blurView completedBlock:nil];
        };
    }];
    
}


@end
