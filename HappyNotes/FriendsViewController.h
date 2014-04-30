//
//  FriendsViewController.h
//  HappyNotes
//
//  Created by Ryan Sickles on 4/27/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "NotesViewController.h"

@interface FriendsViewController : UITableViewController

@property (nonatomic,strong) PFRelation *friendsRelation;
@property (nonatomic,strong) NSArray *friends;

@end
