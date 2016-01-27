//
//  UniversalDetector.h
//  UniversalDetector
//
//  Created by Francis Chong on 7/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uchardet.h"

@interface UniversalDetector : NSObject {
@private
    uchardet_t _detector;
}

- (NSStringEncoding)encodingWithData:(NSData *)data;

- (NSString *)encodingAsStringWithData:(NSData *)data;

+ (NSStringEncoding)encodingWithData:(NSData *)data;

+ (NSString *)encodingAsStringWithData:(NSData *)data;

@end