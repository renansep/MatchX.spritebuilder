//
//  StartScene.m
//  MatchX
//
//  Created by Renan Cargnin on 3/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StartScene.h"
#import "LevelSelectScene.h"

@implementation StartScene

- (void)didLoadFromCCB
{
    [background setScaleX:[[CCDirector sharedDirector] viewSize].width / background.contentSize.width];
    [background setScaleY:[[CCDirector sharedDirector] viewSize].height / background.contentSize.height];
    
    [self schedule:@selector(blinkTapAnywhereLabel) interval:0.5];
    
    self.userInteractionEnabled = YES;
}

- (void)blinkTapAnywhereLabel
{
    [tapAnywhereLabel setVisible:![tapAnywhereLabel visible]];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCScene *levelSelectionScene = [LevelSelectScene new];
    [[CCDirector sharedDirector] replaceScene:levelSelectionScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
}

@end
