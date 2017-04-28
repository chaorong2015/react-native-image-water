//
//  CommonEnum.h
//  IOS_SDK
//
//  Created by u3237 on 13/04/09.
//
//

typedef enum
{
    Low = 0,
    Middle = 1,
    Q = 2,
    High = 3
} CorrectionLevelOption;

typedef enum
{
    Model1 = 0,
    Model2 = 1
} Model;

typedef enum
{
    FULL_CUT = 0,
    PARTIAL_CUT = 1,
    FULL_CUT_FEED = 2,
    PARTIAL_CUT_FEED = 3
} CutType;

typedef enum
{
    Left = 0,
    Center = 1,
    Right = 2
} Alignment;

typedef enum
{
    NoDrawer = 0,
    SensorActiveHigh = 1,
    SensorActiveLow = 2
} SensorActive;
