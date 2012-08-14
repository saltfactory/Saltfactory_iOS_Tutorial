//
//  SFContactService.m
//  SFAddressbookTutorial
//
//  Created by saltfactory on 8/13/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import "SFContactService.h"
#import <AddressBook/AddressBook.h>
@implementation SFContactService
@synthesize delegate;


- (void)findContactsWithGroupId:(NSInteger)groupId
{
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    
    ABRecordRef groupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupId);
    CFArrayRef membersRef = ABGroupCopyArrayOfAllMembers(groupRef);
    
    NSMutableArray *contacts = [NSMutableArray array];
    
    if (membersRef != NULL) {
        for (int i= 0; i < CFArrayGetCount(membersRef); i++) {
            NSMutableDictionary *personInfo = [NSMutableDictionary dictionary];
            
            ABRecordRef personRef = CFArrayGetValueAtIndex(membersRef, i);
            
            NSInteger personId = ABRecordGetRecordID(personRef);
            
            [personInfo setValue:[NSNumber numberWithInteger:personId] forKey:@"personId"];
            
            
            CFStringRef lastName = ABRecordCopyValue(personRef, kABPersonLastNameProperty);
            if (lastName != NULL) {
                [personInfo setValue:(__bridge NSString *) lastName forKey:@"lastName"];
                CFRelease(lastName);
            }
            
            CFStringRef firstName = ABRecordCopyValue(personRef, kABPersonFirstNameProperty);
            if (firstName != NULL) {
                [personInfo setValue:(__bridge NSString *) firstName forKey:@"firstName"];
                CFRelease(firstName);
            }
             
            [contacts addObject:personInfo];
        }
        CFRelease(membersRef);
    };
    
    CFRelease(addressBookRef);
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [contacts sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [self.delegate contactServiceDidFindContacts:contacts];
}


- (void)findAllContacts
{
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    CFArrayRef peopleRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    NSMutableArray *personInfos = [NSMutableArray array];
    
    if (peopleRef != NULL) {
        for (int i= 0; i < CFArrayGetCount(peopleRef); i++) {
            NSMutableDictionary *personInfo = [NSMutableDictionary dictionary];
            
            ABRecordRef personRef = CFArrayGetValueAtIndex(peopleRef, i);
            
            NSInteger personId = ABRecordGetRecordID(personRef);
            
            [personInfo setValue:[NSNumber numberWithInteger:personId] forKey:@"personId"];
            
            
            CFStringRef lastName = ABRecordCopyValue(personRef, kABPersonLastNameProperty);
            if (lastName != NULL) {
                [personInfo setValue:(__bridge NSString *) lastName forKey:@"lastName"];
                CFRelease(lastName);
            }
            
            CFStringRef firstName = ABRecordCopyValue(personRef, kABPersonFirstNameProperty);
            if (firstName != NULL) {
                [personInfo setValue:(__bridge NSString *) firstName forKey:@"firstName"];
                CFRelease(firstName);
            }
            
            
            CFStringRef organizationRef = ABRecordCopyValue(personRef, kABPersonOrganizationProperty);
            if (organizationRef != NULL) {
                [personInfo setValue:(__bridge NSString *)organizationRef forKey:@"organization"];
                CFRelease(organizationRef);
            }
            
            CFStringRef departmentRef = ABRecordCopyValue(personRef, kABPersonDepartmentProperty);
            if (departmentRef != NULL) {
                [personInfo setValue:(__bridge NSString *)departmentRef forKey:@"department"];
                CFRelease(departmentRef);
            }
            
            CFStringRef jobTitleRef = ABRecordCopyValue(personRef, kABPersonJobTitleProperty);
            if (jobTitleRef != NULL) {
                [personInfo setValue:(__bridge NSString *)jobTitleRef forKey:@"jobTitle"];
                CFRelease(jobTitleRef);
            }
            
            [personInfos addObject:personInfo];
        }
        CFRelease(peopleRef);
    };
    
    CFRelease(addressBookRef);
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [personInfos sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

}
@end
