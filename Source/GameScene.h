//
//  GameScene.h
//  MatchX
//
//  Created by Renan Cargnin on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCScene.h"
@class NumberLayer;

@interface GameScene : CCScene
{
    NumberLayer *numbersLayer;
    
    CCSprite *paper;
    CCSprite *board;
    
    CCLabelTTF *clockLabel;
    int remainingTime;
    
    //Level calculation time for each operation
    int calculationTime;
    
    //Level number of calculations
    int calculationNumber;
    int calculationsCompleted;
    
    int maxOperands;
    
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
- (void)updateOperation:(NSArray *)newOperation;

- (void)increaseScoreWithMultiplier:(NSUInteger)multiplier;
- (void)updateScore;

- (void)increaseRemainingTime;
- (void)increaseCalculationsCompleted;

- (void)updateCalculationLabel:(NSString *)text;
- (void)clearCalculationLabel;

+ (void)setCurrentLevel:(int)l;
+ (int)currentLevel;

@end
