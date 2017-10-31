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


extern void *kETKey;
@implementation UIView (ET)
@dynamic et;
- (ETView *)et {
    ETView *obj = objc_getAssociatedObject(self, kETKey);
    if (!obj) {
        obj = [ETView easeThemeWithThemer:self];
        objc_setAssociatedObject(self, kETKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}
@end
