//
//  Saltfactory_iOS_TutorialTests.m
//  Saltfactory_iOS_TutorialTests
//
//  Created by SungKwang Song on 11/18/11.
//  Copyright (c) 2011 saltfactory@gmail.com. All rights reserved.
//

#import "Saltfactory_iOS_TutorialTests.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@implementation Saltfactory_iOS_TutorialTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
//    STFail(@"Unit tests are not implemented yet in Saltfactory_iOS_TutorialTests");

    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error){
        NSArray *accounts = [accountStore accountsWithAccountType:accountType];  
            
        for (ACAccount *account in accounts) {
            NSLog(@"twitter account : %@", account.username);
        }
    }];
    
}

@end
