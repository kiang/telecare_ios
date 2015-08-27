//
//  GetAreaListService.h
//  HM
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <Foundation/Foundation.h>
#import "PMOWebService.h"

@interface GetAreaListService : PMOWebService

@property (nonatomic)         BOOL           error;
@property (strong, nonatomic) NSDictionary   *areaDictionary;
@property (strong, nonatomic) NSMutableArray *keyArray;

- (id) initWithElementName:(NSString*)elementName
                    Target:(id)target
                    Action:(SEL)action
               ErrorAction:(SEL)errorAction;

- (void) start;

@end
