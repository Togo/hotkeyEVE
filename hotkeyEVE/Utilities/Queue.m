//
//  Queue.m
//  EVE
//
//  Created by Tobias Sommer on 9/30/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Queue.h"

@implementation Queue

@synthesize count;

- (id)init
{
	if( self=[super init] )
	{
		m_array = [[NSMutableArray alloc] init];
		count = 0;
	}
	return self;
}

- (void)enqueueUnique:(id)anObject
{
  // check duplicate and leave method if array contains this string
  for (id oneObject in m_array) {
    // other classes as string

    if ([oneObject isEqualToString:anObject]) {      
      return;
    }
  }
  
  [self enqueue:anObject];
}

- (void)enqueue:(id)anObject {
 if (anObject != NULL ) {

	[m_array addObject:anObject];
	count = [m_array count];
 }
  
}

- (id)dequeue
{
	id obj = nil;
	if(m_array.count > 0)
	{
		obj = [m_array objectAtIndex:0];
		[m_array removeObjectAtIndex:0];
		count = [m_array count];
	}
	return obj;
}

- (void)clear
{
	[m_array removeAllObjects];
	count = 0;
}

@end

