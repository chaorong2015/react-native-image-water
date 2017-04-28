//
//  RNPrintPDF.m
//  RNPrintPDF
//
//  Created by 晁荣 on 17/4/21.
//  Copyright © 2017年 maichong. All rights reserved.
//

#import "RNPrintPDF.h"

@implementation RNPrintPDF

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(testPrint:(NSString *)message
                  callback:(RCTResponseSenderBlock)callback){
    NSLog(@"string is :%@",message);
    //NSLog(@"%@",message);
    callback(@[[NSNull null], message]);
}
RCT_EXPORT_METHOD(searchPrinter:(RCTResponseSenderBlock)callback){
    NSArray *portArray = [[PrinterFunctions SearchPrinter] retain];
    callback(@[[NSNull null], portArray]);
}
    RCT_EXPORT_METHOD(printPDF:(NSString *)filePath
                      portName:(NSString *)portName
                  portSettings:(NSString *)portSettings
                  callback:(RCTResponseSenderBlock)callback)
{
    NSString * resultStr = nil;
    NSLog(@"imagePrint=>filePath===%@",filePath);
    if (filePath == nil) {
        callback(@[@"filePath not found.", @""]);
        return;
    }
    if (portName == nil) {
        callback(@[@"portName not found.", @""]);
        return;
    }
//    portSettings = @"Portable";
    if (portSettings == nil) {
        portSettings = @"Portable";
    }
    //NSLog(@"%@",message);
    /* Always round up coordinates before passing them into UIKit
     */
    int maxWidthPrint = 300;
    CGFloat imageWidth = 320;
    CGFloat imageHeight = 540;
    CGSize imageSize = CGSizeMake( imageWidth, imageHeight );
    NSURL *URL = [NSURL URLWithString:filePath];
    UIImage *imageTemp = [ UIImage imageWithPDFURL:URL atSize:imageSize];
//    UIImage *imagePrint = [ UIImage imageWithPDFURL:URL fitSize:imageSize atPage:1 ];
//    UIImage *imagePrint = [UIImage imageNamed:@"image1.png"];
//    UIImage *imageTemp = [ UIImage imageWithPDFNamed:@"YinYang.pdf" atSize:imageSize ];
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:@"/temp/ticket.jpg"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(imageTemp) writeToFile:imagePath atomically:YES];
    UIImage *imagePrint = [UIImage imageWithContentsOfFile:imagePath];
    NSLog(@"imagePrint===%@",imagePrint);
    if([portSettings isEqualToString: @"Portable"]){
//        NSLog(@"PrintImageWithPortname===>>");
        resultStr = [PrinterFunctions PrintImageWithPortname:portName
                                                portSettings:portSettings
                                                imageToPrint:imagePrint
                                                    maxWidth:maxWidthPrint
                                           compressionEnable:true
                                              withDrawerKick:NO];
    } else{
//        NSLog(@"PrintBitmapWithPortName===>>");
        resultStr = [PrinterFunctions PrintBitmapWithPortName:portName
                                                 portSettings:portSettings
                                                  imageSource:imagePrint
                                                 printerWidth:maxWidthPrint
                                            compressionEnable:true
                                               pageModeEnable:true];
    }
    if(resultStr == nil){
        resultStr = @"Error: portException";
    }
    callback(@[@"", resultStr]);
}
@end
