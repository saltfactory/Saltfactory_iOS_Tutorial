//
//  SFContactService.h
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFContactServiceDelegate <NSObject>

@required
- (void)contactServiceDidFailWithError:(NSError *)error;
- (void)contactServiceDidFindContacts:(NSArray *)contacts;
@end

@interface SFContactService : NSObject
{
    id<SFContactServiceDelegate>delegate;
}
@property (nonatomic, strong) id<SFContactServiceDelegate>delegate;
- (void)findContactsWithGroupId:(NSInteger)groupId;
@end
