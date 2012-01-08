//
//  VVMessage.m
//  Actors
//
//  Created by Duncan Steele on 07/01/2012.
//  Copyright (c) 2012 Valletta Ventures LLP. All rights reserved.
//

#import "VVMessage.h"

@implementation VVMessage

@synthesize selector;

-(id)initWithSelector:(SEL)aSelector {
    self = [super init];
    if (self) {
        selector = aSelector;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] initWithSelector:self.selector];
}

@end