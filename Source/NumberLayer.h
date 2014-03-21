//
//  NumberLayer.h
//  MatchX
//
//  Created by Renan Cargnin on 3/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNodeColor.h"

@class GameNumber, GameScene;

@interface NumberLayer : CCNodeColor
{
    GameScene *gameScene;
    
    NSMutableArray *numbers;
    NSMutableArray *numbersBackground;
    
    //last number touched by the player
    GameNumber *lastNumberSelected;
    
    int numbersSelected;
    
    //the current operation (add, sub, mult, div)
    NSString *operation;
    NSArray *operations; //array of operations
    
    //the max number of operands that the calculation can have
    int maxOperands;
    
    //the current objective number for the player
    int result;
    
    //stores the player path along the numbers
    NSMutableArray *trace;
}

- (NumberLayer *)initWithLevel:(NSDictionary *)level;
- (int)generateResult;
- (void)generateOperation;
- (void)setScene:(GameScene *)scene;

@property NSString *operation;
@property int result;

@end
