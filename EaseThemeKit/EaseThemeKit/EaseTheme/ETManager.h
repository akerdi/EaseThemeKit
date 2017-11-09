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

static NSString * _Nullable const kETThemeNameDefault = @"typewriter";
static NSString * _Nonnull const kETCurrentThemeName = @"kETCurrentThemeName";
static NSString * _Nullable const kETCurrentThemeType = @"kETCurrentThemeType";

static inline BOOL (ISValidString)(NSString *_Nullable inputString) {
    return inputString&&inputString.length;
}

@interface ETManager: NSObject

+ (instancetype _Nonnull)sharedInstance;

/**
 切换主题

 @param themeName 主题名，如果不合格，则默认default
 @return 是否切换成功
 */
+ (BOOL)shiftThemeName:(NSString *_Nullable)themeName;

/**
 将该element 加入到hashTable 进行之后的遍历使用

 @param themer <EaseTheme>
 */
- (void)addThemer:(id _Nonnull )themer;


/**
 获取当前主题名 eg:default

 @return "default"
 */
+ (NSString *_Nonnull)getCurrentThemeName;

@end

@interface ETManager (ETSerialization)

+ (NSDictionary *_Nonnull)et_getObjVectorOperationKV;

+ (NSDictionary *_Nonnull)et_getIntVectorOperationKV;

+ (NSDictionary *_Nonnull)et_getFloatVectorOperationKV;

+ (CGFloat)et_floatWithPath:(NSString *_Nonnull)path;
+ (BOOL)et_boolWithPath:(NSString *_Nonnull)path;
+ (NSInteger)et_integerWithPath:(NSString *_Nonnull)path;
+ (NSString *_Nonnull)et_stringWithPath:(NSString *_Nonnull)path;

+ (UIColor *_Nonnull)et_colorWithPath:(NSString *_Nonnull)path;
+ (CGColorRef _Nonnull )et_cgColorWithPath:(NSString *_Nonnull)path;

+ (UIImage *_Nonnull)et_imageWithPath:(NSString *_Nonnull)path;
+ (UIFont *_Nonnull)et_fontWithPath:(NSString *_Nonnull)path;
+ (NSDictionary *_Nonnull)et_origDictionaryWithPath:(NSString *_Nonnull)path;
+ (NSDictionary *_Nonnull)et_titleTextAttributesDictionaryWithPath:(NSString *_Nonnull)path;
+ (UIStatusBarStyle)et_statusBarStyleWithPath:(NSString *_Nonnull)path;
+ (UIBarStyle)et_barStyleWithPath:(NSString *_Nonnull)path;
+ (UIKeyboardAppearance)et_keyboardAppearanceWithPath:(NSString *_Nonnull)path;
+ (UIActivityIndicatorViewStyle)et_activityIndicatorStyleWithPath:(NSString * _Nonnull)path;

@end


@interface ETManager (ETTool)

+ (UIColor *_Nonnull)et_colorFromString:(NSString *_Nullable)hexStr;

@end
