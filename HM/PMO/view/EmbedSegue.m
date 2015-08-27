//
//  EmbedSegue.m
//  To include bottom menu at bottom
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import "EmbedSegue.h"
#import "BottomMenuController.h"
#import "BottomViewController.h"

@implementation EmbedSegue

- (void)perform
{
    BottomMenuController *includeMenuController = self.sourceViewController;
    BottomViewController *bottomController = self.destinationViewController;
    bottomController.flag = includeMenuController.flag;
    
    [includeMenuController addChildViewController:bottomController];
    [includeMenuController.bottomMenu addSubview:bottomController.view];
    [bottomController didMoveToParentViewController:includeMenuController];
}

@end
