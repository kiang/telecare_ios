//
//  PMOWebService.m
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import "PMOWebService.h"

@interface PMOWebService()

@property NSMutableString   *messageBuffer;
@property BOOL              receiveElement;
@property NSString          *elementName;
@property id                target;
@property SEL               errorAction;
@property SEL               action;

@end

@implementation PMOWebService

- (id) init
{
    self = [super init];
    if(self) {
        self.responseData = [[NSMutableData alloc] init];
        self.messageBuffer = [[NSMutableString alloc]init];
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

- (NSString*) createJsonStringWithDictionary:(NSDictionary*) dictionary
{
    NSMutableString *jsonString = [[NSMutableString alloc] initWithString:@"{"];
    NSEnumerator *e = [dictionary keyEnumerator];
    NSString *key;
    while (key=[e nextObject])
    {
        if ([jsonString length] > 1)    [jsonString appendString:@","];
        [jsonString appendFormat:@"\"%@\":\"%@\"", key, [dictionary valueForKey:key]];
    }
    
    [jsonString appendString:@"}"];
    
    return jsonString;
}

- (void) requestWebServiceWithURI:(NSString*)uri Host:(NSString*)host SoapAction:(NSString*)soapAction XMLData:(NSString*)xmlData ConnectionCallback:(SEL)connectionCallback
{
    // Check network connection
    Reachability* reachability = [Reachability reachabilityWithHostname:host];
    if (![reachability isReachable])
    {
        [OMGToast showWithText:[NSString stringWithFormat:@"無法連上網路\n%@", @"請確認您的網路是否有開啓"] duration:5];
        if (self.errorAction != nil)
        {
            [self responseToControllerWithTarget:self.target Action:self.errorAction Object:self];
        }
        return;
    }
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"XML Data: %@", xmlData);

    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", host, uri]]];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"@i", xmlData.length] forHTTPHeaderField:@"Content-Length"];
    [req setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    [req setHTTPBody:[NSMutableData dataWithBytes:[xmlData UTF8String] length:[xmlData length]]];
    req.timeoutInterval = 5;
    
    //For HTTPS
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        // Connection has been created
        NSLog(@"%@", @"Connection has been created.");
    } else {
        // Connection create fail
        NSLog(@"%@", @"Connection create fail.");
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", [error debugDescription]);
    NSString* errorMessage = [PMOConstants getConnectionErrorMessageWithError:error];
    [OMGToast showWithText:errorMessage duration:2];
    if (self.errorAction != nil)
    {
        [self responseToControllerWithTarget:self.target Action:self.errorAction Object:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.responseData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"didreceive data : %@",[data description]);
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"self.receiveData length:%i", [self.responseData length]);
    NSLog(@"self.receiveData %@", [[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    [self requestWebServiceFinish:self.responseData];
}

- (void) requestWebServiceFinish:(NSMutableData*)data
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSXMLParser* parser = [[NSXMLParser alloc]initWithData:data];
    parser.delegate = self;
    [parser parse];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"MessageBuffer: %@", self.messageBuffer);
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:[self.messageBuffer dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSString* value;
    value = [json valueForKey:@"Message"];
    NSLog(@"Message: %@", value);
    if ([RESPONSE_SUCCESS_CODE isEqualToString:value])
    {
        self.error = false;
    } else
    {
        self.error = true;
    }
    self.message = [PMOConstants getErrorMessageWithErrorCode:value];
    NSLog(@"Get Message: %@", self.message);
    
    [self responseToControllerWithTarget:self.target Action:self.action Object:self];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:self.elementName])
    {
        self.receiveElement = true;
        [self.messageBuffer deleteCharactersInRange:NSMakeRange(0, self.messageBuffer.length)];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:self.elementName])
    {
        self.receiveElement = false;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.receiveElement)
    {
        [self.messageBuffer appendString:string];
    }
}


- (void) responseToControllerWithTarget:(id)target Action:(SEL)action Object:(id)object
{
    [target performSelector:action withObject:object];
}

// Classify BG, BP datas
- (NSArray*) classifyDatas:(NSArray*)datas Type:(NSString*)type Mark:(NSString*)mark
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    id data;
    for (int i=0; i<datas.count; i++) {
        data = [datas objectAtIndex:i];
        if (![type isEqualToString:[data valueForKey:@"Type"]])
        {
            continue;
        }
        
        if (mark != nil && ![mark isEqualToString:[data valueForKey:@"Mark"]])
        {
            continue;
        }
        
        [ret addObject:data];
    }
    
    // Comparator for sort
    NSComparator cmpr = ^(NSObject* data1, NSObject* data2) {
        NSDate* d1 = [PMOConstants getFullDateWithString:[data1 valueForKey:@"MTime"]];
        NSDate* d2 = [PMOConstants getFullDateWithString:[data2 valueForKey:@"MTime"]];
        if (d1.timeIntervalSince1970 > d2.timeIntervalSince1970) return NSOrderedAscending;
        if (d2.timeIntervalSince1970 > d1.timeIntervalSince1970) return NSOrderedDescending;
        return NSOrderedSame;
    };
    
    return [ret sortedArrayUsingComparator:cmpr];
}

@end
