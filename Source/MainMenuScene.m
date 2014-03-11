//
//  MainMenuScene.m
//  MatchX
//
//  Created by Renan Cargnin on 3/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MainMenuScene.h"

@implementation MainMenuScene

- (void)didLoadFromCCB
{
    NSLog(@"Main Menu loaded.");
    
    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"Sprites/number9.png"];
    [sprite setPosition:CGPointMake(100, 100)];
    [self addChild:sprite];
    [sprite setScale:2];
    NSLog(@"Width: %f", sprite.contentSizeInPoints.width);
    NSLog(@"Height: %f", sprite.contentSizeInPoints.height);
}

- (void)startGame:(id)sender
{
    NSLog(@"startGame");
}

@end
