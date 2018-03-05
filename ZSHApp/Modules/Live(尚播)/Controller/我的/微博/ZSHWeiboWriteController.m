//
//  ZSHWeiboWriteController.m
//  ZSHApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHWeiboWriteController.h"
#import <TZImageManager.h>
#import "LxGridViewFlowLayout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZLocationManager.h"
#import <TZImagePickerController.h>
#import "TZTestCell.h"
#import <UIView+Layout.h>
#import <TZGifPhotoPreviewController.h>
#import <TZVideoPlayerController.h>
#import "XXTextView.h"
#import "ZSHLiveLogic.h"
#import "ZSHTopicViewController.h"
#import "ZSHPickView.h"

@interface ZSHWeiboWriteController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UIImagePickerController        *imagePickerVc;
@property (strong, nonatomic) UICollectionViewFlowLayout     *layout;

@property (nonatomic, strong) ZSHLiveLogic *liveLogic;
@property (nonatomic, strong) XXTextView   *titleTextView;
@property (nonatomic, strong) XXTextView   *contentTextView;
@property (nonatomic, copy)   NSString     *topic;
@property (nonatomic, copy)   NSString     *topicID;
@property (nonatomic, strong) ZSHPickView  *pickView;
@property (nonatomic, strong) NSArray      *disTypeArr;
@property (nonatomic, strong) NSArray      *typeId;

@end

@implementation ZSHWeiboWriteController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self createUI];
}

- (void)loadData {
    _liveLogic = [[ZSHLiveLogic alloc] init];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    //视频2001  纯文字2002  单图2003  多图2004
    _disTypeArr = @[@"2001",@"2002",@"2003",@"2004"];
    _typeId = self.paramDic[@"typeId"];
    _topic = @"";
    _topicID = @"";
}

- (void)createUI {
    self.title = @"发微博";
    [self addNavigationItemWithTitles:@[@"取消"] isLeft:true target:self action:@selector(cancelAction) tags:@[@(1)]];
    [self addNavigationItemWithTitles:@[@"去发布"] isLeft:NO target:self action:@selector(distributeAction) tags:@[@(2)]];


    _titleTextView = [[XXTextView alloc] init];
    _titleTextView.backgroundColor = KZSHColor181818;
    _titleTextView.textColor = [UIColor whiteColor];
    _titleTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _titleTextView.font = [UIFont systemFontOfSize:15];
    _titleTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (kFromClassTypeValue == FromWordVCToZSHWeiboWriteVC || kFromClassTypeValue == FromPhotoVCToZSHWeiboWriteVC || kFromClassTypeValue == FromVideoVCToZSHWeiboWriteVC) {
        _titleTextView.xx_placeholder = self.paramDic[@"title"];
    } else {
        _titleTextView.xx_placeholder = @"标题";
    }
    _titleTextView.xx_placeholderFont = [UIFont systemFontOfSize:15];
    _titleTextView.xx_placeholderColor = KZSHColor454545;
    [self.view addSubview:_titleTextView];
    [_titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(79));
        make.left.mas_equalTo(self.view).offset(kRealValue(15));
        make.right.mas_equalTo(self.view).offset(kRealValue(-15));
        make.height.mas_equalTo(kRealValue(43.5));
    }];
    
    
    kWeakSelf(self);
    __weak typeof(_titleTextView)weakTitleTextView = _titleTextView;
    _titleTextView.beginEdit = ^{
        if (kFromClassTypeValue == FromWordVCToZSHWeiboWriteVC || kFromClassTypeValue == FromPhotoVCToZSHWeiboWriteVC || kFromClassTypeValue == FromVideoVCToZSHWeiboWriteVC) {
            NSDictionary *nextParamDic = @{@"type":@(WindowDefault),@"midTitle":@"选择",@"dataArr":weakself.paramDic[@"titleArr"]};
            weakself.pickView = [[ZSHPickView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) paramDic:nextParamDic];
            [weakself.pickView show:WindowDefault];
            weakself.pickView.saveChangeBlock = ^(NSString *rowTitle, NSInteger tag,NSDictionary *dic) {
                weakself.titleTextView.xx_placeholder = rowTitle;
                NSDictionary *paramDic = weakself.paramDic[@"paramArr"][tag];
                weakself.typeId = paramDic[@"CAIDAN_ID"];
                
            };
            [weakTitleTextView endEditing:true];
            [weakTitleTextView resignFirstResponder];
        } else {
            ZSHTopicViewController *topicVC = [[ZSHTopicViewController alloc]initWithParamDic:@{KFromClassType:@(FromWeiboVCToTopicVC)}];
            [weakself.navigationController pushViewController:topicVC animated:YES];
            topicVC.didSelectRow = ^(NSString *topicTitle, NSString *topicID) {
                weakTitleTextView.text = NSStringFormat(@"#%@#", topicTitle);
                weakself.title = topicTitle;
                weakself.topicID = topicID;
                weakself.topic = topicTitle;
            };
        }
    };
    
    XXTextView *contentTextView = [[XXTextView alloc] init];
    contentTextView.backgroundColor = KZSHColor181818;
    contentTextView.textColor = [UIColor whiteColor];
    contentTextView.font = [UIFont systemFontOfSize:15];
    contentTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    contentTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    contentTextView.keyboardAppearance = UIKeyboardAppearanceDark;
    contentTextView.xx_placeholder = @"请输入内容";
    contentTextView.xx_placeholderFont = [UIFont systemFontOfSize:15];
    contentTextView.xx_placeholderColor = KZSHColor454545;
    [self.view addSubview:contentTextView];
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {        
        make.top.mas_equalTo(self.view).offset(kRealValue(123));
        make.left.mas_equalTo(self.view).offset(kRealValue(15));
        make.right.mas_equalTo(self.view).offset(kRealValue(-15));
        make.height.mas_equalTo(kRealValue(144));
    }];
    self.contentTextView = contentTextView;
    
    
    if (kFromClassTypeValue == FromWordVCToZSHWeiboWriteVC) {
        
    } else if (kFromClassTypeValue == FromVideoVCToZSHWeiboWriteVC) {
        UILabel *noticeLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"最多支持1个视频上传，点击删除视频",@"font":kPingFangRegular(11),@"textColor":KZSHColor454545,@"textAlignment":@(NSTextAlignmentLeft)}];
        [self.view addSubview:noticeLabel];
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(kRealValue(278.5));
            make.left.mas_equalTo(self.view).offset(kRealValue(25));
            make.size.mas_equalTo(CGSizeMake(kRealValue(200), kRealValue(15)));
        }];
        
        [self configCollectionView];
    } else {
        UILabel *noticeLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"最多支持4张图片上传，点击删除图片",@"font":kPingFangRegular(11),@"textColor":KZSHColor454545,@"textAlignment":@(NSTextAlignmentLeft)}];
        [self.view addSubview:noticeLabel];
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(kRealValue(278.5));
            make.left.mas_equalTo(self.view).offset(kRealValue(25));
            make.size.mas_equalTo(CGSizeMake(kRealValue(200), kRealValue(15)));
        }];
        
        [self configCollectionView];
    }
}


-(ZSHPickView *)createPickViewWithParamDic:(NSDictionary *)paramDic{
    ZSHPickView *pickView = [[ZSHPickView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) paramDic:paramDic];
    pickView.controller = self;
    return pickView;
}

- (void)toolButtonAction:(UIBarButtonItem *)btn {
    
}


- (void)distributeAction {
    kWeakSelf(self);
    if (_contentTextView.text.length) {
        NSMutableArray *fileNames = [NSMutableArray arrayWithCapacity:_selectedAssets.count];
        for (PHAsset *asset in _selectedAssets) {
            [fileNames addObject:[asset valueForKey:@"filename"]];
        }
        
        if (kFromClassTypeValue == FromWordVCToZSHWeiboWriteVC) {

        } else if (kFromClassTypeValue == FromPhotoVCToZSHWeiboWriteVC) {//图片
            NSString *DIS_TYPE = self.disTypeArr[_selectedPhotos.count];
            if (_selectedPhotos.count == 0) {//仅文字
                DIS_TYPE = _disTypeArr[1];
            } else if (_selectedPhotos.count == 1){//单图
                DIS_TYPE = _disTypeArr[2];
            } else if (_selectedPhotos.count > 1){//多图
                DIS_TYPE = _disTypeArr[3];
            }
            
            [_liveLogic requestAddSelfMediaAD:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"TITLE":_contentTextView.text, @"DIS_TYPE":DIS_TYPE, @"CAIDAN_ID":_typeId} images:_selectedPhotos fileNames:fileNames success:^(id response) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [weakself.navigationController popViewControllerAnimated:true];
                }];
                [ac addAction:cancelAction];
                [weakself presentViewController:ac animated:YES completion:nil];
            }];
        } else if (kFromClassTypeValue == FromVideoVCToZSHWeiboWriteVC) {
            [[TZImageManager manager] getVideoOutputPathWithAsset:_selectedAssets.firstObject presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
                NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
                [weakself.liveLogic requestUpVideoWithDic:@{@"DIS_TYPE": _disTypeArr[0], @"TITLE ":_contentTextView.text, @"HONOURUSER_ID":HONOURUSER_IDValue, @"CAIDAN_ID":_typeId} withFilePath:outputPath thumb:_selectedPhotos.firstObject success:^(id response) {
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [weakself.navigationController popViewControllerAnimated:true];
                    }];
                    [ac addAction:cancelAction];
                    [weakself presentViewController:ac animated:YES completion:nil];
                }];
                // Export completed, send video here, send by outputPath or NSData
                // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
            } failure:^(NSString *errorMessage, NSError *error) {
                NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
            }];
            
        } else {
            [_liveLogic requestAddCircle:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"CONTENT":_contentTextView.text, @"TOPIC_ID":_topicID, @"TITLE":_topic} images:_selectedPhotos fileNames:fileNames success:^(id response) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [weakself.navigationController popViewControllerAnimated:true];
                }];
                [ac addAction:cancelAction];
                [weakself presentViewController:ac animated:YES completion:nil];
            }];
        }
        

        
        if ([_topicID isEqualToString:@""] && ![_topic isEqualToString:@""]) {
            [_liveLogic requestAddTopicWithDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue,@"TITLE":_topic} success:^(id response) {
                
            }];
        }
    }
}

- (void)cancelAction {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - 选择图片
- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = KBlackColor;
    self.collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (kFromClassTypeValue == FromWordVCToZSHWeiboWriteVC) {
        
    } else {
        NSInteger contentSizeH = 298.5;
        _margin = 4;
        _itemWH = (self.view.tz_width-30 - 2 * _margin - 4) / 4 - _margin;
        _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        _layout.minimumInteritemSpacing = _margin;
        _layout.minimumLineSpacing = _margin;
        [self.collectionView setCollectionViewLayout:_layout];
        self.collectionView.frame = CGRectMake(15, contentSizeH, self.view.tz_width-30, self.view.tz_height - contentSizeH);
    }
}

- (void)initViewModel {
    
}


- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        if (kSysVersion>7) {
            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (kSysVersion>9) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"entertainment_add"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    // allowPickingGif
    cell.gifLable.hidden = YES;
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        // 内外部拍照
        BOOL showSheet = false;
        if (showSheet) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
            [sheet showInView:self.view];
        } else {
            [self pushTZImagePickerController];
        }
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        // allowPickingGif
        // allowPickingMuitlpleVideoSwitch
        if ([[asset valueForKey:@"filename"] tz_containsString:@"GIF"] && false && YES) {
            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else if (isVideo && false) { // perview video / 预览视频 //allowPickingMuitlpleVideoSwitch
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = 4;
            imagePickerVc.allowPickingGif = false;
            imagePickerVc.allowPickingOriginalPhoto = false;
            imagePickerVc.allowPickingMultipleVideo = false;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            kWeakSelf(self);
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [weakself.collectionView reloadData];
                weakself.collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [self.collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    NSInteger maxImagesCount = 0;
    if (kFromClassTypeValue == FromVideoVCToZSHWeiboWriteVC) {
        maxImagesCount = 1;
    } else {
        maxImagesCount = 4;
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
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
    if (kFromClassTypeValue == FromVideoVCToZSHWeiboWriteVC) { // 视频
        imagePickerVc.allowPickingVideo = true;
        imagePickerVc.allowPickingImage = false;
        imagePickerVc.allowPickingOriginalPhoto = false;
        imagePickerVc.allowPickingGif = false;
        imagePickerVc.allowPickingMultipleVideo = true; // 是否可以多选视频
    } else {
        imagePickerVc.allowPickingVideo = false;
        imagePickerVc.allowPickingImage = true;
        imagePickerVc.allowPickingOriginalPhoto = false;
        imagePickerVc.allowPickingGif = false;
        imagePickerVc.allowPickingMultipleVideo = false; // 是否可以多选视频
    }

    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = true;
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
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/*
 // 设置了navLeftBarButtonSettingBlock后，需打开这个方法，让系统的侧滑返回生效
 - (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
 
 navigationController.interactivePopGestureRecognizer.enabled = YES;
 if (viewController != navigationController.viewControllers[0]) {
 navigationController.interactivePopGestureRecognizer.delegate = nil; // 支持侧滑
 }
 }
 */

#pragma mark - UIImagePickerController

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

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:nil completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (NO) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            imagePicker.needCircleCrop = NO;
                            imagePicker.circleCropRadius = 100;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [self.collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [self.collectionView reloadData];
    // self.collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
//    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
//        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
//        // Export completed, send video here, send by outputPath or NSData
//        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
//    } failure:^(NSString *errorMessage, NSError *error) {
//        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
//    }];
    [self.collectionView reloadData];
    // self.collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [self.collectionView reloadData];
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    /*
     if ([albumName isEqualToString:@"个人收藏"]) {
     return NO;
     }
     if ([albumName isEqualToString:@"视频"]) {
     return NO;
     }*/
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    /*
     if (iOS8Later) {
     PHAsset *phAsset = asset;
     switch (phAsset.mediaType) {
     case PHAssetMediaTypeVideo: {
     // 视频时长
     // NSTimeInterval duration = phAsset.duration;
     return NO;
     } break;
     case PHAssetMediaTypeImage: {
     // 图片尺寸
     if (phAsset.pixelWidth > 3000 || phAsset.pixelHeight > 3000) {
     // return NO;
     }
     return YES;
     } break;
     case PHAssetMediaTypeAudio:
     return NO;
     break;
     case PHAssetMediaTypeUnknown:
     return NO;
     break;
     default: break;
     }
     } else {
     ALAsset *alAsset = asset;
     NSString *alAssetType = [[alAsset valueForProperty:ALAssetPropertyType] stringValue];
     if ([alAssetType isEqualToString:ALAssetTypeVideo]) {
     // 视频时长
     // NSTimeInterval duration = [[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue];
     return NO;
     } else if ([alAssetType isEqualToString:ALAssetTypePhoto]) {
     // 图片尺寸
     CGSize imageSize = alAsset.defaultRepresentation.dimensions;
     if (imageSize.width > 3000) {
     // return NO;
     }
     return YES;
     } else if ([alAssetType isEqualToString:ALAssetTypeUnknown]) {
     return NO;
     }
     }*/
    return YES;
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}
#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        // NSLog(@"图片名字:%@",fileName);
    }
}


@end
