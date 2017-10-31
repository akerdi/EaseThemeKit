//
//  SHEaseThemeManager.h
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/28.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NSString ETThemeName;

SEL _Nullable getSelectorWithPattern(const char * _Nullable prefix, const char * _Nullable key, const char * _Nullable suffix);

typedef NS_ENUM(NSInteger, ETThemeSourceType) {
    ETThemeSourceType_bundle,
    ETThemeSourceType_sandbox
};

static NSString * _Nullable const kETThemeNameDefault = @"default";
static NSString * _Nonnull const kETCurrentThemeName = @"kETCurrentThemeName";
static NSString * _Nullable const kETCurrentThemeType = @"kETCurrentThemeType";

static inline BOOL (ISValidString)(NSString *_Nullable inputString) {
    return inputString&&inputString.length;
}

@interface ETManager: NSObject

+ (instancetype _Nonnull)sharedInstance;

@end

@interface ETManager (ETSerialization)

+ (NSDictionary *_Nonnull)et_getObjVectorOperationKV;

+ (UIColor *_Nonnull)et_colorWithPath:(NSString *_Nonnull)path;

@end


@interface ETManager (ETTool)

+ (UIColor *_Nonnull)et_colorFromString:(NSString *_Nullable)hexStr;

@end
