//
//  NSAlert+Blocks.m
//  Objc-Util
//
//  Created by Tobias Sommer on 2/24/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "NSAlert+Blocks.h"

@interface NSAlert()


@end

@implementation NSAlert (Blocks)

+ (NSAlert*) alert {
  return [[self alloc] init];
}

- (void) showModalAlertSheetForWindow        :(NSWindow*) window
                             message         :(NSString*) messageText
                             informativeText :(NSString*) informativeText
                             alertStyle      :(NSAlertStyle) alertStyle
                             buttonBlocks    :(NSDictionary*) blocks
                             buttonTitle     :(NSString*) button1, ... NS_REQUIRES_NIL_TERMINATION {
  id eachObject;
  va_list argumentList;
    if ( button1 ) {// The first argument isn't part of the varargs list, so we'll handle it separately.
      [self addButtonWithTitle:button1];
      va_start(argumentList, button1); // Start scanning for arguments after firstObject.
      while ( (eachObject = va_arg(argumentList, id)) ) // As many times as we can get an argument of type "id"
        [self addButtonWithTitle:eachObject];
      va_end(argumentList);
    } else {
      @throw [NSException exceptionWithName:NSInternalInconsistencyException
                        reason:@"I need at least one Button to show an modal alert." userInfo:nil];
  }

  [self setMessageText :messageText ? messageText : @""];
  [self setInformativeText :informativeText ? informativeText : @""];
  [self setAlertStyle :alertStyle];
  
  [self displayAlert :window];
}

- (void) displayAlert :(NSWindow*) window { //untested
  [self beginSheetModalForWindow:window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode
        contextInfo :(void *)contextInfo {
  
}

@end
