//
//  SearchRecordController.m
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import "SearchRecordController.h"
#import "LocalRecordSearchController.h"
#import "RemoteSearchController.h"

@interface SearchRecordController()

@property NSInteger         controllerViewType;
@property UIDatePicker      *datePicker;
@property NSInteger         searchType;

@end

@implementation SearchRecordController

- (void)viewDidLoad
{
    self.controllerViewType = HAS_NAVIGATION_BAR;
    self.flag = @"Search";
    [super viewDidLoad];
    
    // Initialize date picker
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.maximumDate = [NSDate date];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.startDate.inputView = self.datePicker;
    self.endDate.inputView = self.datePicker;
    
    // Initialize search date
    NSDate *today       = [NSDate date];
    NSDate *offsetDay   = [PMOConstants getDateFromDate:today OffsetDay:-1];
    self.startDate.text = [PMOConstants getFormatDateWithDate:offsetDay];
    self.endDate.text   = [PMOConstants getFormatDateWithDate:today];
}

- (void) dateChanged:(id)sender
{
    if ([self.startDate isFirstResponder])
    {
        self.startDate.text = [PMOConstants getFormatDateWithDate:self.datePicker.date];
    } else
    {
        self.endDate.text = [PMOConstants getFormatDateWithDate:self.datePicker.date];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.startDate isFirstResponder])
    {
        // Reset date picker maximum date less than end date and remove minimum date
        NSDate *startDate = [PMOConstants getDateWithString:self.startDate.text];
        NSDate *endDate   = [PMOConstants getDateWithString:self.endDate.text];
        self.datePicker.maximumDate = endDate;
        self.datePicker.minimumDate = nil;
        self.datePicker.date = startDate;
    } else if ([self.endDate isFirstResponder])
    {
        // Reset date picker minimum date bigger than start date and remove maximum date
        NSDate *startDate = [PMOConstants getDateWithString:self.startDate.text];
        NSDate *endDate   = [PMOConstants getDateWithString:self.endDate.text];
        self.datePicker.maximumDate = nil;
        self.datePicker.minimumDate = startDate;
        self.datePicker.date = endDate;
    }
    [super textFieldDidBeginEditing:textField];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"localRecord"])
    {
        LocalRecordSearchController *c = [segue destinationViewController];
        c.searchType = self.searchType;
    } else if ([[segue identifier] isEqualToString:@"remoteRecord"])
    {
        RemoteSearchController *c = [segue destinationViewController];
        c.searchType = self.searchType;
        c.startDate  = self.startDate.text;
        c.endDate    = self.endDate.text;
    }
}

- (IBAction)localSearch:(id)sender
{
    self.searchType = [sender tag];
    [self performSegueWithIdentifier:@"localRecord" sender:self];
}

- (IBAction)remoteSearch:(id)sender
{
    self.searchType = [sender tag];
    [self performSegueWithIdentifier:@"remoteRecord" sender:self];
}

- (void)viewDidUnload {
    [self setStartDate:nil];
    [self setEndDate:nil];
    [super viewDidUnload];
}
@end
