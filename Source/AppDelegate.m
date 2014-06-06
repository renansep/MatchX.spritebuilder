/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"

#import "AppDelegate.h"
#import "CCBuilderReader.h"
#import "Game.h"
#import "GCHelper.h"

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    GCHelper *gcHelper = [GCHelper sharedInstance];
    [gcHelper authenticateLocalUser];
    
    // iCloud setup
    // register to observe notifications from the store
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector (storeDidChange:)
     name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification
     object: [NSUbiquitousKeyValueStore defaultStore]];
    
    id currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    if (currentiCloudToken) {
        NSData *newTokenData =
        [NSKeyedArchiver archivedDataWithRootObject: currentiCloudToken];
        [[NSUserDefaults standardUserDefaults]
         setObject: newTokenData
         forKey: @"com.apportable.MatchX.UbiquityIdentityToken"];
    } else {
        [[NSUserDefaults standardUserDefaults]
         removeObjectForKey: @"com.apportable.MatchX.UbiquityIdentityToken"];
        [self setInitialLocalSavedData];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector (iCloudAccountAvailabilityChanged:)
     name: NSUbiquityIdentityDidChangeNotification
     object: nil];
    
    if (currentiCloudToken && [[[NSUserDefaults standardUserDefaults] objectForKey:@"promptedToUseiCloud"] boolValue] == NO) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Choose Storage Option"
                              message: @"Should documents be stored in iCloud and available on all your devices?"
                              delegate: self
                              cancelButtonTitle: @"Local Only"
                              otherButtonTitles: @"Use iCloud", nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"promptedToUseiCloud"];
    }
    // iCloud setup finished
    
    return YES;
}

- (CCScene*) startScene
{
    return [CCBReader loadAsScene:@"StartScene"];
}

- (void)iCloudAccountAvailabilityChanged:(id)sender
{
    NSLog(@"User logged in or out from iCloud");
}

- (void)setInitialLocalSavedData
{
    NSArray *savedData = [Game getArrayFromPlistFileInDocumentsFolderWithFileName:@"LevelsSavedData"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"useiCloud"];
    if (savedData == nil)
    {
        savedData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LevelsSavedData" ofType:@"plist"]];
        [Game saveArray:savedData ToDocumentsFolderInPlistFile:@"LevelsSavedData"];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSArray *savedData = [Game getArrayFromPlistFileInDocumentsFolderWithFileName:@"LevelsSavedData"];
    if (buttonIndex == 0)
    {
        [self setInitialLocalSavedData];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"useiCloud"];
        
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
        NSArray *iCloudSavedData = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"LevelsSavedData"];
        
        if (savedData != nil)
        {
            NSArray *iCloudSavedData = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"LevelsSavedData"];
            
            if (savedData.count == 0 && iCloudSavedData.count == 0)
            {
                [[NSUbiquitousKeyValueStore defaultStore] setObject:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LevelsSavedData" ofType:@"plist"]] forKey:@"LevelsSavedData"];
            }
            else if (savedData.count > iCloudSavedData.count)
            {
                [[NSUbiquitousKeyValueStore defaultStore] setObject:savedData forKey:@"LevelsSavedData"];
            }
            else
            {
                [[NSUbiquitousKeyValueStore defaultStore] setObject:iCloudSavedData forKey:@"LevelsSavedData"];
            }
        }
        else
        {
            if (iCloudSavedData == nil)
                [[NSUbiquitousKeyValueStore defaultStore] setObject:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LevelsSavedData" ofType:@"plist"]] forKey:@"LevelsSavedData"];
        }
    }
}

- (void)storeDidChange:(NSNotification *)notification
{
    NSUbiquitousKeyValueStore *ubiquitousKeyValueStore = notification.object;
    [ubiquitousKeyValueStore synchronize];
}

@end
