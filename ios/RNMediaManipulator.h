#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <UIKit/UIKit.h>

@interface RNMediaManipulator : NSObject <RCTBridgeModule>

- (UIImage *)imageByScalingProportionallyToSize:(UIImage*)src targetSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByDegrees:(UIImage*)src floatDegrees:(CGFloat)degrees;
-(NSURL *)applicationDocumentsDirectory;

@end
  
