//
//  NSAlert+Blocks.h
//  Objc-Util
//
//  Created by Tobias Sommer on 2/24/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSAlert (Blocks)

+ (NSAlert*) alert;

- (void)    showModalAlertSheetForWindow        :(NSWindow*) window
                                message         :(NSString*) messageText
                                informativeText :(NSString*) informativeText
                                alertStyle      :(NSAlertStyle) alertStyle
                                buttonBlocks    :(NSDictionary*) blocks
                                buttonTitle     :(NSString*) button1, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark - Only for Unit Tests public

#if DEBUG
- (void) displayAlert :(NSWindow*) window;
- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode
        contextInfo:(void *)contextInfo;
#endif

@end
