//
//  Game.m
//  MatchX
//
//  Created by Renan Cargnin on 4/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Game.h"

@implementation Game

static NSString *language;

+ (NSDictionary *)getDictionaryFromPlistFileInDocumentsFolderWithFileName:(NSString *)fileName
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (NSArray *)getArrayFromPlistFileInDocumentsFolderWithFileName:(NSString *)fileName
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    return [NSArray arrayWithContentsOfFile:plistPath];
}

+ (void)saveDictionary:(NSDictionary *)dictionary ToDocumentsFolderInPlistFile:(NSString *)fileName
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
    }
}

+ (void)saveArray:(NSArray *)array ToDocumentsFolderInPlistFile:(NSString *)fileName
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:array format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    if(plistData)
    {
        [plistData writeToFile:plistPath atomically:YES];
    }
}

+ (NSString *)language
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

@end
