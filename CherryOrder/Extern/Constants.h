//
//  UIConstants.h
//  lukou
//
//  Created by feifengxu on 14/12/11.
//  Copyright (c) 2014年 lukou. All rights reserved.
//

#ifndef lukou_UIConstants_h
#define lukou_UIConstants_h

#define PADDING   16
#define PADDING_12 12 
#define PADDING_8  8
#define PADDING_4  4
#define PADDING_6  6
#define VIEW_SPACE 8
#define VIEW_SPACE_12 12
#define VIEW_SPACE_16 16
#define VIEW_SPACE_18 18
#define VIEW_SPACE_20 20
#define VIEW_SPACE_24 24
#define DEFAULT_LINE_SPACING  4.f
#define CELL_GAP_HEIGHT            16.f
#define DEFAULT_FEED_FOOTER_HEIGHT      44.f
#define DEFAULT_SECTION_HEADER_HEIGHT   44.f
#define EMPTY_CELL_HEIGHT 120
#define LIGHT_SEPARATOR_WIDTH  (1 / [UIScreen mainScreen].scale)

#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define DEVICE_IS_IPHONE_6          (BOOL)(SCREEN_WIDTH == 375)
#define DEVICE_IS_IPHONE_6P         (BOOL)(SCREEN_WIDTH > 375)

#define DEVICE_IS_IPAD         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define BEFORE_END_TIME @"16:30"
#define END_TIME @"16:00"
#define END_TIME_4 @"16:00:00"
#define END_TIME_430 @"16:30:00"
#define END_TIME_440 @"20:40:00"

#define START_WEEKDAY 1
#define END_WEEKDAY 5

#define PX_1          (1 / [UIScreen mainScreen].scale)
#define PX_2          (2 / [UIScreen mainScreen].scale)

#define ROOT_URL @"120.26.131.154:8080"
#define API @"api"
#define IS_iOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

#endif