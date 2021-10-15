//
//  VisionKitManager.m
//  DetectorDemo
//
//  Created by 贺文杰 on 2021/10/15.
//

#import "VisionKitManager.h"
#import <VisionKit/VisionKit.h>
#import <Photos/Photos.h>

@interface VisionKitManager ()<VNDocumentCameraViewControllerDelegate>

@end

@implementation VisionKitManager

/*
    使用VNDocumentCameraViewController类需要在plist文件中添加以下两个key:
    NSPhotoLibraryAddUsageDescription
    NSCameraUsageDescription
 */


+ (void)cameraScanDocument:(UIViewController *)viewController{
    if (@available(iOS 13.0, *)) {
        if (!VNDocumentCameraViewController.supported) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前设备不支持" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
            }]];
            [viewController presentViewController:alertVC animated:YES completion:^{
                            
            }];
        }else{
            VNDocumentCameraViewController *documentCameraVC = [[VNDocumentCameraViewController alloc] init];
            documentCameraVC.delegate = self;
            [viewController presentViewController:documentCameraVC animated:YES completion:^{
                            
            }];
        }
    } else {
        
    }
}

#pragma mark -- tools
- (void)writeImage:(NSMutableArray<UIImage *> *)imgs{
    __block NSMutableArray<NSString *> *localIdentifierMtbAry = [NSMutableArray new];
    //获取所有相册
    PHFetchResult *result = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *assetCollection = obj;
        if ([assetCollection.localizedTitle isEqualToString:@""]) { //选定目标相册
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                for (NSInteger i = 0; i < imgs.count; i++) {
                    UIImage *image = imgs[i];
                    PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                    //请求编辑相册
                    PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                    //为Asset创建一个占位符，放到相册编辑请求中
                    PHObjectPlaceholder *placeholder = [request placeholderForCreatedAsset];
                    [collectionChangeRequest addAssets:@[placeholder]];
                    [localIdentifierMtbAry addObject:placeholder.localIdentifier];
                }
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) { //保存图片成功
                    
                }else{ //保存图片失败
                    
                }
            }];
            *stop = YES;
        }
    }];
}

#pragma mark -- VNDocumentCameraViewControllerDelegate
- (void)documentCameraViewController:(VNDocumentCameraViewController *)controller didFinishWithScan:(VNDocumentCameraScan *)scan API_AVAILABLE(ios(13.0)){
    NSLog(@"scan.title = %@", scan.title);
    NSMutableArray *imageMtbAry = [NSMutableArray new];
    for (NSInteger i = 0; i < scan.pageCount; i++) {
        UIImage *image = [scan imageOfPageAtIndex:i];
        [imageMtbAry addObject:image];
    }
    if (imageMtbAry.count > 0) {
        [self writeImage:imageMtbAry];
    }
}

- (void)documentCameraViewControllerDidCancel:(VNDocumentCameraViewController *)controller API_AVAILABLE(ios(13.0)){
    [controller dismissViewControllerAnimated:YES completion:^{
            
    }];
}

- (void)documentCameraViewController:(VNDocumentCameraViewController *)controller didFailWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSLog(@"fail error = %@", error);
}


@end
