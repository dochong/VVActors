//
//  VVActor.m
//  Actors
//
//  Created by Duncan Steele on 07/01/2012.
//  Copyright (c) 2012 Valletta Ventures LLP. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
// * Neither the name of the <organization> nor the
//   names of its contributors may be used to endorse or promote products
//   derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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