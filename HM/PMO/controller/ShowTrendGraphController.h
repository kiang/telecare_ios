//
//  ShowTrendGraphController.h
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import <Foundation/Foundation.h>
#import "BottomMenuController.h"

@interface ShowTrendGraphController : BottomMenuController

- (IBAction)logout:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bottomMenu;
- (IBAction) popSelfView:(id)sender;
@property NSInteger searchType;
@property (strong, nonatomic) NSString* startDate;
@property (strong, nonatomic) NSString* endDate;
@property (strong, nonatomic) IBOutlet UIImageView *titleImg;
@property (strong, nonatomic) IBOutlet UILabel *titleText;
@property (strong, nonatomic) IBOutlet UILabel *showMeasureInformation;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *bloodPressureButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodSugarButton;
- (IBAction)dataChange:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *trendGraph;
@property (strong, nonatomic) NSJSONSerialization   *dataJson;
- (IBAction)setting:(id)sender;

@end
