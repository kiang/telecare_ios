//
//  MenuController.m
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import "MenuController.h"
#import "WebViewController.h"
#import "BackgroundUploadService.h"
#import "ManualUploadController.h"
#import "bleService.h"
#import "XenonPeripheralService.h"

@interface MenuController()<bleServiceDelegate,XenonPeripheralServiceDelegate>


@property NSInteger         controllerViewType;
@property PMODBService      *dbService;
@property HMUser            *hmUser;
@property NSInteger         webIndex;

@end

@implementation MenuController

- (void)viewDidLoad
{
    
    NSLog(@"MenuController %@",NSStringFromSelector(_cmd));

    self.controllerViewType = HAS_NAVIGATION_BAR;
    [super viewDidLoad];
    
    [BackgroundUploadService start];
    
    // Navigation title with login user's account
    CGRect frame = CGRectMake(0, 0, 400, 50);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.text = self.hmUser.uid;
    label.textAlignment = UITextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    
    // Set navigation right items
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    
    UIButton * logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(86, 5, 60.0, 33.0);
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"logout_normal.png"]
                          forState:UIControlStateNormal];
    [logoutButton addTarget:self
                   action:@selector(logout:)
         forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:logoutButton];

    UIButton * settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setTitle:@"修改密碼" forState:UIControlStateNormal];
    settingButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    settingButton.frame = CGRectMake(0, 5, 80.0, 33.0);
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting_background_normal.png"]
                             forState:UIControlStateNormal];
    [settingButton addTarget:self
                     action:@selector(setting:)
           forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:settingButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];

    /*************************************************
       Created by WT Lin @ KYLab on 14/9/14.
    *************************************************/
    //xenonble BP service
    [[bleService sharedInstance] setBleServiceDelegate:self];
    if ([[bleService sharedInstance] getBluetoothState] == CBCentralManagerStatePoweredOff)
    {
        [OMGToast showWithText:@"藍牙已關閉，請開啟藍牙以自動接收血壓資料。" duration:5];
    }
}

- (IBAction)showWeb:(id)sender
{
    self.webIndex = [sender tag];
    [self performSegueWithIdentifier:@"webView" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"webView"])
    {
        WebViewController *c = [segue destinationViewController];
        c.webIndex = self.webIndex;
    } else if ([[segue identifier] isEqualToString:@"toBG"])
    {
        ManualUploadController *c = [segue destinationViewController];
        c.flag = @"BG";
    }
}


/*************************************************************************
 bleServiceDelegate Methods
 *************************************************************************/
- (void)statusChanged:(int)status
{

}

-(void)bluetoothTurnOff
{

}


@end
