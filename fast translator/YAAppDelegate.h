//
//  YAAppDelegate.h
//  fast translator
//
//  Created by Alex Yakubchyk on 4/3/13.
//  Copyright (c) 2013 Alex Yakubchyk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YATranslatorViewController.h"

@interface YAAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet YATranslatorViewController *translatorViewController;
@property (weak) IBOutlet NSDrawer *historyPanel;

- (void)toggleHistoryPanelState;

@end
