//
//  SHEaseThemeManager.m
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/28.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import "ETManager.h"
#import "EaseTheme.h"

UIKIT_EXTERN NSString *const kETArgColor;

static NSString *kETFileExtensionPlist = @"plist";
static NSString *kETFileExtensionJSON = @"json";

static inline UIColor *(ETRGBHex)(NSUInteger hex) {
    return [UIColor colorWithRed:((float)((hex&0xFF0000)>>16))/255.0 green:((float)((hex&0xFF00)>>16))/255.0 blue:((float)((hex&0xFF)>>16))/255.0 alpha:1.0];
}

SEL _Nullable getSelectorWithPattern(const char * _Nullable prefix, const char * _Nullable key, const char * _Nullable suffix) {
    size_t prefixLength = prefix ? strlen(prefix) : 0;
    size_t suffixLength = suffix ? strlen(suffix) : 0;
    
    char initial = key[0];
    if (prefixLength) initial = (char)toupper(initial);
    size_t initialLength = 1;
    
    const char *rest = key + initialLength;
    size_t restLength = strlen(rest);
    
    char selector[prefixLength + initialLength + restLength + suffixLength +1];
    memcpy(selector, prefix, prefixLength);
    selector[prefixLength] = initial;
    memcpy(selector + prefixLength + initialLength, rest, restLength);
    memcpy(selector + prefixLength + initialLength + restLength, suffix, suffixLength);
    selector[prefixLength + initialLength + restLength + suffixLength] = '\0';
    return sel_registerName(selector);
}

@interface ETManager ()
@property (nonatomic, strong) NSHashTable<EaseTheme *> *weakArray;


@end

@implementation ETManager

static NSString *_resourcesPath;

static NSDictionary *_themeDic;//缓存一份数据 shift时需要更改该缓存

static NSString *_currentThemeName;

static NSUInteger _currentThemeType;//来自于bundle 还是sandbox

static ETManager *_easeThemeManager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _easeThemeManager = [self allocWithZone:zone];
    });
    return _easeThemeManager;
}

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _easeThemeManager = [ETManager new];
    });
    return _easeThemeManager;
}

- (instancetype)init{
    if (self=[super init]) {
        self.weakArray = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

+ (NSString *)et_getSourceFilePathWithName:(NSString *)themeName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:themeName ofType:kETFileExtensionJSON];
    if (!ISValidString(filePath)) {
        filePath = [[NSBundle mainBundle] pathForResource:themeName ofType:kETFileExtensionPlist];
    }
    return filePath;
}

+ (void)saveCurrentThemeInfosWithName:(NSString *)themeName type:(NSUInteger)themeType {
    _currentThemeName = themeName;
    _currentThemeType = themeType;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:themeName forKey:kETCurrentThemeName];
    [userDefaults setObject:@(themeType) forKey:kETCurrentThemeType];
    [userDefaults synchronize];
}

+ (NSUInteger)getCurrentThemeType {
    if (_currentThemeType) return _currentThemeType;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _currentThemeType = [[userDefaults objectForKey:kETCurrentThemeType] integerValue];
    return _currentThemeType;
}

+ (NSString *)getCurrentThemeName {
    if (_currentThemeName) return _currentThemeName;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _currentThemeName = [userDefaults objectForKey:kETCurrentThemeName];
    if (!ISValidString(_currentThemeName)) {
        _currentThemeName = kETThemeNameDefault;
        [userDefaults setObject:kETThemeNameDefault forKey:kETCurrentThemeName];
        [userDefaults synchronize];
    }
    return _currentThemeName;
}

+ (BOOL)shiftThemeName:(NSString *)themeName {
    if (ISValidString(themeName)&&[themeName isEqualToString:_currentThemeName]) return NO;
    if (!ISValidString(themeName)) themeName = kETThemeNameDefault;
    _resourcesPath = [self et_getSourceFilePathWithName:themeName];
    
    if (ISValidString(_resourcesPath)) {
        NSUInteger currentThemeType = 0;//默认为0
        [self saveCurrentThemeInfosWithName:themeName type:currentThemeType];
        for (EaseTheme *easeTheme in [ETManager sharedInstance].weakArray) {
            [easeTheme updateThemes];
        }
        return YES;
    }
    return NO;
}

#pragma mark - fetch resource

+ (NSDictionary *)getEaseThemeConfigFileData {
    if (_themeDic) {
        return _themeDic;
    }
    if (!ISValidString(_resourcesPath)) {
        NSString *currentThemeName = [self getCurrentThemeName];
        _resourcesPath = [self et_getSourceFilePathWithName:currentThemeName];
        NSData *data = [NSData dataWithContentsOfFile:_resourcesPath];
        if (!data) return nil;
        _themeDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }else{
        _themeDic = [NSDictionary dictionaryWithContentsOfFile:_resourcesPath];
    }
    if (!_themeDic||![_themeDic isKindOfClass:[NSDictionary class]]) return nil;
    return _themeDic;
}

@end

@implementation ETManager (ETSerialization)

+ (NSDictionary *)et_getObjVectorOperationKV {
    return @{
             kETArgColor : @"et_colorWithPath:",
             };
}

+ (UIColor *)et_colorWithPath:(NSString *)path {
    NSString *colorHexStr = [[self getEaseThemeConfigFileData] valueForKeyPath:path];
    if (!ISValidString(colorHexStr)) return nil;
    return [self et_colorFromString:colorHexStr];
}

@end

@implementation ETManager (ETTool)

+ (UIColor *)et_colorFromString:(NSString *)hexStr {
    hexStr = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([hexStr hasPrefix:@"0x"]) {
        hexStr = [hexStr substringFromIndex:2];
    }
    if ([hexStr hasPrefix:@"#"]) {
        hexStr = [hexStr substringFromIndex:1];
    }
    
    NSUInteger hex = [self _intFromHexString:hexStr];
    if (hexStr.length>6) {
        return ETRGBHex(hex);
    }
    return ETRGBHex(hex);
}

+ (NSUInteger)_intFromHexString:(NSString *)hexStr {
    unsigned int hexInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner scanHexInt:&hexInt];
    return hexInt;
}

@end
