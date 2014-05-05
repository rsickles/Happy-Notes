//
//  InboxViewController.m
//  HappyNotes
//
//  Created by Ryan Sickles on 4/24/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "InboxViewController.h"
#import <Parse/Parse.h>

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //changes the background of the view controller
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_bg.jpg"]];
    
    
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser)
    {
        
    }
    else
    {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    //refreshing icon
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor greenColor];
    [refreshControl addTarget:self action:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    
    //add swiping intergration to the right for evernote
    
    
//    UISwipeGestureRecognizer* rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
//    
//    
//        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//        [self.tableView addGestureRecognizer:rightSwipeGestureRecognizer];
    
//    // Setup a left swipe gesture recognizer
//    UISwipeGestureRecognizer* leftSwipeGestureRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)] autorelease];
//    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    [tableView addGestureRecognizer:leftSwipeGestureRecognizer];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleSwipeLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:recognizer];
    
    //Add a right swipe gesture recognizer
//    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
//                                                           action:@selector(handleSwipeRight:)];
//    recognizer.delegate = self;
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [self.tableView addGestureRecognizer:recognizer];
//    
    
}

- (void)changeSorting
{
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser]objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            
        }
        else{
            self.messages = objects;
            [self.tableView reloadData];
        }
    }];
    
    [self.refreshControl endRefreshing];
}


                                                             

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    
    //Get location of the swipe
    CGPoint location = [gestureRecognizer locationInView:self.tableView];
    
    
    
    //Get the corresponding index path within the table view
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    
    
    //Check if index path is valid
    if(indexPath)
    {
        //Get the cell out of the table view
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        //Update the cell or model
        cell.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1.0];
        //delete message
        [self deleteMessage];
    }
}

-(void)deleteMessage{
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
    NSLog(@"%@",self.selectedMessage);
    NSLog(@"Recipients %@", [[PFUser currentUser] objectId]);
    if([recipientIds count] == 1){
        [self.selectedMessage deleteInBackground];
    }
    else{
        [recipientIds removeObject:[[PFUser currentUser] objectId]];
        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
    }
    [self refresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser]objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            
        }
        else{
            self.messages = objects;
            [self.tableView reloadData];
        }
    }];
}

-(void)refresh{
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser]objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            
        }
        else{
            self.messages = objects;
            [self.tableView reloadData];
        }
    }];
}


- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        if([segue.identifier isEqualToString:@"showLogin"])
        {
            [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    
    //NSLog(@"Message Selected %@",[self.messages objectAtIndex:indexPath.row]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    NSMutableString *messageSender = [message objectForKey:@"senderName"];
    NSMutableString *messageContent = [message objectForKey:@"file"];
    NSMutableString *spacing = @" - ";
    NSMutableString *firstHalf = [messageSender stringByAppendingString:spacing];
    NSString *messageFull = [firstHalf stringByAppendingString:messageContent];
   
    //customizing cells
    cell.textLabel.text = messageFull;
    cell.imageView.image = [UIImage imageNamed:@"read_message-32.png"];
    cell.contentView.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
    cell.textLabel.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
    cell.textLabel.textColor = [ UIColor colorWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1.0 ];
    
    //can add an icon next to each text
    //cell.imageView.image = firstHalf;//[UIImage imageNamed:@"filename"];
    
    return cell;
}



@end
