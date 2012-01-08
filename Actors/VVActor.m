//
//  VVActor.m
//  Actors
//
//  Created by Duncan Steele on 07/01/2012.
//  Copyright (c) 2012 Valletta Ventures LLP. All rights reserved.
//

#import "VVActor.h"

@implementation VVActor

-(void)sendMessage:(VVMessage*)aMessage {
    // NB work with a copy of this message from now on (to avoid shared state)
    [self   performSelector:@selector(processMessage:)
                   onThread:self
                 withObject:[aMessage copy]
              waitUntilDone:NO];
}

// this is never declared as a message as such, it is called (albeit via the runloop) by sendMessage to dispatch the message to the correct method
-(void)processMessage:(VVMessage*)aMessage {
    if ([self respondsToSelector:aMessage.selector])
        [self   performSelector:aMessage.selector
                     withObject:aMessage];
    [aMessage release];
}

// this overrides an NSThread message
-(void)main {
    NSAutoreleasePool *runLoopPool = [[NSAutoreleasePool alloc] init];
    
    // create the runloop, will exit immediately with no sources
    [NSRunLoop currentRunLoop];
    
    // add a timer to the runloop to ensure it doesn't immediately exit
    [[NSRunLoop currentRunLoop] addTimer:[NSTimer timerWithTimeInterval:100
                                                                 target:self
                                                               selector:@selector(timerDummy:)
                                                               userInfo:nil
                                                                repeats:NO]
                                 forMode:NSDefaultRunLoopMode];
    
    BOOL isRunning = YES;
    
    while(isRunning && !self.isCancelled) {        
        isRunning = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                             beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]]; 
        
        // occasionally drain the autorelease pool whilst the thread is running
        [runLoopPool release];
        runLoopPool = [[NSAutoreleasePool alloc] init];
    }
    
    [runLoopPool release];
}

@end