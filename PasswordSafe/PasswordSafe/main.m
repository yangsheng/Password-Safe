//
//  main.m
//  PasswordSafe
//
//  Created by CSSE Department on 12/12/12.
//  Copyright (c) 2012 Software Security Consultants Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Generator.h"
#import "Note.h"
#import "Account.h"

int main(int argc, char *argv[])
{
    Generator *test = [[Generator alloc] init];
    NSMutableString *testString = [[NSMutableString alloc] initWithString:[test generatePassword:8 :1 :3 :2 :2]];
    NSMutableString *aTitle = [[NSMutableString alloc] initWithString:@"titulars"];
    for (int i = 0; i < 1; i++) {
    NSLog(testString);
    }
    [testString setString:[test generatePassword:8 :1 :3 :2 :2]];
    Note *testNote = [[Note alloc] init: aTitle: testString];
    [testNote saveNote];
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
