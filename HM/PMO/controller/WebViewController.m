//
//  WebViewController.m
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import "WebViewController.h"

@interface WebViewController()

@property NSInteger     controllerViewType;
@property NSArray       *websiteArray;
@property NSArray       *webTitleArray;
@property HMUser        *hmUser;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    self.controllerViewType = NO_NAVIGATION_BAR;
    [super viewDidLoad];
    
    self.websiteArray = [NSArray arrayWithObjects:@"NewsInfo.aspx", @"HealthInfo.aspx", @"Branch.aspx", [NSString stringWithFormat:@"Comment.aspx?UserId=%@", self.hmUser.uid], nil];
    self.webTitleArray = [NSArray arrayWithObjects:@"最新消息", @"健康新知", @"服務據點", @"意見回饋", nil];
    
    self.title = [self.webTitleArray objectAtIndex:self.webIndex];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_DOMAIN, [self.websiteArray objectAtIndex:self.webIndex]]]];
    [self.webView loadRequest:request];
    
}

- (void )webViewDidStartLoad:(UIWebView*)webView
{
    self.activityIndicator.hidden = NO;
}

- (void )webViewDidFinishLoad:(UIWebView*)webView
{
    self.activityIndicator.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString *errorMessage = [PMOConstants getConnectionErrorMessageWithError:error];
    [OMGToast showWithText:errorMessage duration:2];
    self.activityIndicator.hidden = YES;
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}
@end
