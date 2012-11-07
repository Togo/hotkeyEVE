//
//  Queue.h
//  EVE
//
//  Created by Tobias Sommer on 9/30/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject {
	NSMutableArray* m_array;
}

- (void)enqueue:(id)anObject;
- (void)enqueueUnique:(id)anObject;
- (id)dequeue;
- (void)clear;

@property (nonatomic, readonly) long count;

@end

