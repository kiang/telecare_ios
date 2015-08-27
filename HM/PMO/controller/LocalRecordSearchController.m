//
//  LocalRecordSearchController.m
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import "LocalRecordSearchController.h"

@interface LocalRecordSearchController()

@property NSInteger         controllerViewType;
@property NSArray           *datas;
@property PMODBService      *dbService;
@property HMUser            *hmUser;

@property NSArray           *titleImgArray;
@property NSArray           *titleTextArray;

@end

@implementation LocalRecordSearchController

- (void)viewDidLoad
{
    self.controllerViewType = HAS_NAVIGATION_BAR;
    [super viewDidLoad];
    
    self.titleImgArray = [NSArray arrayWithObjects:@"upload_blood_sugar.png", @"upload_blood_pressure.png", nil];
    self.titleTextArray = [NSArray arrayWithObjects:@"血糖數據", @"血壓數據", nil];
    [self loadData];
}

- (void) loadData
{
    if (BP == self.searchType)
    {
        // Load blood pressure datas
        self.datas = [self.dbService getHMBPWithSendFlagNotN:self.hmUser];
        self.bloodPressureButton.hidden = YES;
        self.bloodSugarButton.hidden    = NO;
    } else
    {
        // Load blood sugar datas
        self.datas = [self.dbService getHMBGWithSendFlagNotN:self.hmUser];
        self.bloodPressureButton.hidden = NO;
        self.bloodSugarButton.hidden    = YES;
    }
    self.titleImg.image = [UIImage imageNamed:[self.titleImgArray objectAtIndex:self.searchType ]];
    self.titleText.text = [self.titleTextArray objectAtIndex:self.searchType];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.datas.count == 0 ? 1 : self.datas.count);
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
        NSString *sendFlag;
        if (BG == self.searchType)
        {
            HMBG* data = [self.datas objectAtIndex:row];
            cell.textLabel.text = [PMOConstants getFormatDateTimeWithDate:[NSDate dateWithTimeIntervalSinceReferenceDate:[data.fillTime longValue]]];
        
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %i %@"
         , [data.type isEqualToString:@"AC"]?@"飯前":[data.type isEqualToString:@"PC"]?@"飯後":[data.type isEqualToString:@"NM"]?
         @"隨機":@"未知", [data.val intValue], [data.sendFlag isEqualToString:@"Y"]?@"已傳":[data.sendFlag isEqualToString:@"F"]?@"失敗":@"未傳"];
            sendFlag = data.sendFlag;
        
        } else
        {
            HMBP* data = [self.datas objectAtIndex:row];
            cell.textLabel.text = [PMOConstants getFormatDateTimeWithDate:[NSDate dateWithTimeIntervalSinceReferenceDate:[data.fillTime longValue]]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"收縮壓:%i,舒張壓:%i,脈搏:%i %@"
                                     , [data.bph intValue], [data.bpl intValue], [data.pluse intValue], [data.sendFlag isEqualToString:@"Y"]?@"已傳":[data.sendFlag isEqualToString:@"F"]?@"失敗":@"未傳"];
            sendFlag = data.sendFlag;
        }
        
        if (![sendFlag isEqualToString:@"Y"])
        {
            cell.contentView.backgroundColor = [UIColor redColor];
        } else
        {
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
    } else {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"查無資料";
    }

    cell.textLabel.numberOfLines = 2;
    cell.detailTextLabel.numberOfLines = 2;
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    
    return cell;
}

- (IBAction)dataChange:(id)sender
{
    self.searchType = [sender tag];
    [self loadData];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setTitleImg:nil];
    [self setTitleText:nil];
    [self setBloodPressureButton:nil];
    [self setBloodSugarButton:nil];
    [super viewDidUnload];
}
@end
