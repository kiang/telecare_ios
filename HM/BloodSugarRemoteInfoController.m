//
//  BloodSugarRemoteInfoController.m
//  HM
//
//  Created by HUANG Andrerw on 12/11/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BloodSugarRemoteInfoController.h"

@implementation BloodSugarRemoteInfoController

@synthesize startDate             = _startDate;
@synthesize endDate               = _endDate;
@synthesize hmUser                = _hmUser;
@synthesize data                  = _data;
@synthesize tableView             = _tableView;
@synthesize imageView             = _imageView;
@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) queryResult:(BloodSugarInfoService*)service
{
    if (service.error) {
        [[[UIAlertView alloc]initWithTitle:@"錯誤" message:service.message
                                  delegate:self
                         cancelButtonTitle:@"確定"
                         otherButtonTitles:nil]show];
    } else {
        NSLog(@"image view size:%f, %f", self.imageView.bounds.size.width, self.imageView.bounds.size.height);
        self.imageView.image = [UIImage imageWithData:service.imageData];
        self.imageView.hidden = true;
        self.data = service.sourceData;
        [self.tableView reloadData];
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = true;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"startDate:%@", self.startDate);
    NSLog(@"endDate:%@", self.endDate);
    
    
    BloodSugarInfoService* service = [[BloodSugarInfoService alloc] initWithUserId:self.hmUser.uid UserPassword:self.hmUser.pwd StartDate:self.startDate EndDate:self.endDate Target:self Action:@selector(queryResult:)];
    [service start];
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

- (IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:true];
    self.imageView.hidden = true;
}

- (IBAction) showImageView:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.imageView.hidden = false;
}

- (IBAction)gotoBloodPressureView:(id)sender
{
    [self performSegueWithIdentifier:@"bloodPressureDataView" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([[segue identifier] isEqualToString:@"bloodPressureDataView"]) {
        BloodPressureRemoteInfoController* c = [segue destinationViewController];
        c.startDate = self.startDate;
        c.endDate   = self.endDate;
        c.hmUser    = self.hmUser;
    }
}

//@protocol UITableViewDataSource<NSObject>

//@required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.data.count:%i",self.data.count);
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSLog(@"%i", row);
    NSString * tableIdentifier = @"BGRemoteInfoTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:tableIdentifier];
    }
    id recorddata = [self.data objectAtIndex:row];
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [recorddata valueForKey:@"MTime"];
    
    NSString* mark = [recorddata valueForKey:@"Mark"];
    id values = [recorddata valueForKey:@"Values"];
    id inputType = [recorddata valueForKey:@"InputType"];
    NSMutableString* s = [[NSMutableString alloc] init];
    [s appendFormat:@"%@血糖%i %@"
     , [mark isEqualToString:@"AC"]?@"飯前":[mark isEqualToString:@"PC"]?@"飯後":@"隨機", [[values objectAtIndex:0] intValue], [inputType isEqualToString:@"Device"]?@"儀器輸入":@"手動輸入"];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = s.description;
    
    return cell;
}
//@end

@end
