//
//  GameScene.h
//  MatchX
//
//  Created by Renan Cargnin on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
@class NumberLayer;

@interface GameScene : CCNode
{
    NumberLayer *numbersLayer;
    
    CCSprite *paper;
    CCSprite *board;
    
    CCLabelTTF *clockLabel;
    int remainingTime;
    int calculationTime;
    
    CCNodeColor *bottomNode;
    CCLabelTTF *resultLabel;
    CCLabelTTF *operationLabel;
    CCLabelTTF *scoreLabel;
    CCLabelTTF *calculationLabel;
    int calculationLabelOriginalFontSize;
    
    int score;
    
    CCSprite *background;
}

- (void)updateResult:(int)newResult;
- (void)updateOperation:(NSString *)newOperation;

- (void)increaseScore:(int)ammount;
- (void)updateScore;

- (void)increaseRemainingTime;

- (void)updateCalculationLabel:(NSString *)text;
- (void)clearCalculationLabel;

@end
