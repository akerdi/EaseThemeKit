//
//  ETTrash.m
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/31.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import "ETTrash.h"

#define ETThemeTrashReturn return [self trashBlock];

@implementation ETTrash

- (ETThemeTrashBlock)trashBlock {
    return ^(id obj) {};
}

- (ETThemeTrashBlock)barTintColor {
    ETThemeTrashReturn
}

- (ETThemeTrashBlock)tintColor {
    ETThemeTrashReturn
}

- (ETThemeTrashBlock)titleTextAttributes {
    ETThemeTrashReturn
}

@end
