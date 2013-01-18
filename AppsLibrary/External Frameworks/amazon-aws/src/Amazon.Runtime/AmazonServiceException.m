/*
 * Copyright 2010-2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "AmazonServiceException.h"

/** Generic excpetion type for AWS Service Errors. */
@implementation AmazonServiceException


@synthesize requestId, errorCode, serviceName, statusCode;

+(AmazonServiceException *)exceptionWithMessage:(NSString *)theMessage
{
    AmazonServiceException *e = (AmazonServiceException *)[AmazonServiceException exceptionWithName:@"AmazonServiceException" reason:theMessage userInfo:nil];

    e.message = theMessage;
    return e;
}

+(AmazonServiceException *)exceptionWithStatusCode:(NSInteger)theStatusCode
{
    AmazonServiceException *e = (AmazonServiceException *)[AmazonServiceException exceptionWithName:@"AmazonServiceException" reason:nil userInfo:nil];

    e.statusCode = theStatusCode;
    return e;
}

+(AmazonServiceException *)exceptionWithMessage:(NSString *)theMessage
withErrorCode:(NSString *)theErrorCode
withStatusCode:(NSInteger)theStatusCode
withRequestId:(NSString *)theRequestId
{
    AmazonServiceException *e = (AmazonServiceException *)[AmazonServiceException exceptionWithName:@"AmazonServiceException" reason:theMessage userInfo:nil];

    e.errorCode  = theErrorCode;
    e.statusCode = theStatusCode;
    e.requestId  = theRequestId;
    return e;
}

-(void)setPropertiesWithException:(AmazonServiceException *)theException
{
    self.errorCode   = theException.errorCode;
    self.message     = theException.message;
    self.requestId   = theException.requestId;
    self.statusCode  = theException.statusCode;
    self.serviceName = theException.serviceName;
}

-(id)initWithMessage:(NSString *)theMessage
{
    self = [super initWithMessage:theMessage];
    if (self != nil) {
    }

    return self;
}

-(NSString *)description
{
    return [[[NSString alloc] initWithFormat:@"%@ { RequestId:%@, ErrorCode:%@, Message:%@ }", NSStringFromClass([self class]), requestId, errorCode, message] autorelease];
}

-(NSMutableDictionary *)additionalFields
{
    if (nil == additionalFields) {
        additionalFields = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return additionalFields;
}

-(void)dealloc
{
    [requestId release];
    [errorCode release];
    [serviceName release];
    [additionalFields release];

    [super dealloc];
}


@end
