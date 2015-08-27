//
//  HMWebService.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMWebService.h"

@implementation HMWebService : NSObject

@synthesize responseData = _responseData;

- (id) init
{
    self = [super init];
    if(self) {
        self.responseData = [[NSMutableData alloc] init];
    }
    return self;
}

- (NSString*) createXMLWithNameSpace:(NSString*)nameSpace RootElement:(NSString*)rootElement Data:(NSDictionary*)data
{
    NSMutableString* ms = [[NSMutableString alloc]init];
    [ms appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
    [ms appendString:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
    [ms appendString:@"<soap:Body>"];
    [ms appendFormat:@"<%@ xmlns=\"%@\">", rootElement, nameSpace];
    
    NSEnumerator* e = [data keyEnumerator];
    NSString* key;
    while (key=[e nextObject]) {
        [ms appendFormat:@"<%@>%@</%@>", key, [data valueForKey:key], key];
    }
    
    
    [ms appendFormat:@"</%@>", rootElement];
    [ms appendString:@"</soap:Body>"];
    [ms appendString:@"</soap:Envelope>"];
    return ms;
}


//bool connError    = false;
SEL  connCallback = nil;
- (void) requestWebServiceWithURI:(NSString*)uri Host:(NSString*)host SoapAction:(NSString*)soapAction XMLData:(NSString*)xmlData ConnectionCallback:(SEL)connectionCallback
{
    
    Reachability* reachability = [Reachability reachabilityWithHostname:WEB_SERVICE_HOST];
    if (![reachability isReachable]) {
        [OMGToast showWithText:[NSString stringWithFormat:@"無法連上網路\n%@", @"請確認您的網路是否有開啓"] duration:5];
        return;
    }
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"XML Data:%@", xmlData);
    
    /* Soap Sample
     POST /MessageHubWS/Member.asmx HTTP/1.1
     Host: 139.223.23.100
     Content-Type: text/xml; charset=utf-8
     Content-Length: length
     SOAPAction: "http://tempuri.org/ValidateUser"
     
     <?xml version="1.0" encoding="utf-8"?>
     <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
     <soap:Body>
     <ValidateUser xmlns="http://tempuri.org/">
     <ID>string</ID>
     <Pwd>string</Pwd>
     </ValidateUser>
     </soap:Body>
     </soap:Envelope>
     */
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", host, uri]]];
    [req setHTTPMethod:@"POST"];
    //[req setValue:host forHTTPHeaderField:@"Host"];
    [req setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"@i", xmlData.length] forHTTPHeaderField:@"Content-Length"];
    [req setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    [req setHTTPBody:[NSMutableData dataWithBytes:[xmlData UTF8String] length:[xmlData length]]];
    req.timeoutInterval = 5;
    
    //For HTTPS
    connCallback = connectionCallback;
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        //Connection has been created.
        NSLog(@"%@", @"Connection has been created.");
    } else {
        //Nothing
        NSLog(@"%@", @"Connection create fail.");
    }
}


//@protocol NSURLConnectionDelegate <NSObject>
//@optional
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", [error debugDescription]);
    
    //[OMGToast showWithText:[NSString stringWithFormat:@"伺服器或網路忙碌，\n%@", @"請稍候再嘗試，\n建議您檢查網路連線。"] duration:5];
    //[[[UIAlertView alloc] initWithTitle:@"連線錯誤" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show];
}
//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

// Deprecated authentication delegates.
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
//- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
//@end

//@protocol NSURLConnectionDataDelegate <NSURLConnectionDelegate>
//@optional
//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.responseData.length = 0;
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"didreceive data : %@",data);
    [self.responseData appendData:data];
}

//- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request;

//- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;


//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"self.receiveData length:%i", [self.responseData length]);
    NSLog(@"self.receiveData %@", [[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    [self requestWebServiceFinish:self.responseData];
}
//@end

- (void) requestWebServiceFinish:(NSMutableData*)data
{
    //TODO
}

@end
