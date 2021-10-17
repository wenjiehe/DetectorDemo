//
//  VisionManager.h
//  DetectorDemo
//
//  Created by 贺文杰 on 2021/10/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VisionManager : NSObject

+ (void)imageDetectionManager:(NSArray<UIImage *> *)imgAry;

@end

NS_ASSUME_NONNULL_END
