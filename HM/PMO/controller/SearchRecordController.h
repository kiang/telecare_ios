//
//  SearchRecordController.h
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import <Foundation/Foundation.h>
#import "BottomMenuController.h"

@interface SearchRecordController : BottomMenuController

- (IBAction)logout:(id)sender;
@property (strong, nonatomic) NSString *flag;
@property (strong, nonatomic) IBOutlet UIView *bottomMenu;
- (IBAction) popToTopView:(id)sender;
- (IBAction) closeKeyboard:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *startDate;
@property (strong, nonatomic) IBOutlet UITextField *endDate;
- (IBAction)localSearch:(id)sender;
- (IBAction)remoteSearch:(id)sender;
- (IBAction)setting:(id)sender;

@end
