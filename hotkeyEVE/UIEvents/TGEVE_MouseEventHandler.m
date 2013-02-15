//
//  TGEVEMouseEvent.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_MouseEventHandler.h"
#import "TGEVE_MenuItemEvent.h"
#import <UIElements/NullUIElement.h>
#import <UIElements/MenuItem.h>
#import "DisabledShortcutsModel.h"
#import "DisplayedShortcutsModel.h"
#import "TGEVE_GUIElementEvent.h"

@implementation TGEVE_MouseEventHandler

@synthesize event = _event;

- (void) handleEVEEvent :(UIElement*) element {
  DDLogInfo(@"TGEVE_MouseEventHandler -> handleEVEEvent(element :%@:) :: get called", element);
  if ( element == nil )
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Clicked UIElement is nil" userInfo:nil];

  if ( _event == nil ) // Unit Tests
    _event = [self createEvent :element];

  NSArray *eventShortcutHintList = [_event searchForShortcuts :element];
  if (    [eventShortcutHintList count] > 0
      && ![self isShortcutDisabled :eventShortcutHintList]
      &&  [self isTimeIntevallOk :eventShortcutHintList]   ) {

      [_event displayNotification :eventShortcutHintList];
      [self insertInDisplayedShortcutsDB :eventShortcutHintList];
  }
}

- (id<TGEVE_IUIEvent>) createEvent :(UIElement*) element {
  if ( [element isKindOfClass:[NullUIElement class]] ) {
    DDLogInfo(@"TGEVE_MouseEventHandler -> createEvent() :: UIElement not supported");
    return nil;
  }  else if( [element isKindOfClass:[MenuItem class]] ) {
    DDLogInfo(@"TGEVE_MouseEventHandler -> createEvent() :: Menu Item Event");
    return [[TGEVE_MenuItemEvent alloc] init];
  } else {
    DDLogInfo(@"TGEVE_MouseEventHandler -> createEvent() :: GUI Element Event");
    return [[TGEVE_GUIElementEvent alloc] init];  // if not an menu bar and not null then it's a gui element event
  }
}

- (BOOL) isShortcutDisabled :(NSArray*) eventShortcutHintList {
  if ( [eventShortcutHintList count] > 1 )
    return NO; // Display multiple message anyway
   else
     return [DisabledShortcutsModel isShortcutDisabled :[eventShortcutHintList objectAtIndex:0]];
}

- (BOOL) isTimeIntevallOk :(NSArray*) eventShortcutHintList {
    if ( [eventShortcutHintList count] == 1 )
      return [DisplayedShortcutsModel checkShortcutTimeIntervall :[eventShortcutHintList objectAtIndex:0]];
    else
      return YES;
}

- (void) insertInDisplayedShortcutsDB :(NSArray*) eventShortcutHintList {
  if ( [eventShortcutHintList count] == 1 )
    [DisplayedShortcutsModel insertDisplayedShortcut:[eventShortcutHintList objectAtIndex:0]];
}

@end
