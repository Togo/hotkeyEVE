//
//  Licence.h
//  EVE
//
//  Created by Tobias Sommer on 9/27/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Licence : NSObject

@property (strong, nonatomic) NSString *filePath;

@property (readwrite, atomic,strong) NSString* licenceString;
@property (readwrite, atomic,strong) NSString* eMail;
@property (readwrite, atomic,strong) NSString* hash;
@property (readwrite) BOOL isValid;

- (NSString*) registerAVersion :(NSString*) aLicenceString :(NSString*) theEMailAddress;

@end
