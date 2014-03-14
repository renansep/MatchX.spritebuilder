//
//  GameScene.m
//  MatchX
//
//  Created by Renan Cargnin on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "NumberLayer.h"

@implementation GameScene

- (void)didLoadFromCCB
{
    NSLog(@"Main Menu loaded.");
    
    int random = arc4random() % 15 + 2;
    numbersLayer = [[NumberLayer alloc] initWithLines:random andWithColumns:random];
    [numbersLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [numbersLayer setPosition:CGPointMake([[CCDirector sharedDirector] viewSize].width / 2, [[CCDirector sharedDirector] viewSize].height / 2)];
    [self addChild:numbersLayer];
    
    
    [numbersLayer setScale:[[CCDirector sharedDirector] viewSize].width / numbersLayer.contentSize.width];
    self.userInteractionEnabled = YES;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)back:(id)sender
{
    CCScene *mainMenuScene = [CCBReader loadAsScene:@"MainMenuScene"];
    [[CCDirector sharedDirector] replaceScene:mainMenuScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
}

@end
