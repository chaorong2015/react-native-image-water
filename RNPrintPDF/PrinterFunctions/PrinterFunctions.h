//
//  PrinterFunctions.h
//  IOS_SDK
//
//  Created by Tzvi on 8/2/11.
//  Copyright 2011 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonEnum.h"

//@class SMBluetoothManager, SMPort;

typedef enum _SMPrinterType {
    SMPrinterTypeUnknown = 0,
    SMPrinterTypeDesktopPrinterStarLine,
    SMPrinterTypePortablePrinterStarLine,
    SMPrinterTypePortablePrinterESCPOS
} SMPrinterType;

typedef enum _SMPaperWidth {
    SMPaperWidth2inch,
    SMPaperWidth3inch,
    SMPaperWidth4inch
} SMPaperWidth;

typedef enum _SMLanguage {
    SMLanguageEnglish,
    SMLanguageEnglishUtf8,
    SMLanguageFrench,
    SMLanguageFrenchUtf8,
    SMLanguagePortuguese,
    SMLanguagePortugueseUtf8,
    SMLanguageSpanish,
    SMLanguageSpanishUtf8,
    SMLanguageRussian,
    SMLanguageRussianUtf8,
    SMLanguageJapanese,
    SMLanguageJapaneseUtf8,
    SMLanguageSimplifiedChinese,
    SMLanguageSimplifiedChineseUtf8,
    SMLanguageTraditionalChinese,
    SMLanguageTraditionalChineseUtf8,
} SMLanguage;
typedef enum {
    USE_LIMITS = 0,
    USE_FIXED = 1
} Limit;

typedef enum {
    NarrowWide_2_6 = 0,
    NarrowWide_3_9 = 1,
    NarrowWide_4_12 = 2,
    NarrowWide_2_5 = 3,
    NarrowWide_3_8 = 4,
    NarrowWide_4_10 = 5,
    NarrowWide_2_4 = 6,
    NarrowWide_3_6 = 7,
    NarrowWide_4_8 = 8
} NarrowWide;

typedef enum {
    NarrowWideV2_2_5 = 0,
    NarrowWideV2_4_10 = 1,
    NarrowWideV2_6_15 = 2,
    NarrowWideV2_2_4 = 3,
    NarrowWideV2_4_8 = 4,
    NarrowWideV2_6_12 = 5,
    NarrowWideV2_2_6 = 6,
    NarrowWideV2_3_9 = 7,
    NarrowWideV2_4_12 = 8
} NarrowWideV2;

typedef enum {
    No_Added_Characters_With_Line_Feed = 0,
    Adds_Characters_With_Line_Feed = 1,
    No_Added_Characters_Without_Line_Feed = 2,
    Adds_Characters_Without_Line_Feed = 3
} BarCodeOptions;

typedef enum {
    _2_dots = 0,
    _3_dots = 1,
    _4_dots = 2
} Min_Mod_Size;


@interface PrinterFunctions : NSObject

+ (SMPrinterType)parsePortSettings:(NSString *)portSettings;

#pragma mark common

+ (NSString *)PrintImageWithPortname:(NSString *)portName
                  portSettings:(NSString *)portSettings
                  imageToPrint:(UIImage *)imageToPrint
                      maxWidth:(int)maxWidth
             compressionEnable:(BOOL)compressionEnable
                withDrawerKick:(BOOL)drawerKick;

#pragma mark -
+ (NSString *)sendCommand:(NSData *)commandsToPrint
           portName:(NSString *)portName
       portSettings:(NSString *)portSettings
      timeoutMillis:(u_int32_t)timeoutMillis;

#pragma mark search
+ (NSArray *)SearchPrinter;
#
+ (NSString *)PrintBitmapWithPortName:(NSString *)portName
                         portSettings:(NSString *)portSettings
                          imageSource:(UIImage *)source
                         printerWidth:(int)maxWidth
                    compressionEnable:(BOOL)compressionEnable
                       pageModeEnable:(BOOL)pageModeEnable;
#
+ (NSString *)sendCommandBitmap:(NSData *)commands
                       portName:(NSString *)portName
                   portSettings:(NSString *)portSettings
                  timeoutMillis:(u_int32_t)timeoutMillis;
@end
