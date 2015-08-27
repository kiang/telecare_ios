//
//  RemoteSearchController.m
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import "RemoteSearchController.h"
#import "Reachability.h"
#import "BGGetVitalSignService.h"
#import "BPGetVitalSignService.h"
#import "ShowTrendGraphController.h"

@interface RemoteSearchController()

@property NSInteger             controllerViewType;
@property HMUser                *hmUser;
@property NSArray               *datas;
@property NSArray               *titleImgArray;
@property NSArray               *titleTextArray;
@property NSJSONSerialization   *dataJson;
@property bool                  tableInit;

@end

@implementation RemoteSearchController

- (void)viewDidLoad
{
    self.controllerViewType = HAS_NAVIGATION_BAR;
    [super viewDidLoad];
    
    self.titleImgArray           = [NSArray arrayWithObjects:@"upload_blood_sugar.png", @"upload_blood_pressure.png", nil];
    self.titleTextArray          = [NSArray arrayWithObjects:@"血糖數據", @"血壓數據", nil];
    
    [self loadData];
}

- (void) loadData
{
    // Clear table
    self.datas = [[NSArray alloc] init];
    self.tableInit = true;
    [self.tableView reloadData];
    self.tableInit = false;
    
    self.titleImg.image              = [UIImage imageNamed:[self.titleImgArray objectAtIndex:self.searchType ]];
    self.titleText.text              = [self.titleTextArray objectAtIndex:self.searchType];
    
    // Check network condition, if online, show the activityIndicatorView
    Reachability* reachability = [Reachability reachabilityWithHostname:WEB_SERVICE_HOST];
    if ([reachability isReachable]) {
        self.activityIndicator.hidden = NO;
    }
    
    if (BG == self.searchType)
    {
        self.bloodPressureButton.hidden = NO;
        self.bloodSugarButton.hidden    = YES;
        BGGetVitalSignService *service = [[BGGetVitalSignService alloc] initWithAccount:self.hmUser.uid Password:self.hmUser.pwd StartDate:self.startDate EndDate:self.endDate ElementName:@"GetVitalSignResult" Target:self Action:@selector(BGBPServiceResult:) ErrorAction:@selector(didReceiveConnectionError:)];
        [service start];
    } else
    {
        self.bloodPressureButton.hidden = YES;
        self.bloodSugarButton.hidden    = NO;
        BPGetVitalSignService *service = [[BPGetVitalSignService alloc] initWithAccount:self.hmUser.uid Password:self.hmUser.pwd StartDate:self.startDate EndDate:self.endDate ElementName:@"GetVitalSignResult" Target:self Action:@selector(BGBPServiceResult:) ErrorAction:@selector(didReceiveConnectionError:)];
        [service start];
    }
}

- (void) BGBPServiceResult:(BGGetVitalSignService*)service
{
    self.activityIndicator.hidden = YES;
    if (service.error)
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:service.message Delegate:self];
    } else
    {
        self.datas    = service.sourceData;
        self.dataJson = service.dataJson;
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.datas.count == 0 && !self.tableInit ? 1 : self.datas.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString  *tableIdentifier = @"basicTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:tableIdentifier];
    }
    
    if (self.datas.count != 0) {
        id recorddata = [self.datas objectAtIndex:row];
        cell.textLabel.text = [recorddata valueForKey:@"MTime"];
        id values = [recorddata valueForKey:@"Values"];
    
    
        if (BG == self.searchType)
        {
            NSString *mark = [recorddata valueForKey:@"Mark"];
            NSString *inputType = [recorddata valueForKey:@"InputType"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@血糖%i %@"
                                     , [mark isEqualToString:@"AC"]?@"飯前":[mark isEqualToString:@"PC"]?@"飯後":@"隨機", [[values objectAtIndex:0] intValue], [inputType isEqualToString:@"Device"]?@"儀器輸入":@"手動輸入"];
        }else
        {
            NSString *inputType = [recorddata valueForKey:@"InputType"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"收縮壓:%i, 舒張壓%i, 脈搏:%i %@"
                                     , [[values objectAtIndex:0] intValue], [[values objectAtIndex:1] intValue], [[values objectAtIndex:2] intValue], [inputType isEqualToString:@"Device"]?@"儀器輸入":@"手動輸入"];
        }
    } else {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"查無資料";
    }
    
    cell.textLabel.numberOfLines = 2;
    cell.detailTextLabel.numberOfLines = 2;
    
    return cell;
}

- (IBAction)dataChange:(id)sender
{
    self.searchType = [sender tag];
    [self loadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showGraph"])
    {
        ShowTrendGraphController *c = [segue destinationViewController];
        c.searchType = self.searchType;
        c.startDate  = self.startDate;
        c.endDate    = self.endDate;
        c.dataJson   = self.dataJson;
        NSLog(@"here");
    }
}

- (void)viewDidUnload
{
    [self setTitleImg:nil];
    [self setTitleText:nil];
    [self setActivityIndicator:nil];
    [self setTableView:nil];
    [self setBloodSugarButton:nil];
    [self setBloodPressureButton:nil];
    [super viewDidUnload];
}
@end
