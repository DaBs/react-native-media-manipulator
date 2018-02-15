#import "RNMediaManipulator.h"
#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>


@implementation RNMediaManipulator

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(mergeImages:(NSDictionary *)backgroundObj imageObjs:(NSArray *)imageObjs resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {

    NSString *mirrored = backgroundObj[@"mirrored"];
    NSURL *backgroundUrl = [NSURL URLWithString:backgroundObj[@"uri"]];
    NSNumber *backgroundWidth = backgroundObj[@"width"];
    NSNumber *backgroundHeight = backgroundObj[@"height"];
    NSData *backgroundData = [NSData dataWithContentsOfURL:backgroundUrl];
    UIImage *backgroundImage = [[UIImage alloc] initWithData:backgroundData];
    if (mirrored && [mirrored  isEqual: @"true"]) {
        backgroundImage = [UIImage imageWithCGImage:backgroundImage.CGImage scale:backgroundImage.scale orientation:UIImageOrientationLeftMirrored];
    }
    backgroundImage = [self imageByScalingProportionallyToSize:backgroundImage targetSize:CGSizeMake(backgroundWidth.floatValue, backgroundHeight.floatValue)];
    backgroundWidth = [NSNumber numberWithDouble:backgroundImage.size.width];
    backgroundHeight = [NSNumber numberWithDouble:backgroundImage.size.height];
    CGSize backgroundSize = CGSizeMake(backgroundWidth.floatValue, backgroundHeight.floatValue);
    
    UIGraphicsBeginImageContextWithOptions(backgroundSize, true, 0.0);
    
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundWidth.floatValue, backgroundHeight.floatValue)];

    for (NSDictionary *imageObj in imageObjs) {
        NSURL *imageUrl = [NSURL URLWithString:imageObj[@"uri"]];
        NSNumber *positionX = imageObj[@"x"];
        NSNumber *positionY = imageObj[@"y"];
        NSNumber *rotate = imageObj[@"rotate"];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        NSNumber *scale = [NSNumber numberWithInt:1];
        if ([imageObj objectForKey:@"scale"]) {
            scale = imageObj[@"scale"];
        }
        NSNumber *width = [NSNumber numberWithDouble:image.size.width];
        NSNumber *height = [NSNumber numberWithDouble:image.size.height];
        if ([imageObj objectForKey:@"width"]) width = imageObj[@"width"];
        if ([imageObj objectForKey:@"height"]) height = imageObj[@"height"];
        NSNumber *scaledWidth = [NSNumber numberWithFloat:width.floatValue*scale.floatValue];
        NSNumber *scaledHeight = [NSNumber numberWithFloat:height.floatValue*scale.floatValue];
        image = [self imageByScalingProportionallyToSize:image targetSize:CGSizeMake(scaledWidth.floatValue, scaledHeight.floatValue)];
        image = [self imageRotatedByDegrees:image floatDegrees:rotate.floatValue];
        
        NSNumber *actualX = [NSNumber numberWithFloat:(positionX.floatValue + width.floatValue / 2 - image.size.width / 2)];
        NSNumber *actualY = [NSNumber numberWithFloat:(positionY.floatValue + height.floatValue / 2 - image.size.height / 2)];
        
        [image drawInRect:CGRectMake(
                                     actualX.floatValue,
                                     actualY.floatValue,
                                     image.size.width,
                                     image.size.height
                                     )];
    }
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString *fileName = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *fullPath = [NSString stringWithFormat:@"%@%@.jpg", NSTemporaryDirectory(), fileName];

    NSData *data = UIImageJPEGRepresentation(finalImage, 1.0);
    [data writeToFile:fullPath atomically:YES];
    resolve(fullPath);
};

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (UIImage *)imageByScalingProportionallyToSize:(UIImage*)src targetSize:(CGSize)targetSize {
    
    UIImage *sourceImage = src;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageRotatedByDegrees:(UIImage*)src floatDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,src.size.width, src.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContextWithOptions(rotatedSize, false, 0.0);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-src.size.width / 2, -src.size.height / 2, src.size.width, src.size.height), [src CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}



@end

