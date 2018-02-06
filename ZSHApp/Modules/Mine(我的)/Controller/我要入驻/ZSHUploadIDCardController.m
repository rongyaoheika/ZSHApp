//
//  ZSHUploadIDCardController.m
//  ZSHApp
//
//  Created by mac on 13/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHUploadIDCardController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ZSHUploadIDCardController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImageView *positiveIV;
@property (nonatomic, strong) UIImageView *negativeIV;
@property (nonatomic, strong) UIImageView *thirdIV;
@property (nonatomic, assign) NSInteger   currentSelect;

@end

@implementation ZSHUploadIDCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    
    if (kFromClassTypeValue == FromIDCardVCToUploadPhotoVC) {
        self.title = @"身份证";
        [self positiveIV:@"uploadID1"];
        [self negativeIV:@"uploadID2"];
    } else if (kFromClassTypeValue == FromStoreVCToUploadPhotoVC){
        self.title = @"店铺照片";
        [self positiveIV:@"store1"];
        [self negativeIV:@"store2"];
        [self thirdIV:@"store3"];
    } else if (kFromClassTypeValue == FromLicenseVCToUploadPhotoVC){
        self.title = @"执照照片";
        [self positiveIV:@"lisence"];
    }
}

- (UIImageView *)positiveIV:(NSString *)name {
    if (!_positiveIV) {
        _positiveIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        _positiveIV.tag = 18011910;
        _positiveIV.userInteractionEnabled = true;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickControlAction)];
        [_positiveIV addGestureRecognizer:tapGR];
        [self.view addSubview:_positiveIV];
        [_positiveIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(KNavigationBarHeight+25);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kRealValue(250), 158));
        }];
    }
    return _positiveIV;
}

- (UIImageView *)negativeIV:(NSString *)name {
    if (!_negativeIV) {
        _negativeIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        _negativeIV.tag = 1801191001;
        _negativeIV.userInteractionEnabled = true;
        UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickControlAction2)];
        [_negativeIV addGestureRecognizer:tapGR2];
        [self.view addSubview:_negativeIV];
        [_negativeIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_positiveIV.mas_bottom).offset(21);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kRealValue(250), 158));
        }];
    }
    return _negativeIV;
}

- (UIImageView *)thirdIV:(NSString *)name {
    if (!_thirdIV) {
        _thirdIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        _thirdIV.tag = 180206104;
        _thirdIV.userInteractionEnabled = true;
        UITapGestureRecognizer *tapGR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickControlAction3)];
        [_thirdIV addGestureRecognizer:tapGR3];
        [self.view addSubview:_thirdIV];
        [_thirdIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_negativeIV.mas_bottom).offset(21);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kRealValue(250), 158));
        }];
    }
    return _thirdIV;
}




- (void)ClickControlAction3 {
    _currentSelect = 3;
}

- (void)ClickControlAction {
    _currentSelect = 0;
    [self takePhoto];
}

- (void)ClickControlAction2 {
    _currentSelect = 1;
    [self takePhoto];
}

// 判断有摄像头，并且支持拍照功能
- (void)takePhoto {
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]){
        // 初始化图片选择控制器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        /*设置媒体来源，即调用出来的UIImagePickerController所显示出来的界面，有一下三种来源
         typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
         UIImagePickerControllerSourceTypePhotoLibrary,
         UIImagePickerControllerSourceTypeCamera,
         UIImagePickerControllerSourceTypeSavedPhotosAlbum
         };分别表示：图片列表，摄像头，相机相册*/
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
        // 设置所支持的媒体功能，即只能拍照，或则只能录像，或者两者都可以
        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
        [controller setMediaTypes:arrMediaTypes];
        // 设置录制视频的质量
        [controller setVideoQuality:UIImagePickerControllerQualityTypeHigh];
        //设置最长摄像时间
        [controller setVideoMaximumDuration:10.f];
        // 设置是否可以管理已经存在的图片或者视频
        [controller setAllowsEditing:YES];
        // 设置代理
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }else {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请打开系统相机权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:cancelAction];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

// 判断是否支持某种多媒体类型：拍照，视频,
- (BOOL)cameraSupportsMedia:(NSString*)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result=NO;
    if ([paramMediaType length]==0) {
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray*availableMediaTypes=[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


- (BOOL)doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 当得到照片或者视频后，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Picker returned successfully.");
    NSLog(@"%@", info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        UIImage *theImage = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的原数据
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if (_currentSelect == 0) {
            
            _positiveIV.image = theImage;
        } else {
            _negativeIV.image = theImage;
        }
    }
    [picker  dismissViewControllerAnimated:YES completion:nil];
}
// 当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker  dismissViewControllerAnimated:YES completion:nil];
}


@end
