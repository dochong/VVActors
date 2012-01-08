//
//  VVActor.h
//  Actors
//
//  Created by Duncan Steele on 07/01/2012.
//  Copyright (c) 2012 Valletta Ventures LLP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVMessage.h"

/**
 * class to represent an actor
 *
 * subclass this and add methods to deal with the specific messages the actor may be passed
 * for example if you declare
 *  -(void)someMethod:(VVMessage*)amessage
 * then it will be passed any message where amessage.selector is @selector(someMethod:)
 *
 */
@interface VVActor : NSThread

/**
 * call this with a message to be dispatched in this Actor's thread
 */
-(void)sendMessage:(VVMessage*)aMessage;

@end