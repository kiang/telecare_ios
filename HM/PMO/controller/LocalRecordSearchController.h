//
//  LocalRecordSearchController.h
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import <Foundation/Foundation.h>
#import "BottomMenuController.h"

@interface LocalRecordSearchController : BottomMenuController <UITableViewDelegate,UITableViewDataSource>

- (IBAction)logout:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bottomMenu;
- (IBAction) popSelfView:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSInteger searchType;
@property (strong, nonatomic) IBOutlet UIImageView *titleImg;
@property (strong, nonatomic) IBOutlet UILabel *titleText;
@property (strong, nonatomic) IBOutlet UIButton *bloodPressureButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodSugarButton;
- (IBAction)dataChange:(id)sender;
- (IBAction)setting:(id)sender;

@end
