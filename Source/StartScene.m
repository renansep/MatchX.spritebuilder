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
    
    [tapAnywhereLabel setZOrder:2];
    
    //Creates the tutorial level
    tutorialLevel = [NSMutableDictionary new];
    [tutorialLevel setObject:[NSArray arrayWithObjects:@"+", nil] forKey:@"operations"];
    [tutorialLevel setObject:[NSNumber numberWithInt:20] forKey:@"calculationTime"];
    [tutorialLevel setObject:[NSNumber numberWithInt:10000] forKey:@"calculationNumber"];
    [tutorialLevel setObject:[NSNumber numberWithInt:2] forKey:@"maxOperands"];
    [tutorialLevel setObject:[NSArray arrayWithObjects:@"111", @"111", @"111", nil] forKey:@"map"];
    [tutorialLevel setObject:[NSNumber numberWithInt:1] forKey:@"minNumber"];
    [tutorialLevel setObject:[NSNumber numberWithInt:10] forKey:@"maxNumber"];
    [tutorialLevel setObject:[NSNumber numberWithBool:YES] forKey:@"tutorial"];
    
    [tutorialLabel setZOrder:2];
    
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
    
    result = [numberLayer result];
    [resultLabel setString:[NSString stringWithFormat:@"X = %d", result]];
    
    for (NSString *op in [numberLayer operations])
    {
        if (op == [[numberLayer operations] firstObject])
        {
            [operatorsLabel setString:op];
        }
        else
        {
            [operatorsLabel setString:[NSString stringWithFormat:@"%@ %@", operatorsLabel.string, op]];
        }
    }
    
    [self schedule:@selector(blinkTapAnywhereLabel) interval:0.75];
    
    //Overlay
    overlay = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:0.5] width:viewSize.width height:viewSize.height];
    [overlay setVisible:NO];
    [overlay setZOrder:1];
    [self addChild:overlay];
    
    [self startTutorialAnimation];
    
    self.userInteractionEnabled = YES;
}

- (void)blinkTapAnywhereLabel
{
    [tapAnywhereLabel setVisible:![tapAnywhereLabel visible]];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{

}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCScene *levelSelectionScene = [LevelSelectScene new];
    [[CCDirector sharedDirector] replaceScene:levelSelectionScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
}

- (void)update:(CCTime)delta
{
    if (result != [numberLayer result])
    {
        result = [numberLayer result];
        [resultLabel setString:[NSString stringWithFormat:@"X = %d", result]];
    }
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
    [overlay setVisible:NO];
    
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Usando os operadores..." afterDelay:2];
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Caminhe entre os números..." afterDelay:5];
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Para encontrar o X!" afterDelay:8];
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Fique de olho no tempo!" afterDelay:11];
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Seja rápido para \nganhar mais pontos!" afterDelay:14];
    [self performSelector:@selector(updateTutorialLabel:) withObject:@"Como jogar" afterDelay:17];
    
    [self performSelector:@selector(darkScreenExcept:) withObject:notePaper afterDelay:2];
    [self performSelector:@selector(darkScreenExcept:) withObject:paper afterDelay:5];
    [self performSelector:@selector(darkScreenExcept:) withObject:notePaper afterDelay:8];
    [self performSelector:@selector(darkScreenExcept:) withObject:clockNode afterDelay:11];
    [self performSelector:@selector(darkScreenExcept:) withObject:scoreNode afterDelay:14];
    
    [self runScaleAnimationWithNode:operatorsLabel andDelay:2 andScaleMax:3 andScaleMin:0.5];
    [self runScaleAnimationWithNode:resultLabel andDelay:8 andScaleMax:1.5 andScaleMin:0.5];
    [self runScaleAnimationWithNode:clockNode andDelay:11 andScaleMax:1.2 andScaleMin:0.8];
    [self runScaleAnimationWithNode:scoreNode andDelay:14 andScaleMax:1.2 andScaleMin:0.8];
}

- (void)runScaleAnimationWithNode:(CCNode *)node andDelay:(float)delay andScaleMax:(float)scaleMax andScaleMin:(float)scaleMin
{
    CCActionScaleTo *scaleToMax = [CCActionScaleTo actionWithDuration:0.5 scale:scaleMax];
    CCActionScaleTo *scaleToMin = [CCActionScaleTo actionWithDuration:0.5 scale:scaleMin];
    CCActionScaleTo *scaleToBack = [CCActionScaleTo actionWithDuration:0.5 scale:1];
    
    CCActionSequence *scaleAnimation = [CCActionSequence actions:scaleToMax, scaleToMin, scaleToMax, scaleToMin, scaleToMax, scaleToBack, nil];
    
    [node runAction:[CCActionSequence actions:[CCActionDelay actionWithDuration:delay], scaleAnimation, nil]];
}

- (void)darkScreenExcept:(CCNode *)node
{
    CCActionCallBlock *overlayInFront = [CCActionCallBlock actionWithBlock:^{
        [overlay setVisible:YES];
        [node setZOrder:1];
    }];
    CCActionDelay *interval = [CCActionDelay actionWithDuration:3];
    CCActionCallBlock *hideOverlay = [CCActionCallBlock actionWithBlock:^{
        [node setZOrder:0];
    }];
    CCActionSequence *sequence = [CCActionSequence actions:overlayInFront, interval, hideOverlay, nil];
    [self runAction:sequence];
}

@end
