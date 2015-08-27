//
//  BloodPressureRemoteController.m
//  HM
//
//  Created by HUANG Andrerw on 12/11/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BloodPressureRemoteController.h"

@interface BloodPressureRemoteController ()

@end

@implementation BloodPressureRemoteController
@synthesize bloodSugarButton;
@synthesize bloodPressureButton;
@synthesize dataButton;
@synthesize bloodSugarDataButton;
@synthesize closeTrendGraphButton;
@synthesize bloodPressureRemoteLogoutButton;
@synthesize tableView;
@synthesize imageView;
@synthesize activityIndicatorView;
@synthesize trendGraphButton;
@synthesize scrollView = _scrollView;
@synthesize startDate             = _startDate;
@synthesize endDate               = _endDate;
@synthesize hmUser                = _hmUser;
@synthesize data                  = _data;
@synthesize showImageData = _showImageData;
@synthesize dataJson = _dataJson;

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
    self.imageView.frame = CGRectMake(0, 0, 400, 400);
    self.scrollView.contentSize = CGSizeMake(400, 400); 
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.hidden = true;
    //navigation title
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.text = @"遠距照護ㄧ點通";
    label.shadowColor = [UIColor blackColor];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.396 green:0.404 blue:0.247 alpha:1];
    self.navigationItem.titleView = label;
    
    //navigation left button
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake(0, 0, 58.0, 42.0);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backA.png"] 
                forState:UIControlStateNormal];
    UIImage * backButtonPressed = [UIImage imageNamed:@"backB.png"];
    [backButton setBackgroundImage:backButtonPressed forState:UIControlStateHighlighted];
    [backButton addTarget:self 
                   action:@selector(OnClick_btnBack:) 
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    //navigation right button
    UIButton * logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.bounds = CGRectMake(0, 0, 58.0, 42.0);
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"logoutA.png"] 
                  forState:UIControlStateNormal];
    UIImage * logoutButtonPressed = [UIImage imageNamed:@"logoutB.png"];
    [logoutButton setBackgroundImage:logoutButtonPressed forState:UIControlStateHighlighted];
    [logoutButton addTarget:self 
                     action:@selector(logout:) 
           forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    self.navigationItem.rightBarButtonItem = logoutButtonItem;
    self.bloodPressureRemoteLogoutButton.hidden = true;
    
    UIImage * trendGraphPressed = [UIImage imageNamed:@"trendGraphB.png"];
    [trendGraphButton setBackgroundImage:trendGraphPressed forState:UIControlStateHighlighted];
    
    UIImage * bloodSugarButtonPressed = [UIImage imageNamed:@"bloodSugarB.png"];
    [bloodSugarButton setBackgroundImage:bloodSugarButtonPressed forState:UIControlStateHighlighted];
    
    UIImage * bloodPressureButtonPressed = [UIImage imageNamed:@"bloodPressureB.png"];
    [bloodPressureButton setBackgroundImage:bloodPressureButtonPressed forState:UIControlStateHighlighted];
    
    UIImage * dataButtonPressed = [UIImage imageNamed:@"dataB.png"];
    [dataButton setBackgroundImage:dataButtonPressed forState:UIControlStateHighlighted];
    
    UIImage *bloodSugarBackground = [UIImage imageNamed:@"goBloodSugarB.png"];
    [bloodSugarDataButton setBackgroundImage:bloodSugarBackground forState:UIControlStateHighlighted];
    
    self.closeTrendGraphButton.hidden = true;
    Reachability* reachability = [Reachability reachabilityWithHostname:WEB_SERVICE_HOST];
    if (![reachability isReachable]) {
        self.activityIndicatorView.hidden = true;
    }
    BloodPressureInfoService* service = [[BloodPressureInfoService alloc] initWithUserId:self.hmUser.uid UserPassword:self.hmUser.pwd StartDate:self.startDate EndDate:self.endDate Target:self Action:@selector(queryResult:)];
    [service start];
    
	// Do any additional setup after loading the view.
}
-(void) queryResult:(BloodPressureInfoService*)service
{
    self.activityIndicatorView.hidden = true;
    if (service.error) {
        [[[UIAlertView alloc]initWithTitle:@"錯誤" message:service.message
                                  delegate:self
                         cancelButtonTitle:@"確定"
                         otherButtonTitles:nil]show];
    } else {
        NSLog(@"image view size:%f, %f", self.imageView.bounds.size.width, self.imageView.bounds.size.height);
        self.imageView.image = [UIImage imageWithData:service.imageData];
        self.showImageData = service.imageData;
        
        self.imageView.hidden = true;
        self.data = service.sourceData;
        self.dataJson = service.dataJson;
        [self.tableView reloadData];
        [self.activityIndicatorView stopAnimating];
        
    }
}
-(IBAction)OnClick_btnBack:(id)sender  {    //返回上一頁
    NSLog(@"go back");
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)logout:(id)sender {
     [[[HMDBService alloc] init] deleteAllUserDatas];
    [self performSegueWithIdentifier:@"bloodPressureRemoteLogout" sender:self];
}

- (void)viewDidUnload
{
    [self setBloodPressureRemoteLogoutButton:nil];
    [self setTableView:nil];
    [self setImageView:nil];
    [self setActivityIndicatorView:nil];
    [self setTrendGraphButton:nil];
    [self setBloodSugarButton:nil];
    [self setBloodPressureButton:nil];
    [self setDataButton:nil];
    [self setBloodSugarDataButton:nil];
    [self setCloseTrendGraphButton:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.data.count:%i",self.data.count);
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSLog(@"%i", row);
    NSString * tableIdentifier = @"BPRemoteInfoTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:tableIdentifier];
    }
    id recorddata = [self.data objectAtIndex:row];
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [recorddata valueForKey:@"MTime"];
    
    id values = [recorddata valueForKey:@"Values"];
    id inputType = [recorddata valueForKey:@"InputType"];
    NSMutableString* s = [[NSMutableString alloc] init];
    [s appendFormat:@"收縮壓:%i, 舒張壓%i, 脈搏:%i %@"
     , [[values objectAtIndex:0] intValue], [[values objectAtIndex:1] intValue], [[values objectAtIndex:2] intValue], [inputType isEqualToString:@"Device"]?@"儀器輸入":@"手動輸入"];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = s.description;
    
    return cell;
}


- (IBAction)showTrendGraph:(id)sender {
    self.imageView.hidden = false;
    self.scrollView.hidden = false;
    self.closeTrendGraphButton.hidden = false;
}

- (IBAction)closeTrendGraph:(id)sender {
    self.scrollView.hidden = true;
    self.imageView.hidden = true;
    self.closeTrendGraphButton.hidden = true;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"id: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"popupBloodSugar"]) {
        [segue.destinationViewController setValue:@"1" forKey:@"popUpWindow"];
    } else if ([segue.identifier isEqualToString:@"goBloodPressure"]) {
        [segue.destinationViewController setValue:@"2" forKey:@"popUpWindow"];
    } else if ([segue.identifier isEqualToString:@"goData"]) {
        [segue.destinationViewController setValue:@"3" forKey:@"popUpWindow"];
    } else if ([[segue identifier] isEqualToString:@"goBloodSugarRemote"]) {
        BloodSugarRemoteController * c = [segue destinationViewController];
        c.startDate = self.startDate;
        c.endDate   = self.endDate;
        c.hmUser    = self.hmUser;
    } else if ([[segue identifier] isEqualToString:@"showBloodPressureTrendGraph"]) {
        BloodPressureShowGraphControllerViewController * c = [segue destinationViewController];
        //c.imageData = self.showImageData;
        c.hmUser = self.hmUser;
        c.startDate = self.startDate;
        c.endDate = self.endDate;
        c.dataJson = self.dataJson;
       // NSLog(@"dataJson: %@", self.dataJson);
    }
}
@end
