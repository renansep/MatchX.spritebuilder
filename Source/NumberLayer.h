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
    int numbersSelected;
    GameNumber *lastNumberSelected;
    
    NSMutableArray *trace;
}

- (NumberLayer *)initWithLines:(int)lines andWithColumns:(int)columns;

@end
