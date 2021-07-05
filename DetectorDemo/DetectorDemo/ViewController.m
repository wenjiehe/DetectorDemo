//
//  ViewController.m
//  DetectorDemo
//
//  Created by 贺文杰 on 2021/6/30.
//

#import "ViewController.h"
#import <CoreImage/CIDetector.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self analysisQRCode];
    [self analysisText];
}

/**
    CIDetectorTypeFace             面部识别
    CIDetectorTypeRectangle     矩形识别
    CIDetectorTypeQRCode       条码识别
    CIDetectorTypeText              文本识别
 
    CIDetectorAccuracy                 识别精度
    CIDetectorAccuracyLow           低精度，识别速度快
    CIDetectorAccuracyHigh          高精度，识别速度慢
    CIDetectorTracking                   是否开启面部追踪
    CIDetectorMinFeatureSize        指定最小尺寸的检测器，小于这个尺寸的特征将不识别，
    CIDetectorMaxFeatureCount    设置返回矩形特征的最多个数 1~256 默认值是1
    CIDetectorNumberOfAngles     设置角度的个数1，3，5，7，9，11
    CIDetectorImageOrientation     识别方向
    CIDetectorEyeBlink                   眨眼特征
    CIDetectorSmile                        笑脸特征
    CIDetectorFocalLength             每帧焦距
    CIDetectorAspectRatio             矩形宽高比
    CIDetectorReturnSubFeatures  文本检测器是否应该检测子特征，默认值是NO

 */


- (void)analysisQRCode
{
    //创建图形上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    NSDictionary *param = [NSDictionary dictionaryWithObject:CIDetectorTypeQRCode forKey:CIDetectorAccuracyHigh];
    //创建识别器对象
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:param];
    UIImage *image = [UIImage imageNamed:@"text"];
    //取得识别结果
    NSArray *ary = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (ary.count == 0) {
        NSLog(@"暂未识别出二维码");
    }else{
        for (CIQRCodeFeature *feature in ary) {
            NSString *str = feature.messageString;
            NSLog(@"str = %@", str);
        }
    }
}

- (void)analysisText
{
    UIImage *image = [UIImage imageNamed:@"content"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:imageView];
    //创建图形上下文
//    CIContext *context = [CIContext contextWithOptions:nil];
    NSDictionary *p = @{CIDetectorTypeText : CIDetectorAccuracyHigh};
    //创建识别器对象
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeText context:nil options:p];
    //取得识别结果
    
    /* The intended display orientation of the image. If present, the value
     * of this key is a CFNumberRef with the same value as defined by the
     * TIFF and Exif specifications.  That is:
     *   1  =  0th row is at the top, and 0th column is on the left.
     *   2  =  0th row is at the top, and 0th column is on the right.
     *   3  =  0th row is at the bottom, and 0th column is on the right.
     *   4  =  0th row is at the bottom, and 0th column is on the left.
     *   5  =  0th row is on the left, and 0th column is the top.
     *   6  =  0th row is on the right, and 0th column is the top.
     *   7  =  0th row is on the right, and 0th column is the bottom.
     *   8  =  0th row is on the left, and 0th column is the bottom.
     * If not present, a value of 1 is assumed. */
    //CIDetectorImageOrientation使用kCGImagePropertyOrientation
    NSArray *ary = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage] options:@{CIDetectorReturnSubFeatures : @YES}];
//    NSArray *ary = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage] options:nil];
    if (ary.count == 0) {
        NSLog(@"暂未识别出二维码");
    }else{
        NSInteger count = 0;
        for (CIFeature *feature in ary) {
            if ([feature isKindOfClass:[CITextFeature class]]) {
                count++;
                CITextFeature *textFeature = (CITextFeature *)feature;
                NSLog(@"x = %.f, y = %.f, width = %.f, height = %.f, count = %ld", textFeature.bounds.origin.x, textFeature.bounds.origin.y, textFeature.bounds.size.width, textFeature.bounds.size.height, (long)count);
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(textFeature.bounds.origin.x, textFeature.bounds.origin.y - textFeature.bounds.size.height , textFeature.bounds.size.width, textFeature.bounds.size.height)];
                view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.25];
                [imageView addSubview:view];
            }else if ([feature isKindOfClass:[CIQRCodeFeature class]]){
                CIQRCodeFeature *qrFeature = (CIQRCodeFeature *)feature;
                NSLog(@"str = %@", qrFeature.messageString);
            }
        }
    }

}

- (void)analysisFace
{
    //创建图形上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    NSDictionary *param = [NSDictionary dictionaryWithObject:CIDetectorTypeFace forKey:CIDetectorAccuracyHigh];
    //创建识别器对象
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:param];
    UIImage *image = [UIImage imageNamed:@"text"];
    //取得识别结果
    NSArray *ary = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (ary.count == 0) {
        NSLog(@"暂未识别出二维码");
    }else{
        for (CIQRCodeFeature *feature in ary) {
            NSString *str = feature.messageString;
            NSLog(@"str = %@", str);
        }
    }
}



@end
