//
//  SignUpViewController.m
//  HappyNotes
//
//  Created by Ryan Sickles on 4/26/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)signup:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([username length] == 0 || [password length] == 0 || [email length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some fields are incomplete" delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.email = email;
        newUser.password = password;
        [newUser signUpInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
            if(error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        //sequential code being run
        
    }
}
@end
