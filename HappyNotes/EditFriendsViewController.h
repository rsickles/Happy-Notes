//
//  EditFriendsViewController.h
//  HappyNotes
//
//  Created by Ryan Sickles on 4/27/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsViewController : UITableViewController

@property (nonatomic,strong) NSArray *allUsers;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic,strong) NSMutableArray *friends;

-(BOOL)isFriend:(PFUser *)user;
@end
