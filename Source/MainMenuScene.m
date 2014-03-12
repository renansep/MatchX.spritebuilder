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
    
    numbers = [[NSMutableArray alloc] init];
    
    for (int i=0; i<8; i++)
    {
        CCSprite *sprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"number%d.png", arc4random() % 10]];
        [numbers addObject:sprite];
        [self addChild:sprite];
        [sprite setPosition:CGPointMake((i+1) * [CCDirector sharedDirector].viewSize.width / 8 - sprite.contentSize.width / 2, 100)];
    }
}

- (void)startGame:(id)sender
{
    NSLog(@"startGame");
}

@end
