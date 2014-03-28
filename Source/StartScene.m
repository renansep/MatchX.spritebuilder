//
//  StartScene.m
//  MatchX
//
//  Created by Renan Cargnin on 3/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StartScene.h"
#import "LevelSelectScene.h"
#import "NumberLayer.h"

@implementation StartScene

- (void)didLoadFromCCB
{
    CGSize viewSize = [[CCDirector sharedDirector] viewSize];
    
    [background setScaleX:viewSize.width / background.contentSize.width];
    [background setScaleY:viewSize.height / background.contentSize.height];
    
    //Creates the tutorial level
    tutorialLevel = [NSMutableDictionary new];
    [tutorialLevel setObject:[NSArray arrayWithObjects:@"+", nil] forKey:@"operations"];
    [tutorialLevel setObject:[NSNumber numberWithInt:20] forKey:@"calculationTime"];
    [tutorialLevel setObject:[NSNumber numberWithInt:10000] forKey:@"calculationNumber"];
    [tutorialLevel setObject:[NSNumber numberWithInt:2] forKey:@"maxOperands"];
    [tutorialLevel setObject:[NSArray arrayWithObjects:@"111", @"111", @"111", nil] forKey:@"map"];
    [tutorialLevel setObject:[NSNumber numberWithInt:1] forKey:@"minNumber"];
    [tutorialLevel setObject:[NSNumber numberWithInt:15] forKey:@"maxNumber"];
    [tutorialLevel setObject:[NSNumber numberWithBool:YES] forKey:@"tutorial"];
    
    numberLayer = [[NumberLayer alloc] initWithLevel:tutorialLevel];
    [numberLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [numberLayer setPosition:ccp(paper.contentSize.width / 2, paper.contentSize.height / 2)];
    if (numberLayer.contentSize.width > numberLayer.contentSize.height)
    {
        [numberLayer setScale:paper.contentSize.width * 0.85 / numberLayer.contentSize.width];
    }
    else
    {
        [numberLayer setScale:paper.contentSize.width * 0.85 / numberLayer.contentSize.height];
    }
    [paper addChild:numberLayer];
    
    [self schedule:@selector(blinkTapAnywhereLabel) interval:0.5];
    
    [self startTutorialAnimation];
    
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

- (void)updateTutorialLabel:(NSString *)newText
{
    [tutorialLabel setString:newText];
    if ([newText isEqualToString:@"Como jogar"])
    {
        [self startTutorialAnimation];
    }
}

- (void)startTutorialAnimation
{
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Usando os operadores..." afterDelay:2];
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Caminhe entre os números..." afterDelay:5];
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Para encontrar o X!" afterDelay:8];
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Fique de olho no tempo!" afterDelay:11];
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Seja rápido para \nganhar mais pontos!" afterDelay:14];
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Como jogar" afterDelay:17];
    
    [self runScaleAnimetionWithNode:operatorsLabel andDelay:2 andScaleMax:1.5 andScaleMin:0.5];
    [self runScaleAnimetionWithNode:resultLabel andDelay:8 andScaleMax:1.5 andScaleMin:0.5];
    [self runScaleAnimetionWithNode:clockNode andDelay:11 andScaleMax:1.2 andScaleMin:0.8];
    [self runScaleAnimetionWithNode:scoreNode andDelay:14 andScaleMax:1.2 andScaleMin:0.8];
}

- (void)runScaleAnimetionWithNode:(CCNode *)node andDelay:(float)delay andScaleMax:(float)scaleMax andScaleMin:(float)scaleMin
{
    CCActionScaleTo *scaleToMax = [CCActionScaleTo actionWithDuration:0.5 scale:scaleMax];
    CCActionScaleTo *scaleToMin = [CCActionScaleTo actionWithDuration:0.5 scale:scaleMin];
    CCActionScaleTo *scaleToBack = [CCActionScaleTo actionWithDuration:0.5 scale:1];
    
    CCActionSequence *scaleAnimation = [CCActionSequence actions:scaleToMax, scaleToMin, scaleToMax, scaleToMin, scaleToMax, scaleToBack, nil];
    
    [node runAction:[CCActionSequence actions:[CCActionDelay actionWithDuration:delay], scaleAnimation, nil]];
}

@end
