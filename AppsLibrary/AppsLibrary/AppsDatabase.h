//
//  AppsDatabase.h
//  AppsLibrary
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AppsDatabase <NSObject>

-(NSArray*)getAppList;

@end
