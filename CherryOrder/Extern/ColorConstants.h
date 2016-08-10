//
//  ColorConstants.h
//  lukou
//
//  Created by feifengxu on 15/3/15.
//  Copyright (c) 2015年 lukou. All rights reserved.
//

#ifndef lukou_ColorConstants_h
#define lukou_ColorConstants_h

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define LK_TEXT_COLOR_GRAY UIColorFromRGB(0x7c7c7c)
#define LK_BACK_COLOR_LIGHT_GRAY UIColorFromRGB(0xe2e0dd)

#define MAIN_COLOR ([UIColor colorWithRed:245.0/255 green:102.0/255 blue:68.0/255 alpha:1.0])
#define YELLOW_COLOR ([UIColor colorWithRed:255.0/255 green:207.0/255 blue:60.0/255 alpha:1.0])
#define BLUE_COLOR ([UIColor colorWithRed:0.0/255 green:205.0/255 blue:185.0/255 alpha:1.0])
#define DARK_MAIN_COLOR ([UIColor colorWithRed:236.0/255 green:125.0/255 blue:91.0/255 alpha:1.0])
#define MAIN_ALPHA_COLOR(_A)  ([UIColor colorWithRed:245.0/255 green:102.0/255 blue:68.0/255 alpha:(_A)])
#define BLUE_ALPHA_COLOR(_A) ([UIColor colorWithRed:0.0/255 green:205.0/255 blue:185.0/255 alpha:(_A)])
#define BLUE_NEW_COLOR ([UIColor colorWithRed:114.0/255 green:201.0/255 blue:208.0/255 alpha:1.0])
#define GRAY_COLOR ([UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1.0])
#define GRAY_ALPHA_COLOR(_A) ([UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:(_A)])

#define ITEM_SPACING 20.0f
#define NAME_COLLECTION_CELL_WIDTH 60.0f

#endif