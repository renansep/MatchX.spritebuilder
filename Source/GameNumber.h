//
//  GameNumber.h
//  MatchX
//
//  Created by Renan Cargnin on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface GameNumber : CCSprite
{
    int intValue;
    
    CCNodeColor *background;
    
    BOOL isEmpty;
}

@property int intValue;
@property BOOL isEmpty;

- (BOOL)selected;
- (void)setSelected:(BOOL)s;
- (void)runDestroyAnimation;
- (GameNumber *)initEmpty;

@end
