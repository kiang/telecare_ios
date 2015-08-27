//
//  Coordinate.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate

@synthesize x  = _x;
@synthesize y  = _y;
@synthesize y2 = _y2;
@synthesize y3 = _y3;

- (NSString*) description
{
    return [NSString stringWithFormat:@"x=%i, y=%i, y2=%i, y3=%i", self.x, self.y, self.y2, self.y3];
}

@end
