//
//  ZSHMusicLryViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicLryViewController.h"
#import "ZSHMusicLogic.h"
#import "QQLrcCell.h"

@interface ZSHMusicLryViewController ()

/** 记录历史歌词所在的行*/
@property (nonatomic, assign) NSInteger oldScrollRow;

@end


@implementation ZSHMusicLryViewController

#pragma mark --------------------------
#pragma mark 初始

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 去掉线条
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 不给选中
    self.tableView.allowsSelection = NO;
    
    self.oldScrollRow = -1;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    // 增加内边距
    CGFloat insetH = self.tableView.zsh_height * 0.5;
    self.tableView.contentInset = UIEdgeInsetsMake(insetH, 0, insetH, 0);
}

#pragma mark --------------------------
#pragma mark 重写 set 方法
- (void)setDatasource:(NSArray<QQLrcModel *> *)datasource{
    
    _datasource = datasource;
    [self.tableView reloadData];
}

/** 实时滚动到指定的行*/
- (void)setScrollRow:(NSInteger)scrollRow{
    _scrollRow = scrollRow;
    
    if (scrollRow != self.oldScrollRow) {
        
        NSLog(@"当前歌词所在的行: ===== %zd", scrollRow);
        
        // tableView 滚动到指定的行
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scrollRow inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

        self.oldScrollRow = scrollRow;
        [self.tableView reloadData];
    }
}

/** 设置歌词的播放进度*/
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    // 1.获取当前正在播放的 cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.scrollRow inSection:0];
    QQLrcCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // 2.设置播放进度
    cell.progress = progress;
}


#pragma mark --------------------------
#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QQLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QQLrcCellID"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"QQLrcCell" owner:nil options:nil].firstObject;
    }

    // 取出模型
    QQLrcModel *lrcModel = self.datasource[indexPath.row];
    cell.lrcModel = lrcModel;
    
    if (self.scrollRow == indexPath.row) {
        cell.textLabel.textColor = KZSHColorA61CE7;
    } else {
        cell.textLabel.textColor = KWhiteColor;
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
