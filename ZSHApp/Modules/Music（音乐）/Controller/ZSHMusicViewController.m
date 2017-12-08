//
//  ZSHMusicViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicViewController.h"
#import "ZSHMusicLogic.h"
@interface ZSHMusicViewController ()

@property (nonatomic, strong) ZSHMusicLogic  *musicLogic;

@end

@implementation ZSHMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestData];
}


- (void)loadData{
    
    //加载网络数据
    [self requestData];
    
}

- (void)requestData{
    _musicLogic = [[ZSHMusicLogic alloc]init];
    
    [_musicLogic loadRadioListSuccess:^(id responseObject) {
        RLog(@"电台列表数据成功== %@",responseObject);
    } fail:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
