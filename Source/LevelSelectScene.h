//
//  LevelSelectScene.h
//  MatchX
//
//  Created by Renan Benevides Cargnin on 3/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCScene.h"
//#import "GADBannerView.h"

@interface LevelSelectScene : CCScene
{
    CCSprite *background;
    
    NSMutableArray *levelIcons;
    CCNode *levelIconsNode;
    
    CCScrollView *scroll;
    
    NSArray *savedData;
    
    //GADBannerView *bannerView;
}

- (LevelSelectScene *)init;

@end
