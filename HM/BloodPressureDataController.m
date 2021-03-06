//
//  BloodPressureDataController.m
//  HM
//
//  Created by HUANG Andrerw on 12/11/9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BloodPressureDataController.h"

@interface BloodPressureDataController ()

@end

@implementation BloodPressureDataController
@synthesize forLogout;
@synthesize tableView             = _tableView;
@synthesize datas                 = _datas;
@synthesize dateformtter          = _dateformtter;
@synthesize bloodSugarButton;
@synthesize hmDbService = _hmDbService;
@synthesize hmUser = _hmUser;
@synthesize bloodPressureButton;
@synthesize dataButton;
@synthesize bloodSugarDataButton;

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
    self.hmDbService = [[HMDBService alloc] init];
    self.hmUser = [self.hmDbService getLastHMUser];
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
    
    UIImage *bloodSugarBackground = [UIImage imageNamed:@"bloodSugarDataB.png"];
    [bloodSugarDataButton setBackgroundImage:bloodSugarBackground forState:UIControlStateHighlighted];
    
    UIImage * bloodSugarButtonPressed = [UIImage imageNamed:@"bloodSugarB.png"];
    [bloodSugarButton setBackgroundImage:bloodSugarButtonPressed forState:UIControlStateHighlighted];
    
    UIImage * bloodPressureButtonPressed = [UIImage imageNamed:@"bloodPressureB.png"];
    [bloodPressureButton setBackgroundImage:bloodPressureButtonPressed forState:UIControlStateHighlighted];
    
    UIImage * dataButtonPressed = [UIImage imageNamed:@"dataB.png"];
    [dataButton setBackgroundImage:dataButtonPressed forState:UIControlStateHighlighted];
    self.forLogout.hidden = true;
    self.datas = [[[HMDBService alloc]init]getHMBPWithSendFlagNotN:self.hmUser];
    self.dateformtter = [[NSDateFormatter alloc]init];
    [self.dateformtter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	// Do any additional setup after loading the view.
}
-(IBAction)OnClick_btnBack:(id)sender  {    //返回上一頁
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)logout:(id)sender {
    [self.hmDbService deleteAllUserDatas];
    [self performSegueWithIdentifier:@"bloodPressureDataLogout" sender:self];
}

- (void)viewDidUnload
{
    [self setForLogout:nil];
    [self setTableView:nil];
    [self setBloodSugarButton:nil];
    [self setBloodPressureButton:nil];
    [self setDataButton:nil];
    [self setBloodSugarDataButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString * tableIdentifier = @"BPTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:tableIdentifier];
    }
    HMBP* data = [self.datas objectAtIndex:row];
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [self.dateformtter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:[data.fillTime longValue]]];
    
    NSMutableString* s = [[NSMutableString alloc]init];
    [s appendFormat:@"收縮%i 舒張%i 脈搏%i %@"
     , [data.bpl intValue], [data.bph intValue], [data.pluse intValue], [data.sendFlag isEqualToString:@"Y"]?@"已傳":[data.sendFlag isEqualToString:@"F"]?@"失敗":@"未傳"];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = s.description;
    
    if (![data.sendFlag isEqualToString:@"Y"]) {
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        cell.contentView.backgroundColor = [UIColor redColor];
    } else {
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"id: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"popupBloodSugar"]) {
        [segue.destinationViewController setValue:@"1" forKey:@"popUpWindow"];
    } else if ([segue.identifier isEqualToString:@"goBloodPressure"]) {
        [segue.destinationViewController setValue:@"2" forKey:@"popUpWindow"];
    } else if ([segue.identifier isEqualToString:@"goData"]) {
        NSLog(@"333");
        [segue.destinationViewController setValue:@"3" forKey:@"popUpWindow"];
    }
}

@end
