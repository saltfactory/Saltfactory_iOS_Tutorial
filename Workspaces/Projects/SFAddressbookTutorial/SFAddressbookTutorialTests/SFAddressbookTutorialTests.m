//
//  SFAddressbookTutorialTests.m
//  SFAddressbookTutorialTests
//
//  Created by saltfactory on 8/10/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFAddressbookTutorialTests.h"
#import <AddressBook/AddressBook.h>

@implementation SFAddressbookTutorialTests

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
    STFail(@"Unit tests are not implemented yet in SFAddressbookTutorialTests");
}

- (void)testSelectAllGroups
{
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    STAssertTrue(addressBookRef != NULL, @"addressBookRef is NULL");
    
    CFArrayRef groupsRef = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    STAssertTrue(groupsRef != NULL, @"groupsRef is NULL");
    
    CFIndex numberOfGroup = ABAddressBookGetGroupCount(addressBookRef);
    STAssertTrue(numberOfGroup != 0, @"groupsRef count is 0");
    
    
    for(int i = 0 ; i < numberOfGroup ; i++) {
        ABRecordRef groupRef = CFArrayGetValueAtIndex(groupsRef, i);
        
        CFStringRef groupNameRef = ABRecordCopyValue(groupRef, kABGroupNameProperty);

        NSInteger groupId = ABRecordGetRecordID(groupRef);
        NSLog(@"groupId : %d", groupId);

        if (groupNameRef != NULL) {
            NSLog(@"groupName : %@", (__bridge NSString *)groupNameRef);
            CFRelease(groupNameRef);
        }
        
    }
    
    CFRelease(groupsRef);
    
    CFRelease(addressBookRef);
}


//
//        group.groupId = ABRecordGetRecordID(groupRef);
//
//        CFArrayRef membersOfGroup = ABGroupCopyArrayOfAllMembers(groupRef);
//        if (membersOfGroup == NULL) {
//            [group setCountOfMember:0];
//        }
//        else {
//            [group setCountOfMember:CFArrayGetCount(membersOfGroup)];
//            CFRelease(membersOfGroup);
//        }
//        [groupArray addObject:group];


- (void)testCreateGroup
{
    CFErrorRef errorRef = NULL;
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    STAssertTrue(addressBookRef != NULL, @"addressBookRef is NULL");
    
    ABRecordRef groupRef = ABGroupCreate();
    STAssertTrue(groupRef != NULL, @"groupRef is NULL");
    
    CFStringRef name = (CFStringRef)@"테스트그룹";
    ABRecordSetValue(groupRef, kABGroupNameProperty, name, &errorRef);
    
    STAssertTrue(errorRef == NULL, @"error is not NULL");
    
    ABAddressBookAddRecord(addressBookRef, groupRef, &errorRef);
    ABAddressBookSave(addressBookRef, &errorRef);
    
    NSInteger groupId = ABRecordGetRecordID(groupRef);
    STAssertTrue(groupId > 0, @"group is not created");
    
    CFRelease(groupRef);
    CFRelease(addressBookRef);
}

- (void)testDeleteGroup
{
    
    NSInteger groupId = 1;
    
    CFErrorRef errorRef = NULL;
    
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    STAssertTrue(addressBookRef != NULL, @"addressBookRef is NULL");
    
    ABRecordRef savedGroupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);
    STAssertTrue(savedGroupRef != NULL, @"groupRef is not saved");

    if (savedGroupRef != NULL) {
        ABAddressBookRemoveRecord(addressBookRef, savedGroupRef, &errorRef);
        ABAddressBookSave(addressBookRef, &errorRef);
        
        savedGroupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);
        STAssertTrue(savedGroupRef == NULL, @"groupRef is not deleted");
        
    }
    
    
    if (errorRef != NULL) {
        CFRelease(errorRef);
    }

    CFRelease(addressBookRef);
}

- (void)testFindAllContacts
{
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    CFArrayRef peopleRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    
    if (peopleRef != NULL) {
        for (int i= 0; i < CFArrayGetCount(peopleRef); i++) {
            
            ABRecordRef personRef = CFArrayGetValueAtIndex(peopleRef, i);
            
            NSInteger personId = ABRecordGetRecordID(personRef);
            
            STAssertTrue(personId != 0, @"person not exist");
                
            CFStringRef lastNameRef = ABRecordCopyValue(personRef, kABPersonLastNameProperty);
            if (lastNameRef != NULL) {
//                [personInfo setValue:(__bridge NSString *) lastName forKey:@"lastName"];
                NSLog(@"kABPersonLastNameProperty : %@", lastNameRef);
                CFRelease(lastNameRef);
            }
            
            CFStringRef firstNameRef = ABRecordCopyValue(personRef, kABPersonFirstNameProperty);
            if (firstNameRef != NULL) {
//                [personInfo setValue:(__bridge NSString *) firstNameRef forKey:@"firstName"];
                NSLog(@"kABPersonFirstNameProperty :%@", firstNameRef);
                CFRelease(firstNameRef);
            }
            
            CFStringRef middleNameRef = ABRecordCopyValue(personRef, kABPersonMiddleNameProperty);
            if (middleNameRef != NULL) {
                NSLog(@"kABPersonMiddleNameProperty : %@", middleNameRef);
                CFRelease(middleNameRef);
            }
            
            CFStringRef prefixRef = ABRecordCopyValue(personRef, kABPersonPrefixProperty);
            if (prefixRef != NULL) {
                NSLog(@"kABPersonPrefixProperty : %@", prefixRef);
                CFRelease(prefixRef);
            }
        
            
            
//            CFStringRef organizationRef = ABRecordCopyValue(personRef, kABPersonOrganizationProperty);
//            if (organizationRef != NULL) {
//                [personInfo setValue:(__bridge NSString *)organizationRef forKey:@"organization"];
//                CFRelease(organizationRef);
//            }
//            
//            CFStringRef departmentRef = ABRecordCopyValue(personRef, kABPersonDepartmentProperty);
//            if (departmentRef != NULL) {
//                [personInfo setValue:(__bridge NSString *)departmentRef forKey:@"department"];
//                CFRelease(departmentRef);
//            }
//            
//            CFStringRef jobTitleRef = ABRecordCopyValue(personRef, kABPersonJobTitleProperty);
//            if (jobTitleRef != NULL) {
//                [personInfo setValue:(__bridge NSString *)jobTitleRef forKey:@"jobTitle"];
//                CFRelease(jobTitleRef);
//            }
            
        }
        CFRelease(peopleRef);
    };
    
    CFRelease(addressBookRef);
    

}


@end
