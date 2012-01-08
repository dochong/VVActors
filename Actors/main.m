//
//  main.m
//  Actors
//
//  Created by Duncan Steele on 07/01/2012.
//  Copyright (c) 2012 Valletta Ventures LLP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVActor.h"

// a simple VVActor subclass to simply pass a message onto another actor
@interface TestActor : VVActor {
    VVActor *nextInChain;
}

@property (nonatomic, assign) VVActor *nextInChain;
@property NSInteger index;

-(void)passItOn:(VVMessage*)aMessage;

@end

@implementation TestActor

@synthesize nextInChain, index;

-(void)passItOn:(VVMessage *)aMessage { 
    NSLog(@"passItOn: for id %ld",index);
    [nextInChain sendMessage:aMessage];
}

@end

int main (int argc, const char * argv[]) {
    @autoreleasepool {
        // setup and boot three actors        
        TestActor   *actor1 = [[TestActor alloc] init],
                    *actor2 = [[TestActor alloc] init],
                    *actor3 = [[TestActor alloc] init];        
        actor1.index = 1;               // these indices are for debugging purposes
        actor2.index = 2;
        actor3.index = 3;
        actor1.nextInChain = actor2;    // setup the actors in a loop so that they keep running
        actor2.nextInChain = actor3;
        actor3.nextInChain = actor1;
        [actor1 start];
        [actor2 start];
        [actor3 start];

        // send a message to the first actor
        VVMessage *aMessage = [[VVMessage alloc] initWithSelector:@selector(passItOn:)];
        [actor1 sendMessage:aMessage];
        [aMessage release]; // we can release the message right away, it has been copied by the actor
        
        // let it do its thing for 10 seconds
        sleep(10);

        // cancel and release the actors
        [actor1 cancel];
        [actor2 cancel];
        [actor3 cancel];
        [actor1 release];
        [actor2 release];
        [actor3 release];
    }
    return 0;
}

