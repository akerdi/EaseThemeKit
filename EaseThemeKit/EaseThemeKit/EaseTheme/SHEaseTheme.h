//
//  SHEaseTheme.h
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/28.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHEaseTheme : NSObject

@property (strong, nonatomic, readonly) NSDictionary *skins1D;
@property (strong, nonatomic, readonly) NSDictionary *skins2D;

@property (weak, nonatomic, readonly) id themer;

+ (instancetype)easeThemeWithThemer:(id)themer;

- (instancetype)initWithThemeWithThemer:(id)themer;

- (void)setImageRenderingMode:(UIImageRenderingMode)renderingMode;

@end
