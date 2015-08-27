//
//  ShowTrendGraphController.m
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import "ShowTrendGraphController.h"
#import "BGGetVitalSignService.h"
#import "BPGetVitalSignService.h"
#import "PMOConstants.h"

@interface ShowTrendGraphController()

@property NSInteger             controllerViewType;
@property NSArray               *measureInformationArray;
@property NSArray               *titleImgArray;
@property NSArray               *titleTextArray;

@end

@implementation ShowTrendGraphController

- (void)viewDidLoad
{
    self.controllerViewType = HAS_NAVIGATION_BAR;
    [super viewDidLoad];
    
    self.titleImgArray           = [NSArray arrayWithObjects:@"upload_blood_sugar.png", @"upload_blood_pressure.png", nil];
    self.titleTextArray          = [NSArray arrayWithObjects:@"血糖數據", @"血壓數據", nil];
    self.measureInformationArray = [NSArray arrayWithObjects:@"飯前血糖標準範圍:70~99\n飯後血糖標準範圍:<140", @"收縮壓標準範圍:90~140\n舒張壓標準範圍:60~90\n脈搏標準範圍:60~100", nil];
        
    [self loadData];
}

- (void) loadData
{
    // Clear image
    self.trendGraph.image = nil;
    
    self.titleImg.image              = [UIImage imageNamed:[self.titleImgArray objectAtIndex:self.searchType]];
    self.titleText.text              = [self.titleTextArray objectAtIndex:self.searchType];
    self.showMeasureInformation.text = [self.measureInformationArray objectAtIndex:self.searchType];
    
    self.activityIndicator.hidden    = NO;
    if (BG == self.searchType)
    {
        self.bloodSugarButton.hidden = YES;
        self.bloodPressureButton.hidden = NO;
        BGGetVitalSignService *service = [[BGGetVitalSignService alloc] initWithDataJson:self.dataJson StartDate:self.startDate EndDate:self.endDate Target:self Action:@selector(generationBGGraphURLResult:)];
        [service generateTrendGrapURL];
    } else
    {
        self.bloodSugarButton.hidden = NO;
        self.bloodPressureButton.hidden = YES;
        BPGetVitalSignService *service = [[BPGetVitalSignService alloc] initWithDataJson:self.dataJson StartDate:self.startDate EndDate:self.endDate Target:self Action:@selector(generationBGGraphURLResult:)];
        [service generateTrendGrapURL];
    }
}

- (void) generationBGGraphURLResult:(BGGetVitalSignService*) service
{
    NSURLResponse* response;
    NSError* error;
    NSData *imageData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:service.trendGraphURL]] returningResponse:&response  error:&error];
    if (error) {
        self.activityIndicator.hidden    = YES;
        NSString *errorMessage = [PMOConstants getConnectionErrorMessageWithError:error];
        [OMGToast showWithText:errorMessage duration:2];
        NSLog(@"error:%@", [error description]);
    } else if (response) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode==200) {
            self.activityIndicator.hidden    = YES;
            self.trendGraph.image = [UIImage imageWithData:imageData];
        } else if( httpResponse.statusCode== 414 ){
            self.activityIndicator.hidden    = YES;
            NSLog(@"status code:%i", httpResponse.statusCode);
           
                [OMGToast showWithText:@"資料過多，請縮小查詢時間範圍。" duration:2];
           
        }
        else
        {
            self.activityIndicator.hidden    = YES;
            NSLog(@"status code:%i", httpResponse.statusCode);
            if (httpResponse.statusCode>=400 && httpResponse.statusCode<500) {
                [OMGToast showWithText:@"產生圖表發生錯誤。" duration:2];
            }

        }
    }
}


- (IBAction)dataChange:(id)sender
{
    self.searchType = [sender tag];
    [self loadData];
}

- (void)viewDidUnload
{
    [self setBloodSugarButton:nil];
    [self setBloodPressureButton:nil];
    [self setTrendGraph:nil];
    [super viewDidUnload];
}
@end
