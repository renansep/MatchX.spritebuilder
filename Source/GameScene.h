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
    
    CCNodeColor *bottomNode;
    CCLabelTTF *resultLabel;
    CCLabelTTF *operationLabel;
    
    CCSprite *background;
}

- (void)updateResult:(int)newResult;
- (void)updateOperation:(NSString *)newOperation;

@end
