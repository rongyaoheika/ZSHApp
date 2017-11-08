//
//  ZSHBaseTableViewCellModel.h
//  SigmaTableViewModel
//
//  Created by yangke on 8/25/15.
//  Copyright (c) 2015 yangke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UITableViewCell * (^ZSHCellRenderBlock)(NSIndexPath *indexPath, UITableView *tableView);
typedef NSIndexPath * (^ZSHCellWillSelectBlock)(NSIndexPath *indexPath, UITableView *tableView);
typedef void (^ZSHCellSelectionBlock)(NSIndexPath *indexPath, UITableView *tableView);
typedef void (^ZSHCellWillDisplayBlock)(UITableViewCell *cell, NSIndexPath *indexPath, UITableView *tableView);
typedef void (^ZSHCellCommitEditBlock)(NSIndexPath *indexPath, UITableView *tableView,
                                       UITableViewCellEditingStyle editingStyle);

/** Table view's row model */
@interface ZSHBaseTableViewCellModel : NSObject

@property (nonatomic, copy) ZSHCellRenderBlock renderBlock;            // required
@property (nonatomic, copy) ZSHCellWillDisplayBlock willDisplayBlock;  // optional
@property (nonatomic, copy) ZSHCellWillSelectBlock willSelectBlock;    // optional
@property (nonatomic, copy) ZSHCellWillSelectBlock willDeselectBlock;  // optional
@property (nonatomic, copy) ZSHCellSelectionBlock selectionBlock;      // optional
@property (nonatomic, copy) ZSHCellSelectionBlock deselectionBlock;    // optional
@property (nonatomic, copy) ZSHCellCommitEditBlock commitEditBlock;    // optional
// if not specified, will use UITableViewAutomaticDimension as default value
@property (nonatomic, assign) CGFloat height;  // optional
@property (nonatomic, assign) BOOL canEdit;    // default NO
//@property (nonatomic, assign) BOOL canMove;   //default NO
@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;  // cell's editing style
@property (nonatomic, copy) NSString *deleteConfirmationButtonTitle;  // delete confirmation title

@end
