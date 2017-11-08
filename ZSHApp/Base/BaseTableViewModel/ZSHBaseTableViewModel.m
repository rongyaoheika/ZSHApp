//
//  ZSHBaseTableViewModel.m
//  SigmaTableViewModel
//
//  Created by yangke on 8/25/15.
//  Copyright (c) 2015 yangke. All rights reserved.
//

#import "ZSHBaseTableViewModel.h"

@implementation ZSHBaseTableViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sectionModelArray = [NSMutableArray array];
    }
    return self;
}

- (ZSHBaseTableViewSectionModel*)sectionModelAtSection:(NSInteger)section {
    @try {
        ZSHBaseTableViewSectionModel *sectionModel = self.sectionModelArray[section];
        return sectionModel;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (ZSHBaseTableViewCellModel*)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        ZSHBaseTableViewSectionModel *sectionModel = self.sectionModelArray[indexPath.section];
        ZSHBaseTableViewCellModel *cellModel = sectionModel.cellModelArray[indexPath.row];
        return cellModel;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSHBaseTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    return cellModel.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ZSHBaseTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.headerHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ZSHBaseTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.footerHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZSHBaseTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    ZSHViewRenderBlock headerViewRenderBlock = sectionModel.headerViewRenderBlock;
    if (headerViewRenderBlock) {
        return headerViewRenderBlock(section, tableView);
    } else {
        return sectionModel.headerView;
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ZSHBaseTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    ZSHViewRenderBlock footerViewRenderBlock = sectionModel.footerViewRenderBlock;
    if (footerViewRenderBlock) {
        return footerViewRenderBlock(section, tableView);
    } else {
        return sectionModel.footerView;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = KClearColor;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = KClearColor;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView
           willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSHBaseTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    ZSHCellWillSelectBlock willSelectBlock = cellModel.willSelectBlock;
    ;
    if (willSelectBlock) {
        return willSelectBlock(indexPath, tableView);
    }
    return indexPath;
}
- (nullable NSIndexPath *)tableView:(UITableView *)tableView
         willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSHBaseTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    ZSHCellWillSelectBlock willDeselectBlock = cellModel.willDeselectBlock;
    ;
    if (willDeselectBlock) {
        return willDeselectBlock(indexPath, tableView);
    }
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSHBaseTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    ZSHCellSelectionBlock selectionBlock = cellModel.selectionBlock;
    if (selectionBlock) {
        selectionBlock(indexPath, tableView);
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSHBaseTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    ZSHCellSelectionBlock deselectionBlock = cellModel.deselectionBlock;
    if (deselectionBlock) {
        deselectionBlock(indexPath, tableView);
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
     ZSHBaseTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    return cellModel.deleteConfirmationButtonTitle;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionModelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZSHBaseTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.cellModelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSHBaseTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    UITableViewCell *cell = nil;
    ZSHCellRenderBlock renderBlock = cellModel.renderBlock;
    if (renderBlock) {
        cell = renderBlock(indexPath, tableView);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSHBaseTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    ZSHCellWillDisplayBlock willDisplayBlock = cellModel.willDisplayBlock;
    if (willDisplayBlock) {
        willDisplayBlock(cell, indexPath, tableView);
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ZSHBaseTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.headerTitle;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    ZSHBaseTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.footerTitle;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSHBaseTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    return cellModel.canEdit;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    ZSHBaseTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    ZSHCellCommitEditBlock commitEditBlock = cellModel.commitEditBlock;
    if (commitEditBlock) {
        commitEditBlock(indexPath, tableView, editingStyle);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 36;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


@end
