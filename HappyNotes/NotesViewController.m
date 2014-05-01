//
//  NotesViewController.m
//  HappyNotes
//
//  Created by Ryan Sickles on 4/28/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "NotesViewController.h"
#import "RecepientsViewController.h"

@interface NotesViewController ()

@end

@implementation NotesViewController
@synthesize notes;


- (void)viewDidLoad
{
    [super viewDidLoad];
    notes.delegate = self;
}



-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [notes resignFirstResponder];
    return YES;
}
-(void)sendNote:(id)sender{
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGRect newBounds = textField.bounds;
    self.originalWidth = &(newBounds.size.width);
    newBounds.size.width = 300; //whatever you want the new width to be
    
    [UIView beginAnimations:nil context:nil];
    textField.bounds = newBounds;
    [UIView commitAnimations];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    CGRect newBounds = textField.bounds;
    newBounds.size.width = 120; //whatever you want the new width to be
    
    [UIView beginAnimations:nil context:nil];
    textField.bounds = newBounds;
    [UIView commitAnimations];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"addRecep"] )
    {
        RecepientsViewController *viewController = (RecepientsViewController *)segue.destinationViewController;
        viewController.notes = self.notes;


        
    }
}

@end
