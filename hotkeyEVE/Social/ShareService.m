//
//  Twitter.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/25/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "ShareService.h"

@implementation ShareService

- (id) init {
  self = [super init];
  
  if (self) {
    // Twitter
    self.tweetSharingService = [NSSharingService sharingServiceNamed:NSSharingServiceNamePostOnTwitter];
    
    // Facebook
    self.facebookSharingService = [NSSharingService sharingServiceNamed:NSSharingServiceNamePostOnFacebook];
    
    // Facebook
    self.mailSharingService = [NSSharingService sharingServiceNamed:NSSharingServiceNameComposeEmail];
  }
  return self;
}

+ (ShareService*) shareService {
  ShareService *shareService = [[ShareService alloc] init];
  
  return shareService;
}

- (void)tweetWithItems :(NSArray*) shareItems {
  /*
   Perform the service using the array of items.
   */
  [self.tweetSharingService performWithItems:shareItems];
}

- (void) postOnFacebookWithItems :(NSArray*) shareItems {
  /*
   Perform the service using the array of items.
   */
  [self.facebookSharingService performWithItems:shareItems];
}

- (void) mailWithItems :(NSArray*) shareItems {
  /*
   Perform the service using the array of items.
   */
  [self.mailSharingService performWithItems:shareItems];
}




@end
