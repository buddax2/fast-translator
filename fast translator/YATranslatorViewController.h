//
//  YATranslatorViewController.h
//  fast translator
//
//  Created by Alex Yakubchyk on 4/3/13.
//  Copyright (c) 2013 Alex Yakubchyk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class YAAppDelegate;

@interface YATranslatorViewController : NSViewController <NSURLConnectionDataDelegate, NSTextDelegate, NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *sourceTextView;
@property (assign) YAAppDelegate *delegate;
@property (weak) IBOutlet NSTextField *leftLanguageLabel;
@property (weak) IBOutlet NSTextField *rightLanguageLabel;
@property (weak) IBOutlet WebView *webView;

@end
