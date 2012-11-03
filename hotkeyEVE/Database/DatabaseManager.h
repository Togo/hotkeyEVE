//
//  DatabaseManager.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVEDatabase.h"

@interface DatabaseManager : NSObject {

}

@property (nonatomic, retain)   EVEDatabase *eveDatabase;

+ (id)sharedDatabaseManager;

@end