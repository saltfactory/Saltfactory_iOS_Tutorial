//
//  SFGroupsTableViewController.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFGroupsTableViewController.h"
#import "SFGroupEditorViewController.h"

@interface SFGroupsTableViewController ()
{
    NSMutableArray *items;
}
- (IBAction)onAddButton:(id)sender;
- (IBAction)onEditButton:(id)sender;
- (IBAction)onCancelButton:(id)sender;
- (void)receiveGroupEditorViewControllerNotification:(NSNotification *)notification;
@end

@implementation SFGroupsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        groupService = [[SFGroupService alloc] init];
        groupService.delegate = self;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"주소록 그룹";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditButton:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGroupEditorViewControllerNotification:) name:@"SFGroupEditorViewControllerNotification" object:nil];
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [groupService findAllGroups];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SFGroupEditorViewControllerNotification" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - NSNotification handlers
- (void)receiveGroupEditorViewControllerNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *groupName = [userInfo valueForKey:@"name"];
    
    if ([[userInfo valueForKey:@"editMode"] isEqualToString:@"add"]) {
        [groupService addGroupWithName:groupName];
    } else {
        NSInteger groupId = [[userInfo valueForKey:@"groupId"] integerValue];
        [groupService updateGroupWithName:groupName groupId:groupId];
    }
}

#pragma mark - IBAction henadler
- (IBAction)onAddButton:(id)sender
{
    SFGroupEditorViewController *groupEditorViewController = [[SFGroupEditorViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:groupEditorViewController];
    [self presentModalViewController:navigationController animated:YES];
}

- (IBAction)onEditButton:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelButton:)];
    [self.tableView setEditing:YES animated:YES];
}

- (IBAction)onCancelButton:(id)sender
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditButton:)];
    
    [self.tableView setEditing:NO animated:YES];
}

#pragma mark - SFGroupService delegate methods
- (void)groupServiceDidFailWithError:(NSError *)error
{
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void)groupServiceDidFindGroups:(NSArray *)groups
{
    items = [NSMutableArray arrayWithArray:groups];
    [self.tableView reloadData];
}

- (void)groupServiceDidAddGroup
{
    [groupService findAllGroups];
}

- (void)groupServiceDidDeleteGroup
{
    
}

- (void)groupServiceDidUpdateGroup
{
    [groupService findAllGroups];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[items objectAtIndex:indexPath.row] valueForKey:@"name"];
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSError *error;
        NSDictionary *groupInfo = [items objectAtIndex:indexPath.row];
        NSInteger groupId = [[groupInfo valueForKey:@"groupId"] integerValue];
        BOOL success = [groupService deleteGroupWithGroupId:groupId withError:&error];

        if (success) {
            [items removeObject:groupInfo];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            NSLog(@"error : %@", [error localizedDescription]);
        }
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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
    
    if (tableView.editing) {
        NSDictionary *groupInfo = [items objectAtIndex:indexPath.row];
        
        SFGroupEditorViewController *groupEditorViewController = [[SFGroupEditorViewController alloc] initWithGroupInfo:groupInfo];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:groupEditorViewController];
        [self presentModalViewController:navigationController animated:YES];

    }
}

@end
