//
//  ViewController.m
//  FaceDemo
//
//  Created by L on 16/4/11.
//  Copyright © 2016年 L. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h> 
#import <UIKit/UIKit.h>

@interface ViewController ()
@property (nonatomic, strong) NSArray *features;
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* image = [UIImage imageNamed:@"梁朝伟"];
    _imgView = [[UIImageView alloc] initWithImage: image];
    [_imgView setFrame:CGRectMake(0, 0, _imgView.image.size.width,_imgView.image.size.height)];
    _imgView.center = self.view.center;
    [self.view addSubview:_imgView];

    [self faceTextByImage:image];
}

- (void)faceTextByImage:(UIImage *)image{

    //识别图片:
    CIImage *ciimage = [CIImage imageWithCGImage:image.CGImage];
    //设置识别参数
    NSDictionary* opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    //声明一个CIDetector，并设定识别类型
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                            context:nil options:opts];
    //取得识别结果
    NSArray* features = [detector featuresInImage:ciimage];
    UIView *resultView = [[UIView alloc] initWithFrame:_imgView.frame];
    [self.view addSubview:resultView];
    //标出脸部,眼睛和嘴:
    for (CIFaceFeature *faceFeature in features){
        // 标出脸部
        CGFloat faceWidth = faceFeature.bounds.size.width;
        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        [resultView addSubview:faceView];
        // 标出左眼
        if(faceFeature.hasLeftEyePosition) {
            UIView* leftEyeView = [[UIView alloc] initWithFrame:
                                   CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15,
                                              faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            [leftEyeView setCenter:faceFeature.leftEyePosition];
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            [resultView addSubview:leftEyeView];
        }
        // 标出右眼
        if(faceFeature.hasRightEyePosition) {
            UIView* rightEyeView = [[UIView alloc] initWithFrame:
                               CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15,
                                          faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            [rightEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            [rightEyeView setCenter:faceFeature.rightEyePosition];
            rightEyeView.layer.cornerRadius = faceWidth*0.15;
            [resultView addSubview:rightEyeView];
        }
        // 标出嘴部
        if(faceFeature.hasMouthPosition) {
            UIView* mouth = [[UIView alloc] initWithFrame:
                             CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2,
                                        faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
            [mouth setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
            [mouth setCenter:faceFeature.mouthPosition];
            mouth.layer.cornerRadius = faceWidth*0.2;
            [resultView addSubview:mouth];
        }
    }
    //得到的坐标点中，y值是从下开始的。比如说图片的高度为300，左眼的y值为100，说明左眼距离底部的高度为100，换成我们习惯的，距离顶部的距离就是200，这一点需要注意
    [resultView setTransform:CGAffineTransformMakeScale(1, -1)];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
