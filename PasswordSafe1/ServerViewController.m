//
//  ServerViewController.m
//  PasswordSafe1
//
//  Created by CSSE Department on 4/12/13.
//  Copyright (c) 2013 Software Security Consultants Incorporated. All rights reserved.
//

#import "ServerViewController.h"
#import "WebDAVAPI.h"
#import "AppDelegate.h"

@interface ServerViewController ()

@end

@implementation ServerViewController

@synthesize URLTextField = __URLTextField;
@synthesize UsernameTextField = __UsernameTextField;
@synthesize PasswordTextField = __PasswordTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveData:(id)sender{
    [[AppDelegate sharedAppDelegate] setServerURL:self.URLTextField.text];
    [[AppDelegate sharedAppDelegate] setUsername:self.UsernameTextField.text];
    [[AppDelegate sharedAppDelegate] setPassword:self.PasswordTextField.text];
    WebDAVAPI *api = [[WebDAVAPI alloc] init];
    if([api validCredentials]){
        [self SaveIsValidPopup];
    } else {
        [self SaveIsInvalidPopup];
    }
}

- (void)SaveIsValidPopup{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Successful"
                                                    message:@"Settings have been saved"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)SaveIsInvalidPopup{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection was Unsuccessful"
                                                    message:@"Settings have been saved"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


@end
