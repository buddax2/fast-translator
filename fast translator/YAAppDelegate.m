//
//  YAAppDelegate.m
//  fast translator
//
//  Created by Alex Yakubchyk on 4/3/13.
//  Copyright (c) 2013 Alex Yakubchyk. All rights reserved.
//

#import "YAAppDelegate.h"
#import "YATranslatorViewController.h"

@implementation YAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.translatorViewController = [[YATranslatorViewController alloc] initWithNibName:@"YATranslatorViewController" bundle:nil];
    self.translatorViewController.delegate = self;
    
    [self.window.contentView addSubview:self.translatorViewController.view];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag
{
    if (flag) {
        return NO;
    } else {
        [self.window orderFront:self];
        return YES;
    }	
}

@end
