//
//  YATranslateTextFromAppleScript.m
//  fast translator
//
//  Created by Alex Yakubchyk on 4/3/13.
//  Copyright (c) 2013 Alex Yakubchyk. All rights reserved.
//

#import "YATranslateTextFromAppleScript.h"

@implementation YATranslateTextFromAppleScript

-(id)performDefaultImplementation {
    
    // get the arguments
    NSDictionary *args = [self evaluatedArguments];
    NSString *stringToTranslate = @"";
    if(args.count) {
        stringToTranslate = [args valueForKey:@""];    // get the direct argument
    } else {
        // raise error
        [self setScriptErrorNumber:-50];
        [self setScriptErrorString:@"No arguments were found"];
    }
    // Implement your code logic (in this example, I'm just posting an internal notification)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppShouldTranslateStringNotification" object:stringToTranslate];
    return nil;
}

@end
