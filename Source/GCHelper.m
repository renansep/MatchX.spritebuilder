//
//  GCHelper.m
//  MatchX
//
//  Created by Renan Cargnin on 4/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GCHelper.h"
#import <GameKit/GameKit.h>

@implementation GCHelper

@synthesize gameCenterAvailable;

static GCHelper *sharedHelper = nil;

+ (GCHelper *)sharedInstance
{
    if (!sharedHelper)
    {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

- (GCHelper *)init
{
    if (self = [super init])
    {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable)
        {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
    }
    return self;
}

- (BOOL)isGameCenterAvailable
{
    //check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    //check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    return (gcClass && osVersionSupported);
}

- (void)authenticationChanged
{
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated)
    {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = YES;
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated)
    {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = NO;
    }
}

- (void)authenticateLocalUser
{
    if (!gameCenterAvailable) return;
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO)
    {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    }
    else
    {
        NSLog(@"Already authenticated");
    }
}

- (void)submitScore:(int64_t)score forCategory:(NSString *)category
{
    if ([self isGameCenterAvailable])
    {
        GKScore *newScore = [[GKScore alloc] initWithCategory:category];
        [newScore setValue:[newScore value] + score];
        [newScore reportScoreWithCompletionHandler:nil];
    }
}

@end
