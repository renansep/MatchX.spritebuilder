//
//  GameLayer.h
//  MatchX
//
//  Created by Renan Benevides Cargnin on 3/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameLayer : CCNode
{
    CCNode *numbersLayer;
    
    NSMutableArray *numbers;
}

@end
