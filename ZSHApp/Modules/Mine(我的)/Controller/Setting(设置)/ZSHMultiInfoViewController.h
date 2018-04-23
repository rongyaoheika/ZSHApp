//
//  ZSHMultiInfoViewController.h
//  RLJKApp
//
//  Created by zhaoweiwei on 2017/9/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"
#import "ZSHEntryLogic.h"


typedef void(^SaveBlock)(id , NSInteger );

@interface ZSHMultiInfoViewController : RootViewController

@property (nonatomic, copy)   SaveBlock saveBlock;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) ZSHEntryLogic      *entryLogic;   //商家入驻

@property (nonatomic, copy) NSString *text1;    // 第一行的内容
@property (nonatomic, copy) NSString *text2;    // 第二行的内容
@property (nonatomic, copy) NSString *text3;
@property (nonatomic, copy) NSString *text4;
@property (nonatomic, copy) NSString *text5;
@property (nonatomic, copy) NSString *text6;
@property (nonatomic, copy) NSString *text7;

@property (nonatomic, copy) NSString *imageText1;
@property (nonatomic, copy) NSString *imageText2;
@property (nonatomic, copy) NSString *imageText3;

@property (nonatomic, strong) NSMutableDictionary       *storeDic;// 门店参数
@end
