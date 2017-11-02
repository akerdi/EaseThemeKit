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

NSString *const kETArgColor = @"com.et.arg.color";

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

- (instancetype)send1DMsgEnumWithName:(NSString *)name keyPath:(NSString *)keyPath arg:(NSString *)arg valueBlock:(NSInteger (^)(NSString *))valueBlock {
    return nil;
}

- (instancetype)send1DMsgObjectWithName:(NSString *)name keyPath:(NSString *)keyPath arg:(NSString *)arg valueBlock:(id(^)(NSString *))valueBlock {
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    if (!valueBlock) return [ETTrash easeThemeWithThemer:self];
    NSObject *obj = valueBlock(keyPath);
    [self send1DMsgWithSEL:sel structValue:obj];
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

- (EaseThemeBlock)et_colorBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1DMsgObjectWithName:name keyPath:path arg:kETArgColor valueBlock:^NSObject *(NSString *keyPath) {
            return [ETManager et_colorWithPath:path];
        }];
    };
}
//- (EaseThemeBlock)et_floatBlockWithName:(NSString *)name {
//
//}
//- (EaseThemeBlock)et_cgColorBlockWithName:(NSString *)name {
//
//}
//- (EaseThemeBlock)et_titleBockWithName:(NSString *)name {
//
//}
//- (EaseThemeBlock)et_fontBlockWithName:(NSString *)name {
//
//}
//- (EaseThemeBlock)et_keyboardAppearanceBlockWithName:(NSString *)name {
//
//}
//- (EaseThemeBlock)et_textAttributesBlockWithName:(NSString *)name {
//
//}
//- (EaseThemeBlock)et_boolBlockWithName:(NSString *)name {
//
//}
//- (EaseThemeBlock)et_imageBlockWithName:(NSString *)name {
//
//}

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
