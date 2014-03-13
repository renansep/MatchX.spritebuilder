//
//  MainMenuScene.m
//  MatchX
//
//  Created by Renan Cargnin on 3/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameScene.h"

@implementation MainMenuScene

- (void)didLoadFromCCB
{
    NSLog(@"Main Menu loaded.");
}

- (void)startGame:(id)sender
{
    NSLog(@"startGame");
    CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
}

@end
