//
//  ManualUploadController.h
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import <Foundation/Foundation.h>
#import "BottomMenuController.h"

@interface ManualUploadController : BottomMenuController

- (IBAction)logout:(id)sender;
@property (strong, nonatomic) NSString *flag;
@property (strong, nonatomic) IBOutlet UIView *bottomMenu;
- (IBAction) popToTopView:(id)sender;
- (IBAction) closeKeyboard:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *selectDateTime;
@property (strong, nonatomic) IBOutlet UITextField *bloodSugar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *bloodSugarTimeType;
- (IBAction)uploadBloodSugar:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITextField *bph;
@property (strong, nonatomic) IBOutlet UITextField *bpl;
@property (strong, nonatomic) IBOutlet UITextField *pluse;
- (IBAction)uploadBloodPressure:(id)sender;
- (IBAction)setting:(id)sender;

@end