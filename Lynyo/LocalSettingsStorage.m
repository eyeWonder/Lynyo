//
//  BookmarkHelper.m
//  com.placestars.offlinemaps
//
//  Created by Dmitri Fedortchenko on 28.04.13.
//  Copyright (c) 2013 libosmscout. All rights reserved.
//

#import "LocalSettingsStorage.h"

@implementation LocalSettingsStorage
static LocalSettingsStorage *sLocalSettingsStorage = nil;
+( LocalSettingsStorage* ) sharedInstance
{
    static LocalSettingsStorage* sLocalSettingsStorage = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        sLocalSettingsStorage = [ [ self alloc ] init ];
    } );
    return sLocalSettingsStorage;
}


+(void)setSetting:(NSString*)name value:(NSString*)value;
{
    @try{
        [ LocalSettingsStorage sharedInstance ];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:value forKey:name];
        
        [prefs synchronize];
    }
    @catch(NSException* e)
    {
    }
}
+(NSString*)getSetting:(NSString*)name;
{
    @try{
        [ LocalSettingsStorage sharedInstance ];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *val = [prefs objectForKey:name];
        
        return val;
    }
    @catch(NSException* e)
    {
     }
    return @"";
}
+(void)deleteSetting:(NSString*)name;
{
    @try{
        [ LocalSettingsStorage sharedInstance ];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:nil forKey:name];
        
        [prefs synchronize];
    }
    @catch(NSException* e)
    {
    }
}
@end
