#import <React/RCTBridgeModule.h>
#import <UIKit/UIKit.h>

@interface RNMediaManipulator : NSObject <RCTBridgeModule>

- (UIImage *)imageByScalingProportionallyToSize:(UIImage*)src targetSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByDegrees:(UIImage*)src floatDegrees:(CGFloat)degrees;
-(NSURL *)applicationDocumentsDirectory;

@end
  
