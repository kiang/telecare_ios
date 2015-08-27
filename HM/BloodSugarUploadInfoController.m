//
//  BloodSugarUploadInfoController.m
//  HM
//
//  Created by HUANG Andrerw on 12/11/2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BloodSugarUploadInfoController.h"

@implementation BloodSugarUploadInfoController
@synthesize tableView             = _tableView;
@synthesize datas                 = _datas;
@synthesize dateformtter          = _dateformtter;

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
    self.datas = [[[HMDBService alloc]init]getHMBGWithSendFlagNotN];
    self.dateformtter = [[NSDateFormatter alloc]init];
    [self.dateformtter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
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

//@protocol UITableViewDelegate<NSObject, UIScrollViewDelegate>

// Display customization

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

// Variable height support

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

// Section header & footer information. Views are preferred over title should you decide to provide both

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
// custom view for header. will be adjusted to default or specified header height

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
// custom view for footer. will be adjusted to default or specified footer height



//@protocol UITableViewDataSource<NSObject>

//@required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSLog(@"%i", row);
    NSString * tableIdentifier = @"BGTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:tableIdentifier];
    }
    HMBG* data = [self.datas objectAtIndex:row];
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [self.dateformtter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:[data.fillTime longValue]]];
    
    NSMutableString* s = [[NSMutableString alloc]init];
    [s appendFormat:@"%@ %i %@"
     , [data.type isEqualToString:@"AC"]?@"飯前":[data.type isEqualToString:@"PC"]?@"飯後":[data.type isEqualToString:@"NM"]?
                      @"隨機":@"未知", [data.val intValue], [data.sendFlag isEqualToString:@"Y"]?@"已傳":[data.sendFlag isEqualToString:@"F"]?@"失敗":@"未傳"];
    cell.detailTextLabel.text = s.description;

    return cell;
}

//@optional

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

// Index

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

// Data manipulation - reorder / moving support

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

//@end


@end
