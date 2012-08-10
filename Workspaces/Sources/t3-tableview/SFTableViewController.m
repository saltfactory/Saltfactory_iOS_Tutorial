//
//  SFTableViewController.m
//  SFTableViewTutorial
//
//  Created by saltfactory on 8/10/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFTableViewController.h"

@interface SFTableViewController ()
{
    NSMutableDictionary *itemsInfo;
}
@end

@implementation SFTableViewController
@synthesize tableView;
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)init
{
//    self = [super initWithStyle:UITableViewStylePlain];
    self = [super init];    
    if (self){
        itemsInfo = [NSMutableDictionary dictionary];
        
        NSArray *firstItems = [NSArray arrayWithObjects:@"date1", @"date2", @"date3", nil];
        [itemsInfo setValue:firstItems forKey:@"First Items"];
        
        NSArray *secondItems = [NSArray arrayWithObjects:@"items1", @"items2", @"items3", nil];
        [itemsInfo setValue:secondItems forKey:@"Second Items"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"UITableView Test";
    
    self.tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 44.0;
    self.tableView.sectionFooterHeight = 44.0;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[itemsInfo allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [[itemsInfo allKeys] objectAtIndex:section];
    return [[itemsInfo objectForKey:key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSString *key = [[itemsInfo allKeys] objectAtIndex:indexPath.section];
    cell.textLabel.text =[[itemsInfo objectForKey:key] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView delegate method
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[itemsInfo allKeys] objectAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return section == 0 ? @"first items description" : @"second items description";
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

//- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44;
//}
//
//- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 44;
//}
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
