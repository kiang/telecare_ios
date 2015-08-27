//
//  GetAreaListService.m
//  HM
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import "GetAreaListService.h"

@interface GetAreaListService()

@property id                target;
@property SEL               action;
@property SEL               errorAction;
@property NSMutableString   *messageBuffer;
@property NSString          *elementName;

@end

@implementation GetAreaListService

- (id) init
{
    self = [super init];
    return self;
}

- (id) initWithElementName:(NSString*)elementName Target:(id)target Action:(SEL)action ErrorAction:(SEL)errorAction
{
    self = [self init];
    if (self)
    {
        self.elementName    = elementName;
        self.target         = target;
        self.action         = action;
        self.errorAction    = errorAction;
    }
    
    return self;
}

- (void) start
{
    NSString *xmlData = [super createXMLWithNameSpace:WEB_SERVICE_NAMESPACE RootElement:@"GetAreaList" Data:nil];
    [self requestWebServiceWithURI:@"/MessageHubWS/Member.asmx" Host:WEB_SERVICE_HOST SoapAction:[NSString stringWithFormat:@"%@%@", WEB_SERVICE_NAMESPACE, @"GetAreaList"] XMLData:xmlData ConnectionCallback:nil];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[self.messageBuffer dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    if (!jsonArray)
    {
        self.error = true;
        NSLog(@"Error parsing JSON");
    } else
    {
        self.error = false;
        NSMutableArray *valueArray = [[NSMutableArray alloc] init];
        self.keyArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [jsonArray count]; ++i)
        {
            [valueArray addObject:[[jsonArray objectAtIndex:i] objectForKey:@"Name" ]];
            [self.keyArray addObject:[[jsonArray objectAtIndex:i] objectForKey:@"Code"]];
        }
        self.areaDictionary = [NSDictionary dictionaryWithObjects:valueArray forKeys:self.keyArray];
    }
    
    [super responseToControllerWithTarget:self.target Action:self.action Object:self];
}

@end
