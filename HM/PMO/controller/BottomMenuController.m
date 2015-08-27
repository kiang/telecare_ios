//
//  BottomMenuController.m
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import "BottomMenuController.h"

@implementation BottomMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load bottom menu
    [self performSegueWithIdentifier:@"embedBottomMenu" sender:self];
}

@end
