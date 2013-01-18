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

#import "AmazonDictionaryUnmarshaller.h"

@implementation AmazonDictionaryUnmarshaller

@synthesize key, value, dictionary, keyXpathElement, valueXpathElement, entryEndElement;


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];

    // Found the Key Element for the Dictionary Entry
    if ([elementName isEqualToString:keyXpathElement]) {
        self.key = self.currentText;
        return;
    }

    // Found the Value Element for the Dictionary Entry
    if ([elementName isEqualToString:valueXpathElement]) {
        self.value = self.currentText;
        return;
    }

    // Found the End of Entry Element for the Dictionary Entry
    if ([elementName isEqualToString:entryEndElement]) {
        [self.dictionary setValue:self.value forKey:key];

        if (caller != nil) {
            [parser setDelegate:caller];
        }

        if (parentObject != nil && [parentObject respondsToSelector:parentSetter]) {
            [parentObject performSelector:parentSetter withObject:self.dictionary];
        }

        return;
    }
}

-(NSMutableDictionary *)dictionary
{
    if (nil == dictionary) {
        dictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return dictionary;
}

-(void)dealloc
{
    [dictionary release];
    [key release];
    [value release];
    [keyXpathElement release];
    [valueXpathElement release];
    [entryEndElement release];

    [super dealloc];
}

@end
