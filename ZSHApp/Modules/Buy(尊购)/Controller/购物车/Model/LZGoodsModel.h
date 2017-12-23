//
//  LZGoodsModel.h
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZGoodsModel : NSObject

@property (nonatomic,assign) BOOL select;


@property (copy,nonatomic)NSString *PRODUCTCOUNT;
@property (copy,nonatomic)NSString *PRODUCT_ID;
@property (copy,nonatomic)NSString *PROPRICE;
@property (copy,nonatomic)NSString *PROSHOWIMG;
@property (copy,nonatomic)NSString *PROTITLE;

@end
