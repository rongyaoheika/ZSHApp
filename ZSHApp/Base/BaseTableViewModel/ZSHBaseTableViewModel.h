//
//  ZSHBaseTableViewModel.h
//  SigmaTableViewModel
//
//  Created by yangke on 8/25/15.
//  Copyright (c) 2015 yangke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZSHBaseTableViewSectionModel.h"

/**
 *  ZSHBaseTableViewModel implements some methods in UITableViewDelegate & UITableViewDataSource.
 *  it can be used as the delegate & dataSource of a tableView.
 *  For those methods it doesn't implement, you can implement them in its subclass.
 */
@interface ZSHBaseTableViewModel : NSObject <UITableViewDelegate, UITableViewDataSource>
/** table view's section model array */
@property (nonatomic, strong) NSMutableArray<ZSHBaseTableViewSectionModel *> *sectionModelArray;

@end
