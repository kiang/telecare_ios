//
//  BasicNavigationBar.m
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import "BasicNavigationBar.h"

@implementation BasicNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIImage *navBarBackground = [UIImage imageNamed:@"navigation_background.png"];
    [navBarBackground drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
