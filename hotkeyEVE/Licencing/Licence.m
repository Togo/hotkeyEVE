//
//  Licence.m
//  EVE
//
//  Created by Tobias Sommer on 9/27/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Licence.h"
#import "NSFileManager+DirectoryLocations.h"
#import "StringUtilities.h"
#import "NSString+Hashes.h"

#import "EVEMessages.h"
#import "EVEUtilities.h"

@implementation Licence

@synthesize filePath;
@synthesize licenceString;
@synthesize eMail;
@synthesize hash;
@synthesize isValid;

// init method
- (id) init {
  self = [super init];
  
  if(self) {
    NSString *dictionary = [[NSFileManager defaultManager] applicationSupportDirectory];
    self.filePath = [NSString stringWithFormat:@"%@/%@", dictionary
                     , @"eve.licence"];
    NSData *licenceFile = [[NSData alloc] initWithContentsOfFile:self.filePath];
    if (licenceFile) {
      [self initLicenceData :licenceFile];
      
      NSString *checkedHash = [self createHash];
      if([self.hash isEqualToString:checkedHash]) {
        NSLog(@"Licence -> init :: licence valid");
        self.isValid = YES;
      }
    } else {
      NSLog(@"Licence -> init :: no licence file found");
      self.isValid = NO;
    }
  }
  
  return self;
}

- (void) initLicenceData :(NSData*) licenceFile {
  NSString *str = [[NSString alloc] initWithData:licenceFile encoding:NSUTF8StringEncoding];
  NSArray *chunks = [str componentsSeparatedByString: @"\n"];
  // order important for init method
  self.licenceString = [chunks objectAtIndex:0];
  self.eMail = [chunks objectAtIndex:1];
  self.hash = [chunks objectAtIndex:2];
  self.isValid = NO;
}

- (NSString*) registerAVersion :(NSString*) aLicenceString :(NSString*) theEMailAddress {
  DDLogInfo(@"Licence -> registerAVersion(aLicenceString => :%@:, theEMailAddress => :%@:) :: get called", self.licenceString,  self.eMail);
  NSString *error = [self validateRequest :aLicenceString :theEMailAddress];
  
  if ([error length] == 0) { // licence is valid else return error code
    self.licenceString  = aLicenceString;
    self.eMail = theEMailAddress;
    self.isValid = YES;
    self.hash = [self createHash];
    
    DDLogInfo(@"Licence -> registerAVersion :: registeredKey\nLicence=> :%@: \neMail=> :%@:", self.licenceString,  self.eMail);
    [self writeLicenceToFile];
    
    return @"Ok";
  } else {
    return error;
  }
}

- (NSString*)  validateRequest :(NSString*) aLicenceString :(NSString*) theEMail {
  DDLogInfo(@"Licence -> validateRequest(aLicenceString => :%@:, theEMailAddress => :%@:) :: Send a request registering request to the server", aLicenceString, theEMail);
  
  NSURL *url = [NSURL URLWithString:@"http://www.hotkey-eve.com/verify"];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"POST"];
  NSString *requestBodyString = [NSString stringWithFormat:@"{\"email\":\"%@\",\"serial\":\"%@\",\"mac\":\"%@\"}", theEMail, aLicenceString, [EVEUtilities getMacAddress]];
  NSData *requestBody = [requestBodyString dataUsingEncoding:NSUTF8StringEncoding];
  [request setHTTPBody:requestBody];
  
  NSURLResponse *response = NULL;
  NSError *requestError = NULL;
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
  if (!requestError) {
    NSString *responsedString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    DDLogInfo(@"Licence -> validateRequest :: request succesfull => :%@:", responsedString);
    return responsedString;
  } else {
    DDLogError(@"Licence -> validateRequest :: request with error => :%@:", [requestError localizedDescription]);
    return [requestError localizedDescription];
  }
}

- (void) writeLicenceToFile  {
    
    NSMutableString *content = [NSMutableString string];
   // order important for init method
    [content appendFormat:@"%@\n", self.licenceString];
    [content appendFormat:@"%@\n", self.eMail];
    [content appendFormat:@"%@\n", self.hash];
    //save content to the documents directory
    [content writeToFile:self.filePath atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

- (NSString*) createHash  {
  return [[[NSString alloc] initWithFormat:@"%@%@%@", self.licenceString, self.eMail, [EVEUtilities getMacAddress]] md5];
}

@end
