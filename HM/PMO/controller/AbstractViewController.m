//
//  AbstractViewController.m
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import "AbstractViewController.h"
#import "SettingController.h"
#import "LoginController.h"

@interface AbstractViewController ()

@property NSInteger     controllerViewType;
@property UITextField   *activeTextField;
@property CGFloat       orginalViewPositionY;
@property PMODBService  *dbService;
@property HMUser        *hmUser;
@property UIView        *kbAccessoryView;

@end

@implementation AbstractViewController

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
    
    [self registerForKeyboardNotifications];
    
    // Get latest user data
    self.dbService = [[PMODBService alloc] init];
    self.hmUser = [self.dbService getLastHMUser];
    if (!self.hmUser) self.hmUser = [[HMUser alloc] init];
    
    // Initial close kb accessory view
    self.kbAccessoryView = [self getKeyboardToolBar];
}

// Keyboard toolbar contain close button
- (UIToolbar*) getKeyboardToolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolbarItems addObject:flexSpace];
    
    // Close keyboard button
    UIBarButtonItem *closeKeyboardButton = [[UIBarButtonItem alloc] initWithTitle:@"確認" style:UIBarButtonItemStyleBordered target:self action:@selector(closeKeyboard:)];
    [toolbarItems addObject:closeKeyboardButton];
    
    toolbar.items = toolbarItems;
    
    return toolbar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)closeSelfModalView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)closeKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)popToTopView:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)setting:(id)sender
{
    SettingController *vc = (SettingController*)[self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction) popSelfView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Check activeTextField is behind kb or not
    CGRect viewRect = self.view.frame;
    if (self.controllerViewType == HAS_NAVIGATION_BAR)
    {
        viewRect.origin.y = 0;
    } else
    {
        viewRect.origin.y = 20;
    }
    self.orginalViewPositionY = viewRect.origin.y;
    CGFloat kbPostionY = viewRect.size.height - kbSize.height;
    if (self.activeTextField.frame.origin.y >= kbPostionY) {
        viewRect.origin.y -= (kbPostionY / 3 + (self.activeTextField.frame.origin.y - kbPostionY));
        self.view.frame = viewRect;
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // Move view to original position y
    CGRect viewRect = self.view.frame;
    viewRect.origin.y = self.orginalViewPositionY;
    self.view.frame = viewRect;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.inputAccessoryView == nil)
    {
        textField.inputAccessoryView = self.kbAccessoryView;
    }
    self.activeTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (IBAction)logout:(id)sender
{
    // Delete all db user datas
    [self.dbService deleteAllUserDatas];
    
    // Go to login page
    LoginController *vc = (LoginController*)[self.storyboard instantiateViewControllerWithIdentifier:@"loginPage"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentModalViewController:vc animated:YES];
}

- (void) didReceiveConnectionError:(PMOWebService*) service
{
    self.activityIndicator.hidden = YES;
}

@end
