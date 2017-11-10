//
//  ETButton.h
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/30.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import "ETView.h"

ETBlockDeclare(ETButton)
ET2DStateBlockDeclare(ETButton)

@interface ETButton : ETView

- (ETButtonBlock)backgroundColor;
- (ETButtonBlock)alpha;
- (ETButtonBlock)tintColor;

- (ETButton2DStateBlock)title;
- (ETButton2DStateBlock)titleColor;
- (ETButton2DStateBlock)image;
- (ETButton2DStateBlock)backgroundImage;

@end

ETThemeCategoryDeclare(UIButton, ETButton)
