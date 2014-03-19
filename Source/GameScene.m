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
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"]];
    NSDictionary *level = [dictionary objectForKey:@"Level1"];
    
    numbersLayer = [[NumberLayer alloc] initWithLevel:level];
    [numbersLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [numbersLayer setPosition:CGPointMake([[CCDirector sharedDirector] viewSize].width / 2, [[CCDirector sharedDirector] viewSize].height / 2)];
    [numbersLayer setScale:[[CCDirector sharedDirector] viewSize].width * 0.90 / numbersLayer.contentSize.width];
    [self addChild:numbersLayer];
    
    [self updateResult:[numbersLayer result]];
    [self updateOperation:[numbersLayer operation]];
    
    [background setScaleX:([[CCDirector sharedDirector] viewSize].width / background.contentSize.width)];
    [background setScaleY:([[CCDirector sharedDirector] viewSize].height / background.contentSize.height)];
    
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

- (void)updateResult:(int)newResult
{
    [resultLabel setString:[NSString stringWithFormat:@"%d", newResult]];
}

- (void)updateOperation:(NSString *)newOperation
{
    [operationLabel setString:newOperation];
}

@end
