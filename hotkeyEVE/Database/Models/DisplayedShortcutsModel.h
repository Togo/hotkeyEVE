//
//  DisplayedShortcutsModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/5/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayedShortcutsModel : NSObject

+ (void) insertDisplayedShortcut :(NSDictionary*) eventHintShorcutDic;
+ (BOOL) checkShortcutTimeIntervall :(NSDictionary*) eventHintShorcutDic;

@end
