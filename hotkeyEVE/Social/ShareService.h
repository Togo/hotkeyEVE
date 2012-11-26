//
//  Twitter.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/25/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareService : NSObject {
  

}

@property (strong) NSSharingService *tweetSharingService;
@property (strong) NSSharingService *facebookSharingService;
@property (strong) NSSharingService *mailSharingService;

+ (ShareService*) shareService;
- (void)tweetWithItems :(NSArray*) shareItems;
- (void) postOnFacebookWithItems :(NSArray*) shareItems;
- (void) mailWithItems :(NSArray*) shareItems;

@end
