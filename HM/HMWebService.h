//
//  HMWebService.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMGToast.h"
#import "Reachability.h"
#import "HMConstants.h"

@interface HMWebService : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData* responseData;

- (NSString*) createXMLWithNameSpace:(NSString*)nameSpace
                         RootElement:(NSString*)rootElement
                                Data:(NSDictionary*)data;

- (void) requestWebServiceWithURI:(NSString*)uri
                             Host:(NSString*)host
                       SoapAction:(NSString*)soapAction
                          XMLData:(NSString*)xmlData
               ConnectionCallback:(SEL)connectionCallback;

- (void) requestWebServiceFinish:(NSMutableData*)data;

@end