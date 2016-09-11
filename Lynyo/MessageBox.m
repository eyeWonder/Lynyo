//
//  MessageBox.m
//  Libs
//
//  Created by sergey on 02.06.16.
//  Copyright © 2016 sergey. All rights reserved.
//

#import "MessageBox.h"
#import <UIKit/UIKit.h>

@implementation MessageBox
+(void)show:(NSString*)title message:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alert show];
}
@end
