//
//  MasterViewController.m
//  Saltfactory_iOS_Tutorial
//
//  Created by SungKwang Song on 11/18/11.
//  Copyright (c) 2011 saltfactory@gmail.com. All rights reserved.
//

#import "MasterViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "DetailViewController.h"

#define kTweetSearchAlertViewTag 1
#define kTweetUpdateAlertViewTag 2

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize tweets = _tweets;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) fetchTimelineWithText:(NSString *)text
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@", [text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    NSLog(@"%@", urlString);
    
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:urlString] parameters:nil requestMethod:TWRequestMethodGET];    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError;
            
            NSDictionary *timelineInfo = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            _tweets = [timelineInfo objectForKey:@"results"];
            
            [self.tableView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];        
        } else {
            NSLog(@"Twitter Error : %@", [error localizedDescription]);
        }
    }];
}

- (void) fetchTimeline
{
    
}

- (void) updateTweetWithText:(NSString *)text
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error){        
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];  
            ACAccount *account = [accounts objectAtIndex:0];
            
            NSString *urlString = @"http://api.twitter.com/1/statuses/update.json";
            
            TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:urlString] parameters:[NSDictionary dictionaryWithObject:text forKey:@"status"] requestMethod:TWRequestMethodPOST];
            [request setAccount:account];
            
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                if (urlResponse.statusCode == 200) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"정상적으로 메세지가 업데이트 되었습니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
                    [alertView show];
                } else {
                    NSLog(@"Twitter Error : %@", [error localizedDescription]);
                }
            }];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case kTweetSearchAlertViewTag:
            if (buttonIndex == 1) {
                [self fetchTimelineWithText:[[alertView textFieldAtIndex:0] text]];
            }
            break;
        case kTweetUpdateAlertViewTag:
            if (buttonIndex == 1) {
                [self updateTweetWithText:[[alertView textFieldAtIndex:0] text]];
            }            
            break;
        default:
            break;
    }
    
}



- (IBAction)onSearchButton:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Search" 
                                            message:nil 
                                            delegate:self 
                                            cancelButtonTitle:@"Cancel" 
                                            otherButtonTitles:@"Search", nil];    
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag = kTweetSearchAlertViewTag;
    [alertView show];
}


- (void)fetchTwitterAccount
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error){        
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];  

            for (ACAccount *account in accounts) {
                NSLog(@"twitter account : %@, %@", account.username, account.description);
            }            
        }
    }];
}

- (IBAction)onComposeButton:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Message" 
                                                        message:nil 
                                                       delegate:self 
                                              cancelButtonTitle:@"Cancel" 
                                              otherButtonTitles:@"Update", nil];    
    alertView.tag = kTweetUpdateAlertViewTag;
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self fetchTimelineWithText:@"#iOS"];
    [self fetchTwitterAccount];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
                                                                                  target:self action:@selector(onSearchButton:)];
    self.navigationItem.leftBarButtonItem = searchButton;
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButton:)];
    
    self.navigationItem.rightBarButtonItem = composeButton;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tweets count] == 0 ? 1 : [_tweets count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // Configure the cell.
    if ([_tweets count] == 0) {
        cell.textLabel.text = @"Loading...";
    } else {
        cell.textLabel.text = [[_tweets objectAtIndex:indexPath.row] objectForKey:@"text"];        
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
