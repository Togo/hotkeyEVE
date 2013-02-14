//
//  GUIElementsTable.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/7/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppsLibrary/AppsLibrary.h>
#import <UIElements/UIElement.h>

@interface TGEVE_GUIElementsTableModel : NSObject

- (NSArray*) searchInGUIElementTable :(UIElement*) element;

- (void) insertGUIElementsFromAppModule :(AppModule*) app;
- (void) removeGUIElementsWithID :(NSInteger) theID;

@end
