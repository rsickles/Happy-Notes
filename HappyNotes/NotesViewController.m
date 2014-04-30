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

- (IBAction)sendNote:(id)sender {
     
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
