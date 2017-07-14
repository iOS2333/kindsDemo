//
//  OCRViewController.m
//  AllKindsDemo
//
//  Created by kangjia on 2017/5/12.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import "OCRViewController.h"
#import <TesseractOCR/TesseractOCR.h>
@interface OCRViewController ()
{
    CGRect imageview_frame;
    UIImageView *new_image_view;
    UIActivityIndicatorView *activityIndicatorView;
    UIButton *btn;

}
@property(nonatomic,strong)UITextView *textview;
@property(nonatomic,strong)UIImageView *img_view;
;

@end

@implementation OCRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
 
    [btn setTitle:@"选择识别的图片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(screen_wid/2 - 100, screen_height/2 - 150 - 64, 200, 80);
    [btn addTarget:self action:@selector(btnSelect) forControlEvents:UIControlEventTouchUpInside];
}
-(UIImageView *)img_view{
    
    if (_img_view == nil) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        _img_view = [[UIImageView alloc] init];
        
        _img_view.userInteractionEnabled = YES;
        _img_view.frame = CGRectMake(screen_wid/2 - 50, btn.frame.origin.y + btn.frame.size.height, 100, 100);
        [_img_view addGestureRecognizer:tap];
        [self.view addSubview:_img_view];
  
    }
    
    return _img_view;
}
-(UITextView *)textview{
    if (_textview == nil) {
        _textview = [[UITextView alloc] init];
        [self.view addSubview:_textview];
        _textview.textColor = [UIColor purpleColor];
        _textview.editable = NO;
        _textview.frame = CGRectMake(screen_wid/2 - 100, self.img_view.frame.origin.y + self.img_view.frame.size.height+40, 200, 100);
        _textview.backgroundColor = [UIColor lightGrayColor];

    }
    return _textview;
}
#pragma mark - 放大图片
- (void)tapClick:(UITapGestureRecognizer *)tap{
    //添加覆盖层
    UIView *convertView = [[UIView alloc] initWithFrame:CGRectMake(0,0 , screen_wid, screen_height)];
    convertView.backgroundColor = [UIColor clearColor];
    
    UIVisualEffectView *vef = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    vef.frame = convertView.bounds;
    vef.alpha = 1;
    [convertView addSubview:vef];
    
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;//图片点击时整个窗口不能点
    [convertView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(convertClick:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:convertView];
    
    UIImageView *newImageView = [[UIImageView alloc] init];
    UIImageView *oldImgeView = [[UIImageView alloc] init];
    oldImgeView = (UIImageView *)tap.view;
    
    newImageView.image = oldImgeView.image;
    
    /**
     *  坐标转换
     */
    newImageView.frame = [self.view convertRect:oldImgeView.frame toView:convertView];
    
    imageview_frame = newImageView.frame;
    new_image_view = newImageView;
    
    [convertView addSubview:newImageView];
    
    [UIView animateWithDuration:0.2 animations:^{//放大
        CGRect frame = newImageView.frame;
        
        frame.size.width = convertView.frame.size.width;
        frame.size.height = frame.size.width *(oldImgeView.frame.size.height/oldImgeView.frame.size.width);
        frame.origin.x = 0;
        frame.origin.y = convertView.frame.size.height/2 - frame.size.height/2;
        newImageView.frame = frame;
    } completion:^(BOOL finished) {
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    }];
    
    
    
    
}
- (void)convertClick:(UITapGestureRecognizer *)tap{
    UIView *c_view = tap.view;
    
    [UIView animateWithDuration:0.3 animations:^{//缩小
        
        c_view.backgroundColor = [UIColor clearColor];
        
        new_image_view.frame = imageview_frame;
        
        
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
        
      [self add_activityIndicatorView];
      [self performSelector:@selector(recognize_tesseract) withObject:nil afterDelay:1];
    }];
    
    
    
}
-(void)add_activityIndicatorView{
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake(screen_wid/2 - 30, self.textview.frame.origin.y + self.textview.frame.size.height/2 - 30, 60, 60);
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
}
- (void)remove_activityIndicatorView{
    if (activityIndicatorView.isAnimating) {
        [activityIndicatorView stopAnimating];
    }
    [activityIndicatorView removeFromSuperview];
}
- (void)recognize_tesseract{
    
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];//识别语言
    tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;//识别模式
    tesseract.maximumRecognitionTime = 60.0;//识别时间
    tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;//识别方式
    tesseract.image = self.img_view.image.g8_blackAndWhite;
    
    [tesseract recognize];
    self.textview.text = tesseract.recognizedText;
    NSLog(@"%@",tesseract.recognizedText);
    self.textview.scrollEnabled = YES;
    [self remove_activityIndicatorView];
}
- (void)btnSelect{
    
    
    UIActionSheet *ac;
    if ([self isHaveCamera]) {
        ac = [[UIActionSheet alloc] initWithTitle:@"选择照片的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择",@"拍照", nil];
    }else{
        ac = [[UIActionSheet alloc] initWithTitle:@"选择照片的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择", nil];
    }
    
    [ac showInView:self.view];
}

-(BOOL)isHaveCamera{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    }
    return NO;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"---%zd",buttonIndex);
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if (buttonIndex == 0) {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:^{
            
        }];
    }else if(buttonIndex == 1){
        if (![self isHaveCamera]) {
            
        }else{
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.delegate = self;
            [self presentViewController:ipc animated:YES completion:^{
                
            }];
 
        }
    }else{
        
    }
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%@",info);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            self.img_view.image = [self scaleImage:img maxDimension:640];
            
//            url = [[NSString alloc] initWithFormat:@"%@",[info objectForKey:@"UIImagePickerControllerReferenceURL"]];;
        });
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImage *)scaleImage:(UIImage *)image maxDimension:(CGFloat )maxDimension{
    CGSize scaledSize = CGSizeMake(maxDimension, maxDimension);
    CGFloat scaleFactor;
    
    if (image.size.width > image.size.height) {
        scaleFactor = image.size.height/image.size.width;
        scaledSize.width = maxDimension;
        scaledSize.height = scaledSize.width *scaleFactor;
    }else{
        scaleFactor = image.size.width/image.size.height;
        scaledSize.height = maxDimension;
        scaledSize.width = scaledSize.height * scaleFactor;
    }
    UIGraphicsBeginImageContext(scaledSize);
    [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
