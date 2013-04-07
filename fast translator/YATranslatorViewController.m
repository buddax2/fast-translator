//
//  YATranslatorViewController.m
//  fast translator
//
//  Created by Alex Yakubchyk on 4/3/13.
//  Copyright (c) 2013 Alex Yakubchyk. All rights reserved.
//

#import "YATranslatorViewController.h"
#import "SBJsonParser.h"
#import "YAAppDelegate.h"
#import "NSString+StringParser.h"

typedef enum {
    FromEnglishToRussion = 0,
    FromRussionToEnglish = 1,
} TranslateDirection;

static NSString * const translatorURL = @"http://translate.yandex.net/api/v1/tr.json/translate";
static NSString * const yandexDictionaryURL = @"http://slovari.yandex.ru/%@/%@/";

//static NSString * const titleTranscriptionHTMLTemplate = @"<span class=\"b-translation__tr\">"
static NSString * const translatedTextHTMLTemplate = @"<html><body><div>%@</div><div>%@</dic></li></ul></li></ul></li></ul></div></body></html>";

@interface YATranslatorViewController ()
{
    NSDictionary    *_languages;
    NSUInteger       _translateDirectionInteger;
}
@end

@implementation YATranslatorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        _languages = @{@"en-ru":@"English", @"ru-en":@"Русский"};
        _translateDirectionInteger = FromEnglishToRussion;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(translateTextFromAppleScript:) name:@"AppShouldTranslateStringNotification" object:nil];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];

    [self configureTextView:self.sourceTextView];

    [self.sourceTextView becomeFirstResponder];
}

- (void)configureTextView:(NSTextView*)textView
{
    NSDictionary *attributes = @{NSFontAttributeName:[NSFont fontWithName:@"Helvetica" size:18]};

    [textView setTypingAttributes:attributes];
}

- (NSString*)translateDirectionString
{
    return _languages.allKeys[_translateDirectionInteger];
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

- (IBAction)changeTranslateDirection:(id)sender {
    _rightLanguageLabel.stringValue = _languages.allValues[_translateDirectionInteger];

    _translateDirectionInteger = (_translateDirectionInteger == FromRussionToEnglish) ? FromEnglishToRussion : FromRussionToEnglish;
    
    _leftLanguageLabel.stringValue = _languages.allValues[_translateDirectionInteger];
}

- (void)translateTextFromAppleScript:(NSNotification*)notification
{
    if (!self.delegate.window.isVisible)
    {
        [self.delegate.window makeKeyAndOrderFront:nil];
    }
        
    NSString *stringToTranslate = notification.object;
    self.sourceTextView.string = stringToTranslate;

    [self translate:stringToTranslate];
}

- (void)translate:(NSString*)source
{
    NSArray *wordsCount = [source componentsSeparatedByString:@" "];

    if (wordsCount.count == 1)
    {
        [self requestForWordTranslation:source];
    }
    else
    {
        NSURLRequest *request = [self prepareURLRequestForString:source];;
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }

}

- (void)requestForWordTranslation:(NSString*)word
{
    NSString *stringWithParams = [NSString stringWithFormat:yandexDictionaryURL, word, [self translateDirectionString]];
    stringWithParams = [stringWithParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:stringWithParams];

    NSError* error = nil;
    NSString *htmlString = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
    if(htmlString)
    {
        [self performSelectorOnMainThread:@selector(processWordTranslation:) withObject:htmlString waitUntilDone:NO];
    }
    else
    {
        NSLog(@"Error = %@", error);
    }
}

- (NSURLRequest*)prepareURLRequestForString:(NSString*)string {
    NSString *stringForURL = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:translatorURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    NSString *params = [NSString stringWithFormat:@"lang=%@&text=%@&format=html", [self translateDirectionString], stringForURL];
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
        [self performSelectorOnMainThread:@selector(processTextTranslation:) withObject:translatedString waitUntilDone:NO];
    }
}

- (void)processWordTranslation:(NSString*)translatedString
{
    NSString *title = [translatedString stringBetweenString:@"</label></span></span></div>" andString:@"[<span class=\"b-translation__tr\">"];
    NSString *titleTranscription = [translatedString stringBetweenString:@"<span class=\"b-translation__tr\">" andString:@"</span>"];
    titleTranscription = [NSString stringWithFormat:@"<strong style=\"fonst-size:18px;\">[%@]</strong>", titleTranscription];
    NSString *parsedString = [translatedString stringBetweenString:@"<div class=\"b-translation__article\">" andString:@"</div>"];
    NSString *htmlOutput = [NSString stringWithFormat:translatedTextHTMLTemplate, titleTranscription, parsedString];

    [[_webView mainFrame] loadHTMLString:htmlOutput baseURL:nil];
}

- (void)processTextTranslation:(NSString*)translatedString
{
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    // assuming jsonString is your JSON string...
    NSDictionary* responseList = [parser objectWithString:translatedString];

    NSMutableString *temp = [[NSMutableString alloc] init];

    for (NSString *textLine in responseList[@"text"])
    {
        [temp appendString:textLine];
    }

    NSString *htmlOutput = [NSString stringWithFormat:translatedTextHTMLTemplate, @"", temp];

    [[_webView mainFrame] loadHTMLString:htmlOutput baseURL:nil];
}

@end