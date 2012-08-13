//
//  SFGroupEditorViewController.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFGroupEditorViewController.h"

@interface SFGroupEditorViewController ()
{
    IBOutlet UITextField *textField;
}
- (IBAction)onDoneButton:(id)sender;
- (IBAction)onCancelButton:(id)sender;
@end

@implementation SFGroupEditorViewController

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
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithGroupInfo:(NSDictionary *)aGroupInfo
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        groupInfo = aGroupInfo;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = groupInfo == nil ? @"새로운 그룹" : @"그룹수정";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelButton:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    textField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction handlers
- (IBAction)onDoneButton:(id)sender
{
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:textField.text forKey:@"groupName"];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:textField.text forKey:@"name"];
    
    if (userInfo != nil) {
        [userInfo setValue:[groupInfo valueForKey:@"groupId"] forKey:@"groupId"];
        [userInfo setValue:@"update" forKey:@"editMode"];
    } else {
        [userInfo setValue:@"add" forKey:@"editMode"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SFGroupEditorViewControllerNotification" object:nil userInfo:userInfo];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onCancelButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        textField.adjustsFontSizeToFitWidth = YES;
        textField.textColor = [UIColor blackColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.textAlignment = UITextAlignmentLeft;
        
        textField.clearButtonMode = UITextFieldViewModeAlways;
        [textField setEnabled: YES];
        [cell addSubview:textField];
        [textField becomeFirstResponder];
        
        textField.placeholder = @"그룹명을 입력하세요";
        
        if (groupInfo != nil) {
            textField.text = [groupInfo valueForKey:@"name"];
        }
    }
    
    cell.textLabel.text = @"그룹명";
    
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
