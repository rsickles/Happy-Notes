//
//  NotesViewController.h
//  HappyNotes
//
//  Created by Ryan Sickles on 4/28/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesViewController : UIViewController <UITextFieldDelegate>

@property (strong,nonatomic) IBOutlet UITextField *notes;
- (IBAction)sendNote:(id)sender;



@end
