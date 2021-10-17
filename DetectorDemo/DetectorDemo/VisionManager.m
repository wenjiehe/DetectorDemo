//
//  VisionManager.m
//  DetectorDemo
//
//  Created by 贺文杰 on 2021/10/15.
//

#import "VisionManager.h"
#import <Vision/Vision.h>

typedef void(^visionhandle)(VNRequest *request, NSError *error);

@interface VisionManager ()

@property(nonatomic,copy)visionhandle block;

@end

@implementation VisionManager

+ (void)imageDetectionManager:(NSArray<UIImage *> *)imgAry{
    
    //VNRecognizeTextRequestRevision1 只支持英语
    //VNRecognizeTextRequestRevision2 支持英语、中文、葡萄牙语、法语、意大利语、德语、西班牙语的准确识别，快速识别不包括中文
    //VNRequestTextRecognitionLevelAccurate 更准确，深度学习识别方式，整句识别
    //VNRequestTextRecognitionLevelFast 更快速，机器学习识别方式，字符识别
    VNRequestCompletionHandler completionHandler = ^(VNRequest *request, NSError * _Nullable error){
        if (!error) {
            NSLog(@"thread = %@", [NSThread currentThread]);
            NSArray *ary = request.results;
            for (id observation in ary) {
                if ([observation isKindOfClass:[VNRecognizedTextObservation class]]) {
                    VNRecognizedTextObservation *ob = observation;
                    NSArray<VNRecognizedText*> *textAry = [ob topCandidates:2];
                    for (VNRecognizedText *reText in textAry) {
                        NSLog(@"string = %@", reText.string);
                    }
                }
            }
        }else{
            NSLog(@"error = %@", error);
        }
    };
    
    /**
     "en-US", //英文
     "fr-FR",
     "it-IT",
     "de-DE",
     "es-ES",
     "pt-BR",
     "zh-Hans", //简体
     "zh-Hant"  //繁体
     */
    NSError *error = nil;
    NSArray<NSString *> *strAry = [VNRecognizeTextRequest supportedRecognitionLanguagesForTextRecognitionLevel:VNRequestTextRecognitionLevelAccurate revision:VNRecognizeTextRequestRevision2 error:&error]; //检查支持的识别语言
    NSLog(@"strAry = %@, error = %@", strAry, error);
    
    //放入身份证照片or其他照片
    UIImage *image = [UIImage imageNamed:@"身份证正面.jpg"];
    
    VNRecognizeTextRequest *textRequest = [[VNRecognizeTextRequest alloc] initWithCompletionHandler:completionHandler];
//    textRequest.customWords = @[@"姓名", @"性别", @"民族", @"出生", @"住址", @"公民身份号码", @"签发机关", @"有效期限", @"姓", @"名", @"性", @"别", @"民", @"族", @"出", @"生", @"住", @"址", @"公", @"身", @"份", @"号", @"码", @"签", @"发", @"机", @"关", @"有", @"效", @"期", @"限"];
    textRequest.recognitionLevel = VNRequestTextRecognitionLevelAccurate;
    textRequest.minimumTextHeight = 0.001; //0.0~1.0 数值越大，消耗更少的内存及加快识别速度
    textRequest.recognitionLanguages = @[@"zh-Hans", @"zh-Hant"]; //默认使用第一种，第一种识别失败才会用第二种语言识别
    textRequest.usesLanguageCorrection = NO; //识别过程中进行语言校正，YES-语言校正 NO-返回原始识别结果，提供性能优势，但不太准确的结果

    //身份证反面使用kCGImagePropertyOrientationRight
    //身份证正面使用kCGImagePropertyOrientationUp
    //社保卡使用kCGImagePropertyOrientationRight
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage orientation:kCGImagePropertyOrientationUp options:@{}];
    NSError *handleError = nil;
    BOOL isSuccess = [handler performRequests:@[textRequest] error:&handleError];
    if (isSuccess) { //所有请求都执行了
        NSLog(@"都被执行了");
    }
}

@end
