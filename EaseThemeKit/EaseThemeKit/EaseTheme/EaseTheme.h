//
//  SHEaseTheme.h
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/28.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

- (instancetype)initWithThemeWithThemer:(id)themer;

- (void)setImageRenderingMode:(UIImageRenderingMode)renderingMode;

/**
 //更新主题方法 !!!
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

@end

@interface NSObject (ET)
@property (nonatomic, strong) EaseTheme *et;
@end
