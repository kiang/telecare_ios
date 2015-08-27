//
//  BottomViewController.m
//  HM
//
//  Created by Andrerw HUANG on 13/8/27.
//
//

#import "BottomViewController.h"
#import "ManualUploadController.h"

@interface BottomViewController ()

@property NSArray   *bottomArray;

@end

@implementation BottomViewController

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
    
    // Set self position-y to 0
    CGRect cgRect = self.view.frame;
    cgRect.origin.y = 0;
    self.view.frame = cgRect;
    
    // Initial bottom array
    self.bottomArray = [NSArray arrayWithObjects:@"BG", @"BP", @"Search", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonPressed:(id)sender
{
    NSString *pressedButton = [self.bottomArray objectAtIndex:[sender tag]];
    if (![pressedButton isEqualToString:self.flag]) {
        [self performSegueWithIdentifier:pressedButton sender:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BP"])
    {
        ManualUploadController *c = [segue destinationViewController];
        c.flag = @"BP";
    } else if ([[segue identifier] isEqualToString:@"BG"])
    {
        ManualUploadController *c = [segue destinationViewController];
        c.flag = @"BG";
    }
}

@end
