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
        CCSprite *sprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"number%d.png", i]];
        [numbers addObject:sprite];
        [numbersLayer addChild:sprite];
        [sprite setPosition:CGPointMake(numbersLayer.contentSize.width, 0)];
    }
    
    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"number9.png"];
    [sprite setPosition:CGPointMake(100, 100)];
    [self addChild:sprite];
    NSLog(@"Width: %f", sprite.contentSizeInPoints.width);
    NSLog(@"Height: %f", sprite.contentSizeInPoints.height);
}

- (void)startGame:(id)sender
{
    NSLog(@"startGame");
}

@end
