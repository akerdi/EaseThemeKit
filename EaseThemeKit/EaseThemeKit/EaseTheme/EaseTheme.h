//
//  SHEaseTheme.h
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/28.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define ETThemeCategoryDeclare(ClassName, PropertyClassName)\
@interface ClassName (ET)\
@property (nonatomic, strong) PropertyClassName *et;\
@end

#define ETThemeCategoryImplementation(ClassName, PropertyClassName)\
extern void *kETKey;\
@implementation ClassName (ET)\
@dynamic et;\
- (PropertyClassName *)et {\
    PropertyClassName *obj = objc_getAssociatedObject(self, kETKey);\
    if (!obj) {\
        obj = [PropertyClassName easeThemeWithThemer:self];\
        objc_setAssociatedObject(self, kETKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
    }\
    return obj;\
}\
@end

#define ETBlockDeclare(Class)\
@class Class;\
typedef Class *(^Class##Block)(NSString *);

#define ET2DStateBlockDeclare(Class)\
@class Class;\
typedef Class *(^Class##2DStateBlock)(NSString *, UIControlState);

#define ET2DBoolBlockDeclare(Class)\
typedef Class *(^Class##2DBoolBlock)(NSString *,BOOL);

#define ET2DUIntBlockDeclare(Class)\
typedef Class *(^Class##2DUIntBlock)(NSString *, NSUInteger);

#define ETBlockCustomDeclare(Class)\
typedef Class *(^Class##CustomBlock)(NSString *property, NSString *keyPath);


ETBlockDeclare(EaseTheme)
ET2DUIntBlockDeclare(EaseTheme)
ET2DBoolBlockDeclare(EaseTheme)
@interface EaseTheme : NSObject

@property (strong, nonatomic, readonly) NSDictionary *skins1D;
@property (strong, nonatomic, readonly) NSDictionary *skins2D;

@property (weak, nonatomic, readonly) id themer;

+ (instancetype)easeThemeWithThemer:(id)themer;

- (instancetype)initWithThemer:(id)themer;

- (void)setImageRenderingMode:(UIImageRenderingMode)renderingMode;

/**
 * 更新主题方法 !!!
 * ETManager 内部更新时轮训使用使用
 */
- (void)updateThemes;

@end

@interface EaseTheme (ETBlocker)

- (EaseThemeBlock)et_floatBlockWithName:(NSString *)name;
- (EaseThemeBlock)et_colorBlockWithName:(NSString *)name;
- (EaseThemeBlock)et_cgColorBlockWithName:(NSString *)name;
- (EaseThemeBlock)et_titleBockWithName:(NSString *)name;
- (EaseThemeBlock)et_fontBlockWithName:(NSString *)name;
- (EaseThemeBlock)et_keyboardAppearanceBlockWithName:(NSString *)name;
- (EaseThemeBlock)et_textAttributesBlockWithName:(NSString *)name;
- (EaseThemeBlock)et_boolBlockWithName:(NSString *)name;
- (EaseThemeBlock)et_imageBlockWithName:(NSString *)name;
- (EaseThemeBlock)et_indicatorViewStyleBlockWithName:(NSString *)name;
- (EaseThemeBlock)et_barStyleBlockWithName:(NSString *)name;

- (EaseTheme2DUIntBlock)et_titleForStateBlockWithName:(NSString *)name;
- (EaseTheme2DUIntBlock)et_titleColorForStateBlockWithName:(NSString *)name;
- (EaseTheme2DUIntBlock)et_imageForStateBlockWithName:(NSString *)name;
- (EaseTheme2DUIntBlock)et_titleTextAttributesForStateBlockWithName:(NSString *)name;
- (EaseTheme2DBoolBlock)et_applicationForStyleBlockWithName:(NSString *)name;

@end

@interface NSObject (ET)
@property (nonatomic, strong) EaseTheme *et;
@end
