//
//  UserInfoController.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserInfoController.h"

@implementation UserInfoController

@synthesize userIdLabel       = _userIdLabel;
@synthesize userTypeLabel     = _userTypeLabel;
@synthesize userUnitNameLabel = _userUnitNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    HMDBService* service = [[HMDBService alloc] init];
    HMUser* hmUser = [service getLastHMUser];
    self.userIdLabel.text       = hmUser.uid;
    self.userTypeLabel.text     = hmUser.userType;
    self.userUnitNameLabel.text = hmUser.userUnitName;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
