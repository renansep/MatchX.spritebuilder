//
//  LevelIcon.h
//  MatchX
//
//  Created by Renan Benevides Cargnin on 3/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCButton.h"

@interface LevelIcon : CCButton
{
    CCSprite *box;
    CCSprite *star1;
    CCSprite *star2;
    CCSprite *star3;
    CCSprite *lock;
    
    int levelNumber;
}

@property int levelNumber;

- (LevelIcon *)initLockedWithNumber:(int)n;
- (LevelIcon *)initUnlockedWithNumber:(int)n andStars:(int)s;
- (float)width;
- (float)height;
- (BOOL)locked;

@end
