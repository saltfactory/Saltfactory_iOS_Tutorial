//
//  SFGroupService.h
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFGroupServiceDelegate <NSObject>

@required
- (void)groupServiceDidFailWithError:(NSError *)error;
- (void)groupServiceDidFindGroups:(NSArray *)groups;
- (void)groupServiceDidAddGroup;
- (void)groupServiceDidDeleteGroup;
- (void)groupServiceDidUpdateGroup;
@end

@interface SFGroupService : NSObject
{
    id<SFGroupServiceDelegate>delegate;
}
@property (nonatomic, strong) id<SFGroupServiceDelegate>delegate;

- (void)findAllGroups;
- (void)addGroupWithName:(NSString *)name;
- (void)deleteGroupWithGroupId:(NSInteger)groupId;
- (BOOL)deleteGroupWithGroupId:(NSInteger)groupId withError:(NSError **)error;
- (void)updateGroupWithName:(NSString *)name groupId:(NSInteger)groupId;

@end
