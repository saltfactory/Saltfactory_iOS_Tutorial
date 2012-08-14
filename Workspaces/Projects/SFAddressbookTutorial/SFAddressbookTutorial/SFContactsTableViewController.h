//
//  SFContactsTableViewController.h
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/14/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFContactService.h"

@interface SFContactsTableViewController : UITableViewController<SFContactServiceDelegate>
{
    NSDictionary *groupInfo;
    SFContactService *contactService;
}
- (id)initWithGroupInfo:(NSDictionary *)aGroupInfo;
@end
