//
//  RecepientsViewController.m
//  HappyNotes
//
//  Created by Ryan Sickles on 4/29/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "RecepientsViewController.h"

@interface RecepientsViewController ()

@end

@implementation RecepientsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    self.recipients = [[NSMutableArray alloc] init];
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
        {
            
        }
        else{
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    
    if(cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    
    if([self.recipients containsObject:user.objectId]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (IBAction)send:(id)sender {
    
    if([self.notes.text length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sent Message Is Empty!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }
    else{
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    }
    
}

-(void)uploadMessage{
    NSString *message = self.notes.text;
    PFObject *data = [PFObject objectWithClassName:@"Messages"];
    [data setObject:message forKey:@"file"];
    [data setObject:self.recipients forKey:@"recipientIds"];
    [data setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
    [data setObject:[[PFUser currentUser] username] forKey:@"senderName"];
    [data saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Try Sending Message Again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    
                    [alertView show];
                }
                else{
                    //Message is sent so remove all recipients!
                    [self.recipients removeAllObjects];
                }
            }];
}

@end
