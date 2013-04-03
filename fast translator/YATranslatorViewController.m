//
//  YATranslatorViewController.m
//  fast translator
//
//  Created by Alex Yakubchyk on 4/3/13.
//  Copyright (c) 2013 Alex Yakubchyk. All rights reserved.
//

#import "YATranslatorViewController.h"
#import "SBJsonParser.h"

static NSString * const translatorURL = @"http://translate.yandex.net/api/v1/tr.json/translate";

@interface YATranslatorViewController ()

@end

@implementation YATranslatorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(translateTextFromAppleScript:) name:@"AppShouldTranslateStringNotification" object:nil];
    }
    
    return self;
}

// TODO: API has limit to 10 000 requests.
// So this method can exhaust this limit
//- (void)textDidChange:(NSNotification *)notification {
//    [self translateText:nil];
//}

- (IBAction)translateText:(id)sender {
    NSString *sourceString = _sourceTextView.textStorage.string;

    if (sourceString.length > 0)
    {
        [self translate:sourceString];
    }
}

- (void)translateTextFromAppleScript:(NSNotification*)notification
{
    NSString *stringToTranslate = notification.object;
    self.sourceTextView.string = stringToTranslate;
    
    [self translate:stringToTranslate];
}

- (void)translate:(NSString*)source {
    NSURLRequest *request = [self prepareURLRequestForString:source];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSURLRequest*)prepareURLRequestForString:(NSString*)string {
    NSURL *URL = [NSURL URLWithString:translatorURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    NSString *params = [NSString stringWithFormat:@"lang=ru&text=%@", string];
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%li", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (data)
    {
        NSString *translatedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        SBJsonParser* parser = [[SBJsonParser alloc] init];
        // assuming jsonString is your JSON string...
        NSDictionary* responceList = [parser objectWithString:translatedString];

        self.translateTextView.string = @"";
        NSMutableString *temp = [[NSMutableString alloc] init];
        
        for (NSString *textLine in responceList[@"text"])
        {
            [temp appendString:textLine];
        }
        
        self.translateTextView.string = temp;
    }
}

@end
