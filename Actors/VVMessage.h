//
//  VVMessage.h
//  Actors
//
//  Created by Duncan Steele on 07/01/2012.
//  Copyright (c) 2012 Valletta Ventures LLP. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * a class to represent messages passed between actors
 *
 * subclass this to add properties to custom messages.
 * NB don't forget to override the copy method in any subclass.
 */
@interface VVMessage : NSObject <NSCopying> {
    SEL selector;
}

/// when the message is processed by an actor, this message will be passed to the method specified by selector
@property (readonly) SEL selector;

/**
 * initialise a message
 *
 * @param aSelector when the message is processed by an actor, this message will be passed to the method specified by aSelector
 */
-(id)initWithSelector:(SEL)aSelector;

@end