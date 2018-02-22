//
//  ZSHUploadIDCardController.m
//  ZSHApp
//
//  Created by mac on 13/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHUploadIDCardController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ZSHUploadIDCardController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UIImageView       *positiveIV;
@property (nonatomic, strong) UIImageView       *negativeIV;
@property (nonatomic, strong) UIImageView       *thirdIV;
@property (nonatomic, assign) NSInteger         currentSelect;
@property (nonatomic, strong) NSMutableArray    *imageMArr;

@property (nonatomic, assign) BOOL   isFinished;
@property (nonatomic, assign) BOOL   isShow;

@property (nonatomic, strong) NSString      *imagHeadPath;
@property (nonatomic, strong) NSString      *positiveImagPath;
@property (nonatomic, strong) NSString      *negativeImagPath;
@property (nonatomic, strong) NSString      *thirdImagPath;
@property (nonatomic, strong) UIImage       *positiveImg;
@property (nonatomic, strong) UIImage       *negativeImg;
@property (nonatomic, strong) UIImage       *thirdImg;

@end

@implementation ZSHUploadIDCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFinished = NO;
    _imageMArr = [[NSMutableArray alloc]init];
    [self loadData];
    [self createUI];
    
}

- (void)loadData{
    _imagHeadPath = self.paramDic[@"imgPath"];
    _positiveImagPath = [NSString stringWithFormat:@"%@positiveImg.jpg",_imagHeadPath];
    _negativeImagPath = [NSString stringWithFormat:@"%@negativeImg.jpg",_imagHeadPath];
    _thirdImagPath = [NSString stringWithFormat:@"%@thirdImg.jpg",_imagHeadPath];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _positiveImg = [[UIImage alloc]initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@",_positiveImagPath]]];
    _negativeImg = [[UIImage alloc]initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@",_negativeImagPath]]];
    _thirdImg = [[UIImage alloc]initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@",_thirdImagPath]]];
    
    switch (kFromClassTypeValue) {
        case FromIDCardVCToUploadPhotoVC:{
            _positiveIV.image = _positiveImg?_positiveImg:[UIImage imageNamed:@"uploadID1"];;
            _negativeIV.image = _negativeImg?_negativeImg:[UIImage imageNamed:@"uploadID2"];
            break;
        }
        case FromStoreVCToUploadPhotoVC:{
            _positiveIV.image = _positiveImg?_positiveImg:[UIImage imageNamed:@"store1"];
            _negativeIV.image = _negativeImg?_negativeImg:[UIImage imageNamed:@"store2"];
            _thirdIV.image = _thirdImg?_thirdImg:[UIImage imageNamed:@"store3"];
            break;
        }
        case FromLicenseVCToUploadPhotoVC:{
            _positiveIV.image = _positiveImg?_positiveImg:[UIImage imageNamed:@"lisence"];
            break;
        }
            
        default:
            break;
    }

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
    [self doChoose];
}

- (void)ClickControlAction {
    _currentSelect = 0;
    [self doChoose];
}

- (void)ClickControlAction2 {
    _currentSelect = 1;
    [self doChoose];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    switch (kFromClassTypeValue) {
        case FromIDCardVCToUploadPhotoVC:{
            self.isFinished = _positiveImg&&_negativeImg;
            
            break;
        }
        case FromStoreVCToUploadPhotoVC:{
            self.isFinished = _positiveImg&&_negativeImg&&_thirdImg;
            break;
        }
        case FromLicenseVCToUploadPhotoVC:{
            self.isFinished = _positiveImg;
            break;
        }

        default:
            break;
    }
    
    //    //将图片变为Base64格式，可以将数据通过接口传给后台
    //    NSData *data = UIImageJPEGRepresentation(saveImage, 1.0f);
    //    NSString *baseString = [data base64Encoding];

    if ((self.viewWillDisAppearBlock) && (kFromClassTypeValue<3)) {
        self.viewWillDisAppearBlock(self.isFinished,_positiveImg,_negativeImg,_thirdImg,_positiveImagPath,_negativeImagPath,_thirdImagPath);
    }
}

//新功能写入
- (void)doChoose {
    UIActionSheet *sheet;
    //检查是否有摄像头功能
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        sheet = [[UIActionSheet alloc]
                 initWithTitle:nil
                 delegate:self
                 cancelButtonTitle:@"取消"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"拍照",@"从相册选择", nil];
    } else {
        sheet = [[UIActionSheet alloc]
                 initWithTitle:nil
                 delegate:self
                 cancelButtonTitle:@"取消"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag=255;
    [sheet showInView:self.view];
}

//代理方法，启用拍照或使用相册功能
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if (buttonIndex == actionSheet.cancelButtonIndex) return;
           
            switch (buttonIndex) {
                case 0:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                default:
                    break;
            }
        } else {
           if (buttonIndex == actionSheet.cancelButtonIndex) return;
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

//返回的图片数据
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //返回到主界面中
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //获取返回的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //压缩图片
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
   
    //沙盒，准备保存的图片地址和图片名称
    NSString *fullPath = nil;
    switch (_currentSelect) {//第几张图片
        case 0:{
            fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@",_positiveImagPath]];
            break;
        }
        case 1:{
            fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@",_negativeImagPath]];
            break;
        }
        case 3:{
            fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@",_thirdImagPath]];
            break;
        }
            
        default:
            break;
    }

    //将图片写入文件中
    [imageData writeToFile:fullPath atomically:NO];
}
//关闭拍照窗口
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


@end
