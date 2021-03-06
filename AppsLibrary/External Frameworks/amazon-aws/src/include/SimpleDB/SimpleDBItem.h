/*
 * Copyright 2010-2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "SimpleDBAttribute.h"



/**
 * Item
 *
 * \ingroup SimpleDB
 */

@interface SimpleDBItem:NSObject

{
    NSString       *name;
    NSString       *alternateNameEncoding;
    NSMutableArray *attributes;
}



/**
 * The name of the item.
 */
@property (nonatomic, retain) NSString *name;

/**
 *
 */
@property (nonatomic, retain) NSString *alternateNameEncoding;

/**
 * A list of attributes.
 */
@property (nonatomic, retain) NSMutableArray *attributes;


/**
 * Default constructor for a new Item object.  Callers should use the
 * property methods to initialize this object after creating it.
 */
-(id)init;

/**
 * Constructs a new Item object.
 * Callers should use properties to initialize any additional object members.
 *
 * @param theName The name of the item.
 * @param theAttributes A list of attributes.
 */
-(id)initWithName:(NSString *)theName andAttributes:(NSMutableArray *)theAttributes;

/**
 * Adds a single object to attributes.
 * This function will alloc and init attributes if not already done.
 */
-(void)addAttribute:(SimpleDBAttribute *)attributeObject;

/**
 * Returns a string representation of this object; useful for testing and
 * debugging.
 *
 * @return A string representation of this object.
 */
-(NSString *)description;


@end
