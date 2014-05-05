//
//  FriendsViewController.m
//  HappyNotes
//
//  Created by Ryan Sickles on 4/27/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditFriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    //get the message
    //changes the background of the view controller
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_bg.jpg"]];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
        {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else{
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 if([segue.identifier isEqualToString:@"showEditFriends"] )
 {
     
     EditFriendsViewController *viewController = (EditFriendsViewController *)segue.destinationViewController;
     viewController.friends = [NSMutableArray arrayWithArray:self.friends];
     
 }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.friends count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    cell.contentView.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
    cell.textLabel.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
    cell.textLabel.textColor = [ UIColor colorWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1.0 ];
    
    return cell;
}



@end
