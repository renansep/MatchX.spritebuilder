//
//  GameNumber.h
//  MatchX
//
//  Created by Renan Cargnin on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNodeColor.h"

@interface GameNumber : CCNodeColor
{
    int intValue;
    CCLabelTTF *numberLabel;
    
    CCNodeColor *background;
    
    BOOL isEmpty;
}

@property int intValue;
@property BOOL isEmpty;

- (GameNumber *)initEmpty;
- (BOOL)selected;
- (void)setSelected:(BOOL)s;
- (void)runDestroyAnimation;
+ (void)setSize:(CGSize)s;
+ (CGSize)size;
+ (void)setMinNumber:(int)n;
+ (void)setMaxNumber:(int)n;

@end
