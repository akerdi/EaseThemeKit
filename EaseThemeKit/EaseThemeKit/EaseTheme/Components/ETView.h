//
//  ETView.h
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/30.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import "EaseTheme.h"

ETBlockDeclare(ETView)

@interface ETView : EaseTheme

- (ETViewBlock)backgroundColor;

@end

@interface UIView (ET)
@property (nonatomic, strong) ETView *et;
@end
