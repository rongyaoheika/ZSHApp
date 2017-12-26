//
//  ZSHUserInfoViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHUserInfoViewController.h"
#import "ZSHSimpleCellView.h"
#import "ZSHMultiInfoViewController.h"
#import <TZImagePickerController.h>
#import <UIView+Layout.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <TZImageManager.h>
//#import <TZLocationManager.h>
#import "ZSHMineLogic.h"
#import "ZSHPickView.h"
#import "ZSHUserInfoModel.h"


@interface ZSHUserInfoViewController ()<TZImagePickerControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
}
@property (nonatomic, strong) NSArray                 *pushVCsArr;
@property (nonatomic, strong) NSArray                 *paramArr;
@property (nonatomic, strong) NSArray                 *titleArr;
@property (nonatomic, strong) NSArray                 *detailTitleArr;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) ZSHMineLogic            *mineLogic;
@property (nonatomic, strong) UIImage                 *headImage;
@property (nonatomic, copy)   NSString                *changedData;
@property (nonatomic, assign) NSInteger               changedDataIndex; // 第一组
@property (nonatomic, assign) NSInteger               changedSecIndex;
@property (nonatomic, strong) ZSHPickView             *pickView;
@property (nonatomic, strong) ZSHUserInfoModel        *model;

@end
static NSString *ZSHBaseCellID = @"ZSHBaseCell";

@implementation ZSHUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _changedSecIndex = -1;
    self.titleArr = @[@[@"头像",@"昵称",@"姓名",@"性别",@"生日",@"卡号",@"地区",@"个性签名"],
                      @[@"身份证号",@"手机号",@"QQ号码",@"微信",@"新浪微博",@"支付宝"]
                      ];
    self.detailTitleArr = @[@[@"UIImage",@"",@"",@"",@"",@"",@"",@""],
                            @[@"",@"",@"",@"",@"",@""]];
    
    self.pushVCsArr = @[
                        @[@"",@"ZSHMultiInfoViewController",@"",@"",@"",@"",@"",@"ZSHMultiInfoViewController"],
                        @[@"",@"ZSHMultiInfoViewController",@"ZSHMultiInfoViewController",@"",@"",@""]
];
    
    self.paramArr = @[
                      @[@{},
                        @{KFromClassType:@(FromUserInfoNickNameVCToMultiInfoVC),@"title":@"修改昵称",@"rightNaviTitle":@"保存"},
                        @{},@{},@{},@{},@{},
                        @{KFromClassType:@(FromUserInfoResumeVCToMultiInfoVC),@"title":@"修改个性签名",@"rightNaviTitle":@"保存"}],
                      @[@{},
                        @{KFromClassType:@(FromUserInfoPhoneVCToMultiInfoVC),@"title":@"更改手机号码",@"bottomBtnTitle":@"提交"},
                        @{KFromClassType:@(FromUserInfoQQVCToMultiInfoVC),@"title":@"绑定QQ帐号",@"rightNaviTitle":@"授权"},
                        @{},@{},@{}]];
    _mineLogic = [[ZSHMineLogic alloc] init];
    [self initViewModel];
    [self requestData];
}

- (void)createUI{
    self.title = @"个人资料";
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, kScreenWidth, kScreenHeight - KNavigationBarHeight);
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];

}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeFirstSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeSecondSection]];
    [self.tableView reloadData];
}

//第一组
- (ZSHBaseTableViewSectionModel*)storeFirstSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<[self.titleArr[0] count]; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = (i==0? kRealValue(55):kRealValue(43));
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            if (indexPath.row == 0 || indexPath.row == 1|| indexPath.row == 6|| indexPath.row == 7) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (![cell.contentView viewWithTag:29]) { // 需要刷新上传头像
                NSDictionary *nextParamDic = @{@"leftTitle":weakself.titleArr[0][indexPath.row],@"rightTitle":weakself.detailTitleArr[0][indexPath.row],@"row":@(indexPath.row)};
                ZSHSimpleCellView *cellView = [[ZSHSimpleCellView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(43)) paramDic:nextParamDic];

                cellView.tag = 29;
                [cell.contentView addSubview:cellView];
                [cellView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell);
                }];
            }
            ZSHSimpleCellView *cellView = [cell.contentView viewWithTag:29];
            if (weakself.model) {
                [cellView updateViewWithModel:weakself.model index:indexPath.row];
            }
            
            if (indexPath.row == 0) {
                if (weakself.headImage) {
                    [cellView updateHeadImage:weakself.headImage];
                }
            } else {
                if (indexPath.row  == weakself.changedDataIndex) {
                    [cellView updateRightText:weakself.changedData];
                    weakself.changedSecIndex = 0;
                }
            }
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            if (indexPath.row == 0) {
                [weakself selectHeadPortrait];
            } else if (indexPath.row == 1 || indexPath.row == 7) { // 1昵称  7个性签名
                ZSHMultiInfoViewController *multiInfoVC = [[ZSHMultiInfoViewController alloc] initWithParamDic:weakself.paramArr[0][indexPath.row]];
                multiInfoVC.index = indexPath.row;
                multiInfoVC.saveBlock = ^(id str, NSInteger index) {
                    weakself.changedData = str;
                    weakself.changedDataIndex = index;
                    [weakself.tableView reloadRow:index inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                };
                [weakself.navigationController pushViewController:multiInfoVC animated:YES];
            } else if (indexPath.row == 6) { // 地区选择
                weakself.pickView = [weakself createPickViewWithType:WindowRegion];
                weakself.pickView.tag = 6;
                weakself.pickView.saveChangeBlock = ^(NSString *text, NSInteger index) {
                    weakself.changedData = text;
                    weakself.changedDataIndex = index;
                    [weakself requestAddress];
                };
                [weakself.pickView show:WindowRegion];
            }
        };
    }
    return sectionModel;
}

//第二组
- (ZSHBaseTableViewSectionModel*)storeSecondSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(30);

    sectionModel.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(30))];
    sectionModel.headerView.backgroundColor = [UIColor colorWithHexString:@"141414"];
    NSDictionary *headTitleLabelDic = @{@"text":@"以下为非公开信息",@"font":kPingFangRegular(11)};
    UILabel *headLabel =  [ZSHBaseUIControl createLabelWithParamDic:headTitleLabelDic];
    headLabel.frame = CGRectMake(kRealValue(15), 0, kScreenWidth - 2*kRealValue(30), kRealValue(30));
    [sectionModel.headerView addSubview:headLabel];
    
    for (int i = 0; i<[self.titleArr[1] count]; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(43);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            if (indexPath.row > 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (![cell.contentView viewWithTag:2]) {
                NSDictionary *nextParamDic = @{@"leftTitle":weakself.titleArr[1][indexPath.row],@"rightTitle":weakself.detailTitleArr[1][indexPath.row],@"row":@(indexPath.row)};
                ZSHSimpleCellView *cellView = [[ZSHSimpleCellView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(43)) paramDic:nextParamDic];
                cellView.tag = 2;
                [cell.contentView addSubview:cellView];
                [cellView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell);
                }];
            }
            ZSHSimpleCellView *cellView = [cell.contentView viewWithTag:2];
            [cellView updateView2WithModel:weakself.model index:indexPath.row];
            
            if (indexPath.row  == weakself.changedSecIndex) {
                [cellView updateRightText:weakself.changedData];
                weakself.changedSecIndex = -1;
            }
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            Class className = NSClassFromString(self.pushVCsArr[1][indexPath.row]);
            RootViewController *vc = [[className alloc]initWithParamDic:weakself.paramArr[1][indexPath.row]];
            if (indexPath.row==1) {
                ZSHMultiInfoViewController *multiInfoVC = (ZSHMultiInfoViewController *)vc;
                multiInfoVC.index = indexPath.row;
                multiInfoVC.saveBlock = ^(id str, NSInteger index) {
                    weakself.changedData = str;
                    weakself.changedSecIndex = index;
                    [weakself.tableView reloadRow:index inSection:1 withRowAnimation:UITableViewRowAnimationNone];
                };
            }
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    return sectionModel;
}
//
- (void)requestData {
    kWeakSelf(self);
    [_mineLogic requestGetUserInfo:^(id response) {
        weakself.model = response;
        [weakself initViewModel];
    }];
}

// 提交住址
- (void)requestAddress {
    kWeakSelf(self);
    [_mineLogic requestUserInfoWithDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"ADDRESS":_changedData} success:^(id response) {
        [weakself.tableView reloadRow:6 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:cancelAction];
        [weakself presentViewController:ac animated:YES completion:nil];
    }];
}


#pragma pickView
-(ZSHPickView *)createPickViewWithType:(NSUInteger)type{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:@""];
    
    NSArray *areaArr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *provinces = [NSMutableArray array];
    for (NSDictionary *dic in areaArr) {
        [provinces addObject:dic[@"state"]];
    }
    
    NSMutableArray *citys = [NSMutableArray array];
    NSMutableArray *districts = [NSMutableArray array];
    for (NSDictionary *dic in areaArr) {
        if ([dic[@"state"] isEqualToString:@"北京"]) {
            for (NSDictionary *city in dic[@"cities"]) {
                [citys addObject:city[@"city"]];
                if ([city[@"city"] isEqualToString:citys[0]]) {
                    if (city[@"areas"]) {
                        districts = city[@"areas"];
                    }
                }
            }
            break;
        }
        
    }
    
    
    NSMutableArray *regionArr = [NSMutableArray arrayWithObjects:provinces, citys, districts, nil];
    NSDictionary *nextParamDic = @{@"type":@(type),@"midTitle":@"城市区域选择",@"dataArr":regionArr};
    
    _pickView = [[ZSHPickView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:nextParamDic];
    _pickView.controller = self;
    
    return _pickView;
}



- (void)selectHeadPortrait {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    //    if (self.maxCountTF.text.integerValue > 1) {
    //        // 1.设置目前已经选中的图片数组
    //        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    //    }
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // imagePickerVc.photoWidth = 1000;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // if (iOS7Later) {
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // }
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    kWeakSelf(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        weakself.headImage = [photos firstObject];
        [weakself initViewModel];
        [weakself.mineLogic uploadImage:photos name:@[@"showfile"] success:^(id response) {
            weakself.headImage = [photos firstObject];
            [weakself initViewModel];
        }];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}




- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    //    __weak typeof(self) weakSelf = self;
    //    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
    //        weakSelf.location = location;
    //    } failureBlock:^(NSError *error) {
    //        weakSelf.location = nil;
    //    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
