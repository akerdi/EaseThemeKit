//
//  SHEaseTheme.m
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/28.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import "EaseTheme.h"
#import "ETManager.h"
#import "ETTrash.h"

#import <objc/message.h>

#pragma mark - FORMAT OF SEL

char *const kETSELHeader = "set";
char *const kETSELCon = ":";

NSString *const kET2DStateSELTail = @"forState:";
NSString *const kET2DAnimatedSELTail = @"animated:";

#pragma mark - Config type of arg

NSString *const kETArgBool = @"com.et.arg.bool";
NSString *const kETArgFloat = @"com.et.arg.float";
NSString *const kETArgInt = @"com.et.arg.int";
NSString *const kETArgColor = @"com.et.arg.color";
NSString *const kETArgCGColor = @"com.et.arg.cgcolor";
NSString *const kETArgFont = @"com.et.arg.font";
NSString *const kETArgImage = @"com.et.arg.image";
NSString *const kETArgTextAttributes = @"com.et.arg.textAttributes";
NSString *const kETArgStatusBarStyle = @"com.et.arg.statusBarStyle";
NSString *const kETArgBarStyle = @"com.et.arg.barStyle";
NSString *const kETArgTitle = @"com.et.arg.title";
NSString *const kETArgKeyboardAppearance = @"com.et.arg.keyboardAppearance";
NSString *const kETArgActivityIndicatorViewStyle = @"com.et.arg.activityIndicatorViewStyle";

NSTimeInterval const ETThemeSkinChangeDuration = 0.25;

@interface EaseTheme ()

@property (nonatomic, assign) UIImageRenderingMode imageRenderingMode;

@property (nonatomic, strong) NSDictionary *innerSkins1D;

@property (nonatomic, strong) NSDictionary *innerSkins2D;

@end

@implementation EaseTheme

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:NSLocalizedString(@"Please use +easeThemeWithThemer: method instead", nil) userInfo:nil];
}

- (NSDictionary *)innerSkins1D {
    if (_innerSkins1D) return _innerSkins1D;
    return _innerSkins1D = [NSMutableDictionary dictionaryWithCapacity:0];
}

- (NSDictionary *)innerSkins2D {
    if (_innerSkins2D) return _innerSkins2D;
    return _innerSkins2D = [NSMutableDictionary dictionaryWithCapacity:0];
}

- (NSMutableDictionary *)getSkins1D {
    return (NSMutableDictionary *)self.innerSkins1D;
}

- (NSMutableDictionary *)getSkins2D {
    return (NSMutableDictionary *)self.innerSkins2D;
}

- (NSDictionary *)skins1D {
    return [NSDictionary dictionaryWithDictionary:self.innerSkins1D];
}

- (NSDictionary *)skins2D {
    return [NSDictionary dictionaryWithDictionary:self.innerSkins2D];
}

- (instancetype)initWithThemer:(id)themer {
    if (self=[super init]) {
        _themer = themer;
        _imageRenderingMode = UIImageRenderingModeAlwaysOriginal;
        [[ETManager sharedInstance] addThemer:self];
    }
    return self;
}

+ (instancetype)easeThemeWithThemer:(id)themer {
    return [[self alloc] initWithThemer:themer];
}

- (void)setImageRenderingMode:(UIImageRenderingMode)renderingMode {
    _imageRenderingMode = renderingMode;
}

- (void)updateThemes {
    [self updateThemeWith1DSkins:[self getSkins1D]];
}

#pragma mark - Test Refactor

- (id)getObjVectorWithArgType:(NSString *)argType path:(NSString *)path exist:(BOOL *)flag {
    NSString *selStr = [ETManager et_getObjVectorOperationKV][argType];
    if (ISValidString(selStr)&&ISValidString(path)) {
        *flag = YES;
        SEL sel = NSSelectorFromString(selStr);
        id(*msg)(id, SEL, id) = (id(*)(id, SEL, id))objc_msgSend;
        id vector = msg(ETManager.class, sel, path);
        if ([vector isKindOfClass:UIImage.class]) {
            vector = [vector imageWithRenderingMode:_imageRenderingMode];
        }
        return vector;
    }
    *flag = NO;
    return nil;
}

#pragma mark - 1D Update Methods

- (void)updateThemeWith1DSkins:(NSDictionary *)themeSkins1D {
    [themeSkins1D enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        SEL sel = NSSelectorFromString(key);
        if (![obj isKindOfClass:NSDictionary.class]) return ;
        NSDictionary *valueDict = (NSDictionary *)obj;
        NSArray *allKeys = valueDict.allKeys;
        
        NSString *skinKey = allKeys.firstObject;
        NSString *skinValue = valueDict[skinKey];
        
        BOOL flag = false;
        
        id firstObject = [self getObjVectorWithArgType:skinKey path:skinValue exist:&flag];
        
        if (flag) {
            [self send1DMsgWithSEL:sel structValue:firstObject];
            return;
        }
    }];
}

#pragma mark - Message Methods

#pragma mark - 1

- (instancetype)send1DMsgEnumWithName:(NSString *)name keyPath:(NSString *)keyPath arg:(NSString *)arg valueBlock:(NSInteger (^)(NSString *))valueBlock {
    return [self send1DMsgIntWithName:name keyPath:keyPath arg:arg valueBlock:valueBlock];
}

- (instancetype)send1DMsgObjectWithName:(NSString *)name keyPath:(NSString *)keyPath arg:(NSString *)arg valueBlock:(id (^)(NSString *))valueBlock {
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    if (!valueBlock) return [ETTrash easeThemeWithThemer:self];
    NSObject *obj = valueBlock(keyPath);
    [self send1DMsgWithSEL:sel structValue:obj];
    return self;
}

- (instancetype)send1DMsgIntWithName:(NSString *)name keyPath:(NSString *)keyPath arg:(NSString *)arg valueBlock:(NSInteger (^)(NSString *))valueBlock {
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    if (!valueBlock) return [ETTrash easeThemeWithThemer:self];
    NSInteger value = valueBlock(keyPath);
    [self send1DMsgWithSEL:sel intValue:value];
    return self;
}

- (instancetype)send1DMsgFloatWithName:(NSString *)name keyPath:(NSString *)keyPath arg:(NSString *)arg valueBlock:(CGFloat (^)(NSString *))valueBlock {
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    if (!valueBlock) return [ETTrash easeThemeWithThemer:self];
    CGFloat value = valueBlock(keyPath);
    
    [self send1DMsgWithSEL:sel floatValue:value];
    return self;
}

- (SEL)prepareForSkin1DWithName:(NSString *)name keyPath:(NSString *)keyPath argKey:(NSString *)argKey {
    const char *charName = name.UTF8String;
    SEL sel = getSelectorWithPattern(kETSELHeader, charName, kETSELCon);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:keyPath forKey:argKey];
    [[self getSkins1D] setObject:dict forKey:NSStringFromSelector(sel)];
    return sel;
}

#pragma mark - 2

- (instancetype)send2DMsgIntAndIntWithName:(NSString *)name keyPath:(NSString *)keyPath integer:(NSInteger)integer selTail:(NSString *)selTail argType:(NSString *)arg valueBlock:(NSObject *(^)(NSString *))valueBlock {
    SEL sel = [self prepareForSkin2DWithName:name keyPath:keyPath integer:integer argType:arg selTail:selTail];
    
    if (!valueBlock) return [ETTrash easeThemeWithThemer:self];
    NSObject *obj = valueBlock(keyPath);
    
    [self send2DMsgWithSEL:sel object:obj intValue:integer];
    return self;
}


- (SEL)prepareForSkin2DWithName:(NSString *)name keyPath:(NSString *)keyPath integer:(NSInteger)integer argType:(NSString *)argType selTail:(NSString *)selTail {
    const char *charName = name.UTF8String;
    SEL sel = getSelectorWithPattern(kETSELHeader, charName, kETSELCon);
    
    NSString *selStr = [NSStringFromSelector(sel) stringByAppendingString:selTail];
    NSString *selStrAppend = [selStr stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)integer]];
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [attrDict setObject:keyPath forKey:argType];
    [attrDict setObject:@(integer) forKey:kETArgInt];
    [[self getSkins2D] setObject:attrDict forKey:selStrAppend];
    return NSSelectorFromString(selStr);
}



#pragma mark - 1D Block

- (EaseThemeBlock)et_colorBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgObjectWithName:name keyPath:path arg:kETArgColor valueBlock:^NSObject *(NSString *keyPath) {
            return [ETManager et_colorWithPath:path];
        }];
    };
}
- (EaseThemeBlock)et_floatBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgFloatWithName:name keyPath:path arg:kETArgFloat valueBlock:^CGFloat(NSString *keyPath) {
            return [ETManager et_floatWithPath:keyPath];
        }];
    };
}
- (EaseThemeBlock)et_cgColorBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgObjectWithName:name keyPath:path arg:kETArgCGColor valueBlock:^id(NSString *keyPath) {
            return (id)[ETManager et_cgColorWithPath:keyPath];
        }];
    };
}
- (EaseThemeBlock)et_titleBockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgObjectWithName:name keyPath:path arg:kETArgTitle valueBlock:^id(NSString *keyPath) {
            return [ETManager et_stringWithPath:keyPath];
        }];
    };
}
- (EaseThemeBlock)et_fontBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgObjectWithName:name keyPath:path arg:kETArgFont valueBlock:^id(NSString *keyPath) {
            return [ETManager et_fontWithPath:keyPath];
        }];
    };
}
- (EaseThemeBlock)et_keyboardAppearanceBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgEnumWithName:name keyPath:path arg:kETArgKeyboardAppearance valueBlock:^NSInteger(NSString *keyPath) {
            return [ETManager et_keyboardAppearanceWithPath:keyPath];
        }];
    };
}
- (EaseThemeBlock)et_textAttributesBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgObjectWithName:name keyPath:path arg:kETArgTextAttributes valueBlock:^id(NSString *keyPath) {
            return [ETManager et_titleTextAttributesDictionaryWithPath:keyPath];
        }];
    };
}
- (EaseThemeBlock)et_boolBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgFloatWithName:name keyPath:path arg:kETArgFloat valueBlock:^CGFloat(NSString *keyPath) {
            return [ETManager et_boolWithPath:keyPath];
        }];
    };
}
- (EaseThemeBlock)et_imageBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgObjectWithName:name keyPath:path arg:kETArgImage valueBlock:^id(NSString *keyPath) {
            return [ETManager et_imageWithPath:keyPath];
        }];
    };
}

- (EaseThemeBlock)et_indicatorViewStyleBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgIntWithName:name keyPath:path arg:kETArgActivityIndicatorViewStyle valueBlock:^NSInteger(NSString *keyPath) {
            return [ETManager et_activityIndicatorStyleWithPath:keyPath];
        }];
    };
}
- (EaseThemeBlock)et_barStyleBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgIntWithName:name keyPath:path arg:kETArgBarStyle valueBlock:^NSInteger(NSString *keyPath) {
            return [ETManager et_barStyleWithPath:keyPath];
        }];
    };
}

#pragma mark - 2D Block

- (EaseTheme2DUIntBlock)et_titleColorForStateBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path, UIControlState state) {
        return [self send2D]
    }
}
- (EaseTheme2DUIntBlock)et_imageForStateBlockWithName:(NSString *)name;
- (EaseTheme2DUIntBlock)et_titleTextAttributesForStateBlockWithName:(NSString *)name;
- (EaseTheme2DUIntBlock)et_applicationForStyleBlockWithName:(NSString *)name {
    return <#expression#>
}


#pragma mark - 1 MsgSend

- (void)send1DMsgWithSEL:(SEL)sel intValue:(NSInteger)value {
    if ([self.themer respondsToSelector:sel]) {
        void(*msg)(id, SEL, NSInteger) = (void(*)(id, SEL, NSInteger))objc_msgSend;
        msg(self.themer, sel, value);
    }
}

- (void)send1DMsgWithSEL:(SEL)sel floatValue:(CGFloat)value {
    if ([self.themer respondsToSelector:sel]) {
        void(*msg)(id, SEL, CGFloat) = (void(*)(id, SEL, CGFloat))objc_msgSend;
        msg(self.themer, sel, value);
    }
}

- (BOOL)send1DMsgWithSEL:(SEL)sel structValue:(id)obj {
    if (!obj || ![self.themer respondsToSelector:sel]) return NO;
    void(*msg)(id, SEL, id) = (void(*)(id, SEL, id))objc_msgSend;
    if ([obj isKindOfClass:[UIColor class]]) {
        __block typeof(self) weakSelf = self;
        msg(weakSelf.themer, sel, obj);
    } else {
        msg(self.themer, sel, obj);
    }
    return YES;
}

#pragma mark - 2 MsgSend

- (void)send2DMsgWithSEL:(SEL)sel object:(NSObject *)obj intValue:(NSInteger)value {
    if (obj && [self.themer respondsToSelector:sel]) {
        void(*msg)(id, SEL, id, NSInteger) = (void(*)(id, SEL, id, NSInteger))objc_msgSend;
        msg(self.themer, sel, obj, value);
    }
}

- (void)send2DMsgWithSEL:(SEL)sel intValue:(NSInteger)value1 intValue:(NSInteger)value2 {
    if ([self.themer respondsToSelector:sel]) {
        void(*msg)(id, SEL, NSInteger, NSInteger) = (void(*)(id, SEL, NSInteger, NSInteger))objc_msgSend;
        msg(self.themer, sel, value1, value2);
    }
}

@end


#pragma mark - NSObject + ET

void const *kETKey = &kETKey;

@implementation NSObject(ET)
@dynamic et;

- (EaseTheme *)et {
    EaseTheme *et = objc_getAssociatedObject(self, kETKey);
    if (!et) {
        et = [EaseTheme easeThemeWithThemer:self];
        objc_setAssociatedObject(self, kETKey, et, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[ETManager sharedInstance] addThemer:self];
    }
    return et;
}

@end
