//
//  SHEaseThemeManager.m
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/28.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import "SHEaseThemeManager.h"

@interface SHEaseThemeManager ()
@property (nonatomic, strong) NSHashTable *weakArray;


@end

@implementation SHEaseThemeManager

+ (instancetype)sharedInstance{
    static SHEaseThemeManager *easeThemeManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        easeThemeManager = [SHEaseThemeManager new];
    });
    return easeThemeManager;
}

- (instancetype)init{
    if (self=[super init]) {
        self.weakArray = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

@end
