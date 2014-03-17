//
//  NumberLayer.h
//  MatchX
//
//  Created by Renan Cargnin on 3/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNodeColor.h"
@class GameNumber;

@interface NumberLayer : CCNodeColor
{
    NSMutableArray *numbers;
    NSMutableArray *numbersBackground;
    
    //last number touched by the player
    GameNumber *lastNumberSelected;
    
    int numbersSelected;
    
    //the current operation (add, sub, mult, div)
    NSString *operation;
    
    //the max number of operands that the calculation can have
    int maxOperands;
    
    //the current objective number for the player
    int result;
    
    //stores the player path along the numbers
    NSMutableArray *trace;
}

- (NumberLayer *)initWithLines:(int)lines andWithColumns:(int)columns;
- (int)generateResult;
- (void)generateOperation;

@property NSString *operation;
@property int result;

@end
