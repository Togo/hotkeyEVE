//
//  EVEController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndexingController.h"

@interface EVEManager : NSObject {
  
}

@property (nonatomic, retain)   IndexingController  *indexing;

+ (id) sharedEVEManager;

@end
