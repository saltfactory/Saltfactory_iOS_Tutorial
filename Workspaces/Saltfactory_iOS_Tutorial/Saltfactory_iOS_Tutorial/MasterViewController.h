//
//  MasterViewController.h
//  Saltfactory_iOS_Tutorial
//
//  Created by SungKwang Song on 11/9/11.
//  Copyright (c) 2011 saltfactory@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
