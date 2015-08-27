//
//  PMOWebService.h
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "PMOConstants.h"
#import "OMGToast.h"

@interface PMOWebService : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableData   *responseData;
@property (nonatomic)         BOOL            error;
@property (strong, nonatomic) NSString        *message;

- (NSString*) createXMLWithNameSpace:(NSString*)nameSpace
                         RootElement:(NSString*)rootElement
                                Data:(NSDictionary*)data;

- (void) requestWebServiceWithURI:(NSString*)uri
                             Host:(NSString*)host
                       SoapAction:(NSString*)soapAction
                          XMLData:(NSString*)xmlData
               ConnectionCallback:(SEL)connectionCallback;

- (NSString*) createJsonStringWithDictionary:(NSDictionary*) dictionary;

- (void) responseToControllerWithTarget:(id)target
                                 Action:(SEL)action
                                 Object:(id)object;

- (NSArray*) classifyDatas:(NSArray*)datas
                      Type:(NSString*)type
                      Mark:(NSString*)mark;

@end
