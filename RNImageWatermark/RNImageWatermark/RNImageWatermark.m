//
//  RNImageWatermark.m
//  RNImageWatermark
//
//  Created by 晁荣 on 16/11/24.
//  Copyright © 2016年 maichong. All rights reserved.
//

#import "RNImageWatermark.h"
#import "UIImage+WaterMark.h"
#import "RCTImageLoader.h"
#import "ImageHelpers.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation RNImageWatermark
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

bool savedImage(NSString * fullPath, UIImage * image, NSString * format, float quality)
{
    NSData* data = nil;
    if ([format isEqualToString:@"JPEG"]) {
        data = UIImageJPEGRepresentation(image, quality / 100.0);
    } else if ([format isEqualToString:@"PNG"]) {
        data = UIImagePNGRepresentation(image);
    }
    
    if (data == nil) {
        return NO;
    }
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    return YES;
}
NSString * generateFilePath(NSString * ext, NSString * outputPath)
{
    NSString* directory;
    
    if ([outputPath length] == 0) {
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        directory = [paths firstObject];
    } else {
        directory = outputPath;
    }
    
    NSString* name = [[NSUUID UUID] UUIDString];
    NSString* fullName = [NSString stringWithFormat:@"%@.%@", name, ext];
    NSString* fullPath = [directory stringByAppendingPathComponent:fullName];
    
    return fullPath;
}
UIImage * rotateImage(UIImage *inputImage, float rotationDegrees)
{
    
    // We want only fixed 0, 90, 180, 270 degree rotations.
    const int rotDiv90 = (int)round(rotationDegrees / 90);
    const int rotQuadrant = rotDiv90 % 4;
    const int rotQuadrantAbs = (rotQuadrant < 0) ? rotQuadrant + 4 : rotQuadrant;
    
    // Return the input image if no rotation specified.
    if (0 == rotQuadrantAbs) {
        return inputImage;
    } else {
        // Rotate the image by 80, 180, 270.
        UIImageOrientation orientation = UIImageOrientationUp;
        
        switch(rotQuadrantAbs) {
            case 1:
                orientation = UIImageOrientationRight; // 90 deg CW
                break;
            case 2:
                orientation = UIImageOrientationDown; // 180 deg rotation
                break;
            default:
                orientation = UIImageOrientationLeft; // 90 deg CCW
                break;
        }
        
        return [[UIImage alloc] initWithCGImage: inputImage.CGImage
                                          scale: 1.0
                                    orientation: orientation];
    }
}
//测试方法导出
RCT_EXPORT_METHOD(testPrint:(NSString *)text
                  callback:(RCTResponseSenderBlock)callback)
{
    NSString *testStr = [NSString stringWithFormat:@"%@",text];
    NSLog(@"testStr is :%@",testStr);
    //NSString *message = @"callback message!!!";
    callback(@[[NSNull null], testStr]);
}

//给图片添加字体水印
RCT_EXPORT_METHOD(addImageWatermark:(NSString *)path
                  watermarkText:(NSString *)watermarkText
                  watermarkPosition:(int)watermarkPosition
                  watermarkSize:(NSInteger)watermarkSize
                  outputPath:(NSString *)outputPath
                  callback:(RCTResponseSenderBlock)callback)
{
    //NSLog(@"outputPath is :%@",outputPath);
    NSString* fullPath = generateFilePath(@"jpg", outputPath);
    [_bridge.imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:path] callback:^(NSError *error, UIImage *baseImage) {
        if (error || baseImage == nil) {
            if ([path hasPrefix:@"data:"] || [path hasPrefix:@"file:"]) {
                NSURL *imageUrl = [[NSURL alloc] initWithString:path];
                baseImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            } else {
                baseImage = [[UIImage alloc] initWithContentsOfFile:path];
            }
            if (baseImage == nil) {
                callback(@[@"Can't retrieve the file from the path.", @""]);
                return;
            }
        }
        //NSLog(@"baseImage is :%@",baseImage);
        int x = baseImage.size.width / 3;
        int y = baseImage.size.height / 3;
        //设置字体样式
        NSString* textStr = watermarkText;
        NSInteger strLength = [textStr length];
        NSInteger chineseLength = 0;
        NSInteger upperLength = 0;
        NSInteger lowerLength = 0;
        NSInteger figureLength = 0;
        NSInteger otherLength = 0;
        for (int i = 0; i<strLength; i++) {
            char commitChar = [textStr characterAtIndex:i];
            NSString *temp = [textStr substringWithRange:NSMakeRange(i,1)];
            const char *u8Temp = [temp UTF8String];
            if (3==strlen(u8Temp)){
                chineseLength = chineseLength + 1;
            }else if((commitChar>64)&&(commitChar<91)){
                upperLength = upperLength + 1;
            }else if((commitChar>96)&&(commitChar<123)){
                lowerLength = lowerLength + 1;
            }else if((commitChar>47)&&(commitChar<58)){
                figureLength = figureLength + 1;
            }else{
                otherLength = otherLength + 1;
            }
        }
        strLength = chineseLength + upperLength + lowerLength / 2 + figureLength + otherLength / 2;
//        NSLog(@"字符串中含有中文:%d", chineseLength);
//        NSLog(@"字符串中含有大写英文字母:%d", upperLength);
//        NSLog(@"字符串中含有小写英文字母:%d", lowerLength);
//        NSLog(@"字符串中含有数字:%d", figureLength);
//        NSLog(@"字符串中含有非法字符:%d", otherLength);
//        NSLog(@"totle is :%d",[textStr length]);
//        NSLog(@"col is :%d",strLength);
        int fontSize = 200;
        if(watermarkSize){
            fontSize = watermarkSize;
        }
        if(fontSize * strLength > 2 * x){
            fontSize = (2 * x ) / strLength;
        }
        int top = (y - fontSize) / 2;
        int pointX = 0;
        int pointY = 0;
        int number = watermarkPosition;
        if(strLength){
            
            switch (number) {
                    /*＝＝＝＝＝＝九宫格第一竖排＝＝＝＝＝＝*/
                case 1:
                    pointX = 20;
                    pointY = 20;
                    break;
                case 4:
                    pointX = 20;
                    pointY = y * 1 + top;
                    break;
                case 7:
                    pointX = 20;
                    pointY = y * 3 - fontSize - 20;
                    break;
                    /*＝＝＝＝＝＝九宫格第二竖排＝＝＝＝＝＝*/
                case 2:
                    pointX = x / 2 + x - (fontSize * strLength) / 2;
                    pointY = 20;
                    break;
                case 5:
                    pointX = x / 2 + x - (fontSize * strLength) / 2;
                    pointY = y * 1 + top;
                    break;
                case 8:
                    pointX = x / 2 + x - (fontSize * strLength) / 2;
                    pointY = y * 3 - fontSize - 20;
                    break;
                    /*＝＝＝＝＝＝九宫格第三竖排＝＝＝＝＝＝*/
                case 3:
                    pointX = x * 3 - fontSize * strLength - 20;
                    pointY = 20;
                    break;
                case 6:
                    pointX = x * 3 - fontSize * strLength - 20;
                    pointY = y * 1 + top;
                    break;
                case 9:
                    pointX = x * 3 - fontSize * strLength - 20;
                    pointY = y * 3 - fontSize - 20;
                    break;
                default:
                    break;
            }
        }
        NSLog(@"textStr is :%@",textStr);
        NSLog(@"number is :%d",number);
        NSLog(@"x is :%d",x);
        NSLog(@"y is :%d",y);
        NSLog(@"top is :%d",top);
        NSLog(@"pointX is :%d",pointX);
        NSLog(@"pointY is :%d",pointY);
        NSLog(@"fontSize is :%d",fontSize);
        UIImage *waterMarkImage = [baseImage imageWaterMarkWithString:textStr point:CGPointMake(pointX, pointY) attribute:@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:fontSize],NSForegroundColorAttributeName:[UIColor whiteColor]} image:nil imagePoint:CGPointMake(0, 0) alpha:0.2];
        
        if (waterMarkImage == nil) {
            callback(@[@"添加水印失败.", @""]);
            return;
        }
        // Compress and save the image
        if (!savedImage(fullPath, waterMarkImage, @"JPEG", 100)) {
            callback(@[@"Can't save the image. Check your compression format.", @""]);
            return;
        }
//        //测试==保存图片到album_name 一遍查看水印位置
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        [library saveImage:waterMarkImage toAlbum:@"album_name" completion:^(NSURL *assetURL, NSError *error) {
//            if (!error) {
//                NSLog(@"保存图片成功!");
//            } else {
//                NSLog(@"保存图片错误!");
//            }
//        } failure:^(NSError *error) {
//            NSLog(@"保存图片失败!");
//        }];
        //NSLog(@"fullPath is :%@",fullPath);
        callback(@[[NSNull null], fullPath]);
    }];
}
//保存到新建相册
RCT_EXPORT_METHOD(addPhotoAlbum:(NSString *)path
                  albumName:(NSString *) albumName
                  callback:(RCTResponseSenderBlock)callback)
{
     NSString *album_name = @"DaiGou";
    if(albumName){
        album_name = [NSString stringWithFormat:@"%@",albumName];
    }
    [_bridge.imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:path] callback:^(NSError *error, UIImage *image) {
        if (error || image == nil) {
            if ([path hasPrefix:@"data:"] || [path hasPrefix:@"file:"]) {
                NSURL *imageUrl = [[NSURL alloc] initWithString:path];
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            } else {
                image = [[UIImage alloc] initWithContentsOfFile:path];
            }
            if (image == nil) {
                callback(@[@"Can't retrieve the file from the path.", @""]);
                return;
            }
        }
        //保存图片到新建相册
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:image toAlbum:album_name completion:^(NSURL *assetURL, NSError *error) {
            if (!error) {
                NSLog(@"保存图片成功!");
                callback(@[@"", @"Image save to path is success!"]);
            } else {
                NSLog(@"保存图片错误!");
                callback(@[@"Image save to path is error!", @""]);
            }
        } failure:^(NSError *error) {
            NSLog(@"保存图片失败!");
            callback(@[@"Image save to path is failure!", @""]);
        }];
    }];
}
RCT_EXPORT_METHOD(createResizedImage:(NSString *)path
                  width:(float)width
                  height:(float)height
                  format:(NSString *)format
                  quality:(float)quality
                  rotation:(float)rotation
                  outputPath:(NSString *)outputPath
                  callback:(RCTResponseSenderBlock)callback)
{
    CGSize newSize = CGSizeMake(width, height);
    NSString* fullPath = generateFilePath(@"jpg", outputPath);
    
    [_bridge.imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:path] callback:^(NSError *error, UIImage *image) {
        if (error || image == nil) {
            if ([path hasPrefix:@"data:"] || [path hasPrefix:@"file:"]) {
                NSURL *imageUrl = [[NSURL alloc] initWithString:path];
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            } else {
                image = [[UIImage alloc] initWithContentsOfFile:path];
            }
            if (image == nil) {
                callback(@[@"Can't retrieve the file from the path.", @""]);
                return;
            }
        }
        
        // Rotate image if rotation is specified.
        if (0 != (int)rotation) {
            image = rotateImage(image, rotation);
            if (image == nil) {
                callback(@[@"Can't rotate the image.", @""]);
                return;
            }
        }
        
        // Do the resizing
        UIImage * scaledImage = [image scaleToSize:newSize];
        if (scaledImage == nil) {
            callback(@[@"Can't resize the image.", @""]);
            return;
        }
        NSLog(@"scaledImage is :%@",scaledImage);
        // Compress and save the image
        if (!savedImage(fullPath, scaledImage, format, quality)) {
            callback(@[@"Can't save the image. Check your compression format.", @""]);
            return;
        }
        
        callback(@[[NSNull null], fullPath]);
    }];
}
@end
