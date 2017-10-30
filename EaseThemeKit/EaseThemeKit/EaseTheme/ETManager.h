//
//  SHEaseThemeManager.h
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/28.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const kETThemeNameDefault = @"default";
static NSString *const kETCurrentThemeName = @"kETCurrentThemeName";
static NSString *const kETCurrentThemeType = @"kETCurrentThemeType";

static inline BOOL (ISValidString)(NSString *inputString) {
    return inputString&&inputString.length;
}

@interface ETManager: NSObject

+ (instancetype)sharedInstance;

@end

@interface ETManager (ETSerialization)

+ (UIColor *)et_colorWithPath:(NSString *)path;

@end


@interface ETManager (ETTool)

+ (UIColor *)et_colorFromString:(NSString *)hexStr;

@end
