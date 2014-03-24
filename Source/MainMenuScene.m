//
//  MainMenuScene.m
//  MatchX
//
//  Created by Renan Cargnin on 3/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameScene.h"
#import "LevelSelectScene.h"
#import "LevelIcon.h"

@implementation MainMenuScene

- (void)didLoadFromCCB
{
    LevelIcon *icon = [[LevelIcon alloc] initUnlockedWithNumber:10 andStars:1];
    [self addChild:icon];
    [icon setPosition:ccp(100, 100)];
}

- (void)startGame:(id)sender
{
    CCScene *gameScene = [LevelSelectScene new];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
}

@end
