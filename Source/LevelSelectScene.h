//
//  LevelSelectScene.h
//  MatchX
//
//  Created by Renan Benevides Cargnin on 3/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCScene.h"

@interface LevelSelectScene : CCScene
{
    CCSprite *background;
    
    NSMutableArray *levelIcons;
    CCNode *levelIconsNode;
    
    CCScrollView *scrollView;
    
    NSDictionary *savedData;
}

- (LevelSelectScene *)init;

@end
