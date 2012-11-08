//
//  LicenceWindowController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/8/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "LicenceWindowController.h"
#import "EVEUtilities.h"

@interface LicenceWindowController ()

@end

@implementation LicenceWindowController


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)registerButton:(id)sender {
  NSString *aLicenceString = [liceneKeyTextField stringValue];
  NSString *theEmaiAddress = [eMailTextField stringValue];
  
  Licence *licencing = [[EVEManager sharedEVEManager] licence];
  NSString *receivedMessage = [licencing registerAVersion :aLicenceString :theEmaiAddress];
  
  if ([receivedMessage isEqualToString:@"Ok"]) {
    NSAlert *alert = [NSAlert alertWithMessageText:@"You registration was successfull. \nEVE needs now a restart!"
                                     defaultButton:@"Restart EVE" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(restartAfterRegistering) contextInfo:NULL];
   } else {

     NSAlert *alert = [NSAlert alertWithMessageText:@"Something went wrong!"
                                      defaultButton:@"OK"
                                    alternateButton:nil
                                        otherButton:nil
                          informativeTextWithFormat:(receivedMessage ? @"%@" : @"%@"), receivedMessage];
     [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:NULL];
   }
}

- (void) restartAfterRegistering {
  [EVEUtilities restartEVE];
}

@end
