//
//  ETView.m
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/30.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import "ETView.h"

@implementation ETView

- (ETViewBlock)backgroundColor {
    return (ETViewBlock)[super et_colorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

ETThemeCategoryImplementation(UIView, ETView);
