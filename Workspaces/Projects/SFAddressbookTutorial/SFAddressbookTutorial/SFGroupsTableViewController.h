//
//  SFGroupsTableViewController.h
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFGroupService.h"

@interface SFGroupsTableViewController : UITableViewController<SFGroupServiceDelegate>
{
    SFGroupService *groupService;
}
@end
