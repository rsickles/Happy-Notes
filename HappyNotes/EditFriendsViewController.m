//
//  EditFriendsViewController.m
//  HappyNotes
//
//  Created by Ryan Sickles on 4/27/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "EditFriendsViewController.h"

@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //changes the background of the view controller
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_bg.jpg"]];
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       if(error)
       {
        
       }
       else{
           self.allUsers = objects;
           [self.tableView reloadData];
       }
    }];
    
    self.currentUser = [PFUser currentUser];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allUsers count];
}

-(UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    cell.contentView.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
    cell.textLabel.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
    cell.textLabel.textColor = [ UIColor colorWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1.0 ];
    cell.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
    if([self isFriend:user])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    
    
    if([self isFriend:user]){
        cell.accessoryType = UITableViewCellAccessoryNone;
        for(PFUser *friend in self.friends)
        {
            if([friend.objectId isEqualToString:user.objectId])
            {
                [self.friends removeObject:friend];
                break;
            }
        }
        [friendsRelation removeObject:user];
        //deselect them as your friend
    }
    else{
        //add them as a friend
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];

        [self.friends addObject:user];
        [friendsRelation addObject:user];
    }
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    }];
    

}

#pragma mark - Helper Methods

-(BOOL)isFriend:(PFUser *)user
{
    for(PFUser *friend in self.friends)
    {
        if([friend.objectId isEqualToString:user.objectId])
        {
            return YES;
        }
    }
    return NO;
}


@end
