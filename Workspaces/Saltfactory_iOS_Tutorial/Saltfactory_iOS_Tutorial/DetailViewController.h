//
//  DetailViewController.h
//  Saltfactory_iOS_Tutorial
//
//  Created by SungKwang Song on 11/18/11.
//  Copyright (c) 2011 saltfactory@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
