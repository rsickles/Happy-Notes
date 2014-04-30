//
//  RecepientsViewController.h
//  HappyNotes
//
//  Created by Ryan Sickles on 4/29/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RecepientsViewController : UITableViewController
@property (nonatomic,strong) IBOutlet UITextField *notes;
@property (nonatomic,strong) NSArray *friends;
@property (nonatomic,strong) PFRelation *friendsRelation;
@property (nonatomic,strong) NSMutableArray *recipients;
- (IBAction)send:(id)sender;
-(void)uploadMessage;



//might need to erase self.receipents when you go back 
@end
