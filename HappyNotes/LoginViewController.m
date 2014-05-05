//
//  LoginViewController.m
//  HappyNotes
//
//  Created by Ryan Sickles on 4/26/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    //changes the background of the view controller
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_bg.jpg"]];
    // Do any additional setup after loading the view.
}

- (IBAction)login:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([username length] == 0 || [password length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some fields are incomplete" delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    else{
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error){
            if(error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
                [alert show];
            }
            else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }

}
@end
