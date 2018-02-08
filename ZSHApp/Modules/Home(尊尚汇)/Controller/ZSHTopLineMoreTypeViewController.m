//
//  ZSHTopLineMoreTypeViewController.m
//  ZSHApp
//
//  Created by mac on 2018/2/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHTopLineMoreTypeViewController.h"

@interface ZSHTopLineMoreTypeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ChannelCellDeleteDelegate>{
    NSMutableArray *_myTags;
    NSMutableArray *_recommandTags;
    BOOL _onEdit;
}

@end

@implementation ZSHTopLineMoreTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _myChannels = self.paramDic[@"myChannels"];
    _recommandChannels = self.paramDic[@"recommandChannels"];
    
    //加载数据
    [self makeTags];
    _onEdit = NO;
}

- (void)createUI{
    self.title = @"所有频道";
    self.view.backgroundColor = [UIColor blackColor];
    
    //加载数据
    [self setupViews];
}

- (void)makeTags{
    _myTags = @[].mutableCopy;
    _recommandTags = @[].mutableCopy;
    for (NSString *title in _myChannels) {
        Channel *mod = [[Channel alloc]init];
        mod.title = title;
        if ([title isEqualToString:@"关注"]||[title isEqualToString:@"推荐"]) {
            mod.resident = YES;//常驻
        }
        mod.editable = YES;
        mod.selected = NO;
        mod.tagType = MyChannel;
        //demo默认选择第一个
        if ([title isEqualToString:@"关注"]) {
            mod.selected = YES;
        }
        [_myTags addObject:mod];
    }
    for (NSString *title in _recommandChannels) {
        Channel *mod = [[Channel alloc]init];
        mod.title = title;
        if ([title isEqualToString:@"关注"]||[title isEqualToString:@"推荐"]) {
            mod.resident = YES;//常驻
        }
        mod.editable = NO;
        mod.tagType = RecommandChannel;
        [_recommandTags addObject:mod];
    }
}


- (void)setupViews{
    
    UIButton *exit = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - kRealValue(44) - KLeftMargin, 30, kRealValue(44), kRealValue(44))];
    [self.view addSubview:exit];
    [exit setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
    exit.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [exit addTarget:self action:@selector(returnLast) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
   
    [self.collectionView registerClass:[ChannelCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head1"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //添加长按的手势
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.collectionView addGestureRecognizer:longPress];
}

- (void)longPress:(UIGestureRecognizer *)longPress {
    //获取点击在collectionView的坐标
    CGPoint point=[longPress locationInView:self.collectionView];
    //从长按开始
    NSIndexPath *indexPath=[self.collectionView indexPathForItemAtPoint:point];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        //长按手势状态改变
    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        [self.collectionView updateInteractiveMovementTargetPosition:point];
        //长按手势结束
    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        [self.collectionView endInteractiveMovement];
        //其他情况
    } else {
        [self.collectionView cancelInteractiveMovement];
    }
}

#pragma mark- collection datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _myTags.count;
    }else{
        return _recommandTags.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellIdentifier";
    ChannelCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (_myTags.count>indexPath.item) {
            cell.model = _myTags[indexPath.item];
            cell.delBtn.tag = indexPath.item;
            cell.delegate = self;
            if (_onEdit) {
                if (cell.model.resident) {
                    cell.delBtn.hidden = YES;
                }else{
                    if (!cell.model.editable) {
                        cell.delBtn.hidden = YES;
                    }else{
                        cell.delBtn.hidden = NO;
                    }
                }
            }else{
                cell.delBtn.hidden = YES;
            }
        }
    }else if (indexPath.section == 1){
        if (_recommandTags.count>indexPath.item) {
            cell.model = _recommandTags[indexPath.item];
            if (_onEdit) {
                cell.delBtn.hidden = NO;
            }else{
                cell.delBtn.hidden = YES;
            }
        }
    }
    return cell;
}

#pragma mark- collection delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(kRealValue(75), kRealValue(30));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, KLeftMargin, kRealValue(10), KLeftMargin);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kRealValue(15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kRealValue(15);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.bounds.size.width, kRealValue(60));
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *header = nil;
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader){
            NSString *CellIdentifier = @"head1";
            header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            
            NSDictionary *lab1Dic =  @{@"text":@"我的频道"};
            UILabel *lab1 = [ZSHBaseUIControl createLabelWithParamDic:lab1Dic];
            [header addSubview:lab1];
            lab1.frame = CGRectMake(KLeftMargin, 0, 100, kRealValue(60));
            
            NSDictionary *btnDic = @{@"title":@"编辑",@"font":kPingFangRegular(12)};
            UIButton *editBtn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
            editBtn.frame = CGRectMake(collectionView.frame.size.width-kRealValue(60), 0, kRealValue(44), kRealValue(60));
            [header addSubview:editBtn];
            [editBtn addTarget:self action:@selector(editTags:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else if (indexPath.section == 1){
        if (kind == UICollectionElementKindSectionHeader){
            NSString *CellIdentifier = @"head2";
            header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
           
            NSDictionary *lab1Dic = @{@"text":@"更多频道"};
            UILabel *lab1 = [ZSHBaseUIControl createLabelWithParamDic:lab1Dic];
            [header addSubview:lab1];
            lab1.frame = CGRectMake(KLeftMargin, 0, 100, kRealValue(60));
        }
    }
    return header;
}

- (void)editTags:(UIButton *)sender{
    
    if (!_onEdit) {
        for (ChannelCell *items in self.collectionView.visibleCells) {
            if (items.model.tagType == MyChannel) {
                if (items.model.resident) {
                    items.delBtn.hidden = YES;
                }else{
                    items.delBtn.hidden = NO;
                }
            }
        }
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        for (ChannelCell *items in self.collectionView.visibleCells) {
            if (items.model.tagType == MyChannel) {
                items.delBtn.hidden = YES;
            }
        }
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
    _onEdit = !_onEdit;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    ChannelCell *cell = (ChannelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (cell.model.resident) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Channel *object= _myTags[sourceIndexPath.item];
    [_myTags removeObjectAtIndex:sourceIndexPath.item];
    if (destinationIndexPath.section == 0) {
        [_myTags insertObject:object atIndex:destinationIndexPath.item];
    }else if (destinationIndexPath.section == 1) {
        object.tagType = RecommandChannel;
        object.editable = NO;
        object.selected = NO;
        [_recommandTags insertObject:object atIndex:destinationIndexPath.item];
        [collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];
    }
    
    [self refreshDelBtnsTag];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSInteger item = 0;
        for (Channel *mod in _myTags) {
            if (mod.selected) {
                mod.selected = NO;
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:item inSection:0]]];
            }
            item++;
        }
        Channel *object = _myTags[indexPath.item];
        object.selected = YES;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        kWeakSelf(self);
                [self dismissViewControllerAnimated:YES completion:^{
                    //单选某个tag
                    if (weakself.selectedTag) {
                        weakself.selectedTag(object);
                    }
                }];
    }else if (indexPath.section == 1) {
        ChannelCell *cell = (ChannelCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.model.editable = YES;
        cell.model.tagType = MyChannel;
        cell.delBtn.hidden = YES;
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [_recommandTags removeObjectAtIndex:indexPath.item];
        [_myTags addObject:cell.model];
        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:_myTags.count-1 inSection:0];
        cell.delBtn.tag = targetIndexPage.item;
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    }
    
    [self refreshDelBtnsTag];
}

-(void)deleteCell:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    ChannelCell *cell = (ChannelCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.model.editable = NO;
    cell.model.tagType = RecommandChannel;
    cell.model.selected = NO;
    cell.delBtn.hidden = YES;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    id object = _myTags[indexPath.item];
    [_myTags removeObjectAtIndex:indexPath.item];
    [_recommandTags insertObject:object atIndex:0];
    NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    [self refreshDelBtnsTag];
}

/** 刷新删除按钮的tag */
- (void)refreshDelBtnsTag{
    
    for (ChannelCell *cell in self.collectionView.visibleCells) {
        NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
        cell.delBtn.tag = indexpath.item;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)returnLast{
    kWeakSelf(self);
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakself.choosedTags) {
            weakself.choosedTags(_myTags,_recommandTags);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
