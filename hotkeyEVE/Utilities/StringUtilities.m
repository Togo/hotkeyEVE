//
//  StringUtilities.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "StringUtilities.h"
#import <UIElements/UIElement.h>

@implementation StringUtilities

+ (NSString*) databaseString :(NSString*) str {
  return [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

+ (NSString*) printUIElement :(UIElement*) element {
  NSMutableString *formattedString = [NSMutableString string];
  [formattedString appendString:@"******************************** \n"];
  [formattedString appendString:@"**********  UIElement   ******** \n"];
  [formattedString appendString:@"******************************** \n"];
  [formattedString appendString:@"******************************** \n"];
  [formattedString appendFormat:@"Role => :%@: \n", [element role]];
  [formattedString appendFormat:@"Role Description => :%@: \n", [element roleDescription]];
  [formattedString appendFormat:@"Title => :%@: \n", [element title]];
  [formattedString appendFormat:@"ParentTitle => :%@: \n", [element parentTitle]];
  [formattedString appendFormat:@"Identifier => :%@: \n", [element uiElementIdentifier]];
  [formattedString appendString:@"******************************** \n"];
  
  return formattedString;
}


@end
