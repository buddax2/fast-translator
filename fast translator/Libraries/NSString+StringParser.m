//
//  NSString+StringParser.m
//  PlayBar
//
//  Created by Alex Yakubchyk on 1/22/13.
//
//

#import "NSString+StringParser.h"

@implementation NSString (StringParser)

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSScanner* scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end
                         intoString:&result]) {
            return result;
        }
    }
    return nil; 
}

@end
