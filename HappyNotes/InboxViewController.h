//
//  InboxViewController.h
//  HappyNotes
//
//  Created by Ryan Sickles on 4/24/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface InboxViewController : UITableViewController

@property (nonatomic,strong) NSArray *messages;
@property (nonatomic,strong) PFObject *selectedMessage;
- (IBAction)logout:(id)sender;

@end
