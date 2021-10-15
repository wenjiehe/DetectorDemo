//
//  ViewController.m
//  DetectorDemo
//
//  Created by 贺文杰 on 2021/6/30.
//

#import "ViewController.h"
#import <CoreImage/CIDetector.h>
#import "VisionKitManager.h"

typedef NS_ENUM(NSUInteger, faceType) {
    faceTypeLeftEye,
    faceTypeRightEye,
    faceTypeMouth,
    faceTypeFace,
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //解析二维码
//    [self analysisQRCode];
    
    //检测文本区域
//    [self analysisText];
    
    //检测人脸
//    [self analysisFace];
    
    //检测条形码
//    [self analysisRectangle];
    
    //扫描文档转化为图片
    [VisionKitManager cameraScanDocument:self];
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

#pragma mark ---- 解析二维码
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

#pragma mark ----- 检测文本区域
- (void)analysisText
{
    UIImage *image = [UIImage imageNamed:@"content"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
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
        for (NSInteger i = ary.count - 1; i >= 0; i--) {
            CIFeature *feature = ary[i];
            CITextFeature *textFeature = (CITextFeature *)feature;
            NSLog(@"x = %.f, y = %.f, width = %.f, height = %.f, count = %ld", textFeature.bounds.origin.x, textFeature.bounds.origin.y, textFeature.bounds.size.width, textFeature.bounds.size.height, (long)count);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(textFeature.bounds.origin.x, textFeature.bounds.origin.y, textFeature.bounds.size.width, textFeature.bounds.size.height)];
            view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.25];
            [self.view addSubview:view];
        }
    }
}

#pragma mark ----- 检测人脸
- (void)analysisFace
{
    //创建图形上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    NSDictionary *param = [NSDictionary dictionaryWithObject:CIDetectorTypeFace forKey:CIDetectorAccuracyHigh];
    //创建识别器对象
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:param];
    UIImage *image = [UIImage imageNamed:@"liuyifei.jpeg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width - 40, 450);
    [self.view addSubview:imageView];

    //取得识别结果
    NSArray *ary = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage] options:@{CIDetectorSmile : @YES, CIDetectorEyeBlink : @YES}];
    if (ary.count == 0) {
        NSLog(@"暂未识别出二维码");
    }else{
        for (CIFaceFeature *feature in ary) {
            NSLog(@"bounds = %@", NSStringFromCGRect(feature.bounds)); //图像坐标中的人脸位置和尺寸
            NSLog(@"hasLeftEyePosition = %d", feature.hasLeftEyePosition); //检测器是否找到了人脸的左眼
            NSLog(@"leftEyePosition = %@", NSStringFromCGPoint(feature.leftEyePosition)); //左眼的坐标
            NSLog(@"hasRightEyePosition = %d", feature.hasRightEyePosition); //检测器是否找到了人脸的右眼
            NSLog(@"rightEyePosition = %@", NSStringFromCGPoint(feature.rightEyePosition)); //右眼的坐标
            NSLog(@"hasMouthPosition = %d", feature.hasMouthPosition); //检测器是否找到了人脸的嘴巴
            NSLog(@"mouthPosition = %@", NSStringFromCGPoint(feature.mouthPosition)); //嘴巴的坐标
            NSLog(@"hasTrackingID = %d", feature.hasTrackingID); //面部对象是否具有跟踪ID
            NSLog(@"trackingID = %d ", feature.trackingID); //跟踪ID
            NSLog(@"hasTrackingFrameCount = %d", feature.hasTrackingFrameCount); //面部对象的布尔值具有跟踪帧计数
            NSLog(@"trackingFrameCount = %d", feature.trackingFrameCount); //跟踪帧计数
            NSLog(@"hasFaceAngle = %d", feature.hasFaceAngle); //是否有关于脸部旋转的信息
            NSLog(@"faceAngle = %.f", feature.faceAngle); //旋转是以度数逆时针测量的，其中零指示在眼睛之间画出的线是相对于图像方向是水平的
            NSLog(@"hasSmile = %d", feature.hasSmile); //是否有笑脸
            NSLog(@"leftEyeClosed = %d", feature.leftEyeClosed); //左眼是否闭上
            NSLog(@"rightEyeClosed = %d", feature.rightEyeClosed); //右眼是否闭上
            
            UIView *redView = [self getRedView];
            redView.frame = [self getConvertedRect:feature type:faceTypeFace image:image];
            [imageView addSubview:redView];
            
            if (feature.hasLeftEyePosition){
                UIView *leftView = [self getRedView];
                leftView.frame = [self getConvertedRect:feature type:faceTypeLeftEye image:image];
                [imageView addSubview:leftView];
            }
            if (feature.hasRightEyePosition){
                UIView *rightView = [self getRedView];
                rightView.frame = [self getConvertedRect:feature type:faceTypeRightEye image:image];
                [imageView addSubview:rightView];
            }
            if (feature.hasMouthPosition){
                UIView *mouthView = [self getRedView];
                mouthView.frame = [self getConvertedRect:feature type:faceTypeMouth image:image];
                [imageView addSubview:mouthView];
            }
        }
    }
}

- (UIView *)getRedView
{
    UIView *redView = [[UIView alloc] init];
    redView.layer.borderColor = [UIColor redColor].CGColor;
    redView.layer.borderWidth = 2;
    return redView;
}

- (CGRect)getConvertedRect:(CIFaceFeature *)faceFeature type:(faceType)faceT image:(UIImage *)img
{
    CGRect faceRect = faceFeature.bounds;
    switch (faceT){
        case faceTypeLeftEye:
        {
            faceRect.origin = faceFeature.leftEyePosition;
            faceRect.size = CGSizeMake(faceFeature.bounds.size.width * 1/6, faceFeature.bounds.size.height * 1/6);
            faceRect.origin.x -= faceRect.size.width/2;
            faceRect.origin.y -= faceRect.size.height/2;
        }
            break;
        case faceTypeRightEye:
        {
            faceRect.origin = faceFeature.rightEyePosition;
            faceRect.size = CGSizeMake(faceFeature.bounds.size.width * 1/6, faceFeature.bounds.size.height * 1/6);
            faceRect.origin.x -= faceRect.size.width/2;
            faceRect.origin.y -= faceRect.size.height/2;
        }
            break;
        case faceTypeMouth:
        {
            faceRect.origin = faceFeature.mouthPosition;
            faceRect.size = CGSizeMake(faceFeature.bounds.size.width * 1/3, faceFeature.bounds.size.height * 1/6);
            faceRect.origin.x -= faceRect.size.width/2;
            faceRect.origin.y -= faceRect.size.height;
        }
            break;
        default:
            break;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat height = 450;
    CGFloat widthPer = width / img.size.width;
    CGFloat heightPer = height / img.size.height;
    
    faceRect.origin.x = img.size.width - faceRect.origin.x - faceRect.size.width + 20;
    faceRect.origin.y = img.size.height - faceRect.origin.y - faceRect.size.height;
    
    faceRect.origin.x = faceRect.origin.x * widthPer;
    faceRect.origin.y = faceRect.origin.y * heightPer;
    faceRect.size.width = faceRect.size.width * widthPer;
    faceRect.size.height = faceRect.size.height * heightPer;
    
    return faceRect;
}

#pragma mark ----- 检测条形码
- (void)analysisRectangle
{
    //创建图形上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    NSDictionary *param = [NSDictionary dictionaryWithObject:CIDetectorTypeRectangle forKey:CIDetectorAccuracyHigh];
    //创建识别器对象
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:context options:param];
    UIImage *image = [UIImage imageNamed:@"barCode"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 244);
    [self.view addSubview:imageView];

    //取得识别结果
    NSArray *ary = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (ary.count == 0) {
        NSLog(@"暂未识别出二维码");
    }else{
        for (CIRectangleFeature *feature in ary) {
            NSLog(@"bounds = %@", NSStringFromCGRect(feature.bounds)); //
            NSLog(@"topLeft = %@", NSStringFromCGPoint(feature.topLeft)); //
            NSLog(@"topRight = %@", NSStringFromCGPoint(feature.topRight)); //
            NSLog(@"bottomLeft = %@", NSStringFromCGPoint(feature.bottomLeft)); //
            NSLog(@"bottomRight = %@", NSStringFromCGPoint(feature.bottomRight)); //
            
            UIView *redView1 = [self getRedView];
            UIView *redView2 = [self getRedView];
            UIView *redView3 = [self getRedView];
            UIView *redView4 = [self getRedView];
            
            redView1.frame = CGRectMake(feature.topLeft.x, feature.topLeft.y + 88, 10, 10);
            redView2.frame = CGRectMake(feature.topRight.x, feature.topRight.y + 88, 10, 10);
            redView3.frame = CGRectMake(feature.bottomLeft.x, feature.bottomLeft.y + 88, 10, 10);
            redView4.frame = CGRectMake(feature.bottomRight.x, feature.bottomRight.y + 88, 10, 10);
            
            [self.view addSubview:redView1];
            [self.view addSubview:redView2];
            [self.view addSubview:redView3];
            [self.view addSubview:redView4];
        }
    }
}



@end
