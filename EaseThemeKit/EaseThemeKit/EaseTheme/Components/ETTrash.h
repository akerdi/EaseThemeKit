//
//  ETTrash.h
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/31.
//  Copyright © 2017年 XXT. All rights reserved.
//


//  针对不支持的 Sakura 类型进行响应，如：UIAppearance 等类。
#import "EaseTheme.h"

typedef void(^ETThemeTrashBlock)(id);

@interface ETTrash : EaseTheme
- (ETThemeTrashBlock)barTintColor;
- (ETThemeTrashBlock)tintColor;
- (ETThemeTrashBlock)titleTextAttributes;

@end
