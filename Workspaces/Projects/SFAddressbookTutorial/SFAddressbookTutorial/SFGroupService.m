//
//  SFGroupService.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFGroupService.h"
#import <AddressBook/AddressBook.h>

@implementation SFGroupService
@synthesize delegate;

- (void)findAllGroups
{
    
    NSMutableArray *groups = [NSMutableArray array];
    
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    CFArrayRef groupsRef = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    
    CFIndex numberOfGroup = ABAddressBookGetGroupCount(addressBookRef);
    
    for(int i = 0 ; i < numberOfGroup ; i++) {
        NSMutableDictionary *groupInfo = [NSMutableDictionary dictionary];
        
        ABRecordRef groupRef = CFArrayGetValueAtIndex(groupsRef, i);
        
        CFStringRef groupNameRef = ABRecordCopyValue(groupRef, kABGroupNameProperty);
        
        NSInteger groupId = ABRecordGetRecordID(groupRef);
        [groupInfo setValue:[NSNumber numberWithInteger:groupId] forKey:@"groupId"];
        
        if (groupNameRef != NULL) {
            [groupInfo setValue:(__bridge NSString *)groupNameRef forKey:@"name"];
            CFRelease(groupNameRef);
        }
        
        [groups addObject:groupInfo];
    }
    
    CFRelease(groupsRef);
    CFRelease(addressBookRef);
    
    [self.delegate groupServiceDidFindGroups:groups];
}

-(void)addGroupWithName:(NSString *)name
{
    CFErrorRef errorRef = NULL;
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    
    ABRecordRef groupRef = ABGroupCreate();
    
    CFStringRef nameRef = (__bridge CFStringRef)name;
    ABRecordSetValue(groupRef, kABGroupNameProperty, nameRef, &errorRef);
    
    ABAddressBookAddRecord(addressBookRef, groupRef, &errorRef);
    ABAddressBookSave(addressBookRef, &errorRef);
    
    CFRelease(groupRef);
    CFRelease(addressBookRef);
    
    if (errorRef != NULL) {
        NSError *error = (__bridge NSError *)errorRef;
        [self.delegate groupServiceDidFailWithError:error];
        CFRelease(errorRef);
    }
    
    [self.delegate groupServiceDidAddGroup];
}

- (BOOL)deleteGroupWithGroupId:(NSInteger)groupId withError:(NSError *__autoreleasing *)error
{
    BOOL success = NO;
    
    CFErrorRef errorRef = NULL;
    
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    
    ABRecordRef savedGroupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);
    
    if (savedGroupRef != NULL) {
        ABAddressBookRemoveRecord(addressBookRef, savedGroupRef, &errorRef);
        ABAddressBookSave(addressBookRef, &errorRef);
        
        savedGroupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);
    }
    
    
    if (errorRef != NULL) {
        *error = (__bridge NSError *)errorRef;
        success = NO;
        CFRelease(errorRef);
    } else {
        success = YES;
    }
    
    CFRelease(addressBookRef);
    return success;
}

- (void)deleteGroupWithGroupId:(NSInteger)groupId
{
    
    NSError *error;

    if (error) {
        [self deleteGroupWithGroupId:groupId withError:&error];
    } else {
        [self.delegate groupServiceDidDeleteGroup];
    }
    
}

-(void)updateGroupWithName:(NSString *)name groupId:(NSInteger)groupId
{
    CFErrorRef errorRef = NULL;
    
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    
    ABRecordRef groupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);
    
    if (groupRef != NULL) {
        CFStringRef nameRef = (__bridge CFStringRef)name;
        ABRecordSetValue(groupRef, kABGroupNameProperty, nameRef, &errorRef);
        ABAddressBookSave(addressBookRef, &errorRef);
    }
    
    
    if (errorRef != NULL) {
        NSError *error = (__bridge NSError *)errorRef;
        [self.delegate groupServiceDidFailWithError:error];
        
        CFRelease(errorRef);
    }
    
    CFRelease(addressBookRef);
    [self.delegate groupServiceDidUpdateGroup];
}


@end
