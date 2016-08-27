//
//  Migration.h
//  Database
//
//  Created by Tobias Sommer on 10/30/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FmdbMigrationManager.h"

@protocol Migration <NSObject>

- (void) addMigrationObject :(id) migrationObject;
- (void) executeMigrations :(NSString*) databasePath;


@end
