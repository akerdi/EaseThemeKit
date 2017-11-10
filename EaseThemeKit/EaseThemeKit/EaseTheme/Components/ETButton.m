
//
//  ETButton.m
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/30.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import "ETButton.h"

@implementation ETButton

- (ETButtonBlock)backgroundColor {
    return (ETButtonBlock)[super backgroundColor];
}

- (ETButtonBlock)alpha {
    return (ETButtonBlock)[super alpha];
}

- (ETButtonBlock)tintColor {
    return (ETButtonBlock)[super tintColor];
}

#pragma mark - 2D

- (ETButton2DStateBlock)title {
    return (ETButton2DStateBlock)[super et_titleForStateBlockWithName:NSStringFromSelector(_cmd)];
}

- (ETButton2DStateBlock)titleColor {
    return (ETButton2DStateBlock)[super et_titleColorForStateBlockWithName:NSStringFromSelector(_cmd)];
}

- (ETButton2DStateBlock)image {
    return (ETButton2DStateBlock)[super et_imageForStateBlockWithName:NSStringFromSelector(_cmd)];
}

- (ETButton2DStateBlock)backgroundImage {
    return (ETButton2DStateBlock)[super et_imageForStateBlockWithName:NSStringFromSelector(_cmd)];
}

@end

ETThemeCategoryImplementation(UIButton, ETButton)
