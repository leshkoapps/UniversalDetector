//
//  UniversalDetector.m
//  UniversalDetector
//
//  Created by Francis Chong on 7/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//


#import "UniversalDetector.h"
#import "uchardet.h"

@implementation UniversalDetector

- (instancetype)init{
    self = [super init];
    if (self){
        _detector = uchardet_new();
    }
    return self;
}

- (void)dealloc{
    uchardet_delete(_detector);
}

- (NSStringEncoding)encodingWithData:(NSData *)data{
    
    NSString *encodingName = [self encodingAsStringWithData:data];
    if ([encodingName isEqualToString:@""] || encodingName==nil) {
        return NSASCIIStringEncoding;
    }

    CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)encodingName);
    if(encoding==kCFStringEncodingInvalidId) {
        return NSASCIIStringEncoding;
    }
    
    // UniversalDetector detects CP949 but returns "EUC-KR" because CP949 lacks an IANA name.
    // Kludge to make strings decode properly anyway.
    if(encoding==kCFStringEncodingEUC_KR) {
        encoding=kCFStringEncodingDOSKorean;
    };
    
    NSStringEncoding result = CFStringConvertEncodingToNSStringEncoding(encoding);
    if (result==0){
        result = NSASCIIStringEncoding;
    }
    return result;
}

- (NSString *)encodingAsStringWithData:(NSData *)data{
    uchardet_handle_data(_detector, [data bytes], [data length]);
    uchardet_data_end(_detector);
    const char *charset = uchardet_get_charset(_detector);
    NSString *encoding = [NSString stringWithCString:charset encoding:NSUTF8StringEncoding];
    uchardet_reset(_detector);
    return encoding;
}

+ (NSStringEncoding)encodingWithData:(NSData *)data{
    return [[[UniversalDetector alloc] init] encodingWithData:data];
}

+ (NSString *)encodingAsStringWithData:(NSData *)data{
    return [[[UniversalDetector alloc] init] encodingAsStringWithData:data];
}

@end