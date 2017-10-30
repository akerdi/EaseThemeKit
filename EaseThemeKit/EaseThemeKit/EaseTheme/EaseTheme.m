//
//  SHEaseTheme.m
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/28.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import "EaseTheme.h"

#import <objc/message.h>

#pragma mark - FORMAT OF SEL

char *const kETSELHeader = "set";

NSString *const kET2DStateSELTail = @"forState:";
NSString *const kET2DAnimatedSELTail = @"animated:";

#pragma mark - Config type of arg

NSString *const kETArgColor = @"com.et.arg.color";


@implementation EaseTheme

- (void)updateThemes {
    
}

#pragma mark - Message Methods

- (instancetype)send1PMsgEnumWithName:(NSString *)name keyPath:(NSString *)keyPath arg:(NSString *)arg valueBlock:(NSInteger (^)(NSString *))valueBlock {
    return nil;
}

- (instancetype)send1PMsgObjectWithName:(NSString *)name keyPath:(NSString *)keyPath arg:(NSString *)arg valueBlock:(id(^)(NSString *))valueBlock {
    SEL sel = NULL;
}

- (SEL)prepareForSkin1PWithName:(NSString *)name keyPath:(NSString *)keyPath argKey:(NSString *)argKey {
    const char *charName = name.UTF8String;
    SEL sel = NULL;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:keyPath forKey:argKey];
}



- (EaseThemeBlock)et_floatBlockWithName:(NSString *)name {
    
}
- (EaseThemeBlock)et_colorBlockWithName:(NSString *)name {
    return ^EaseTheme *(NSString *path) {
        return [self send1PMsgObjectWithName:name keyPath:path arg:kETArgColor valueBlock:^NSObject *(NSString *keyPath) {
            return <#expression#>
        }]
    }
}
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
    }
    return et;
}

@end
