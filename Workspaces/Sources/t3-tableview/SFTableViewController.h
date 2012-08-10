//
//  SFTableViewController.h
//  SFTableViewTutorial
//
//  Created by saltfactory on 8/10/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>;
@property (nonatomic, strong) UITableView *tableView;
@end
