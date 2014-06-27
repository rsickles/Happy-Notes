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
    //changes the background of the view controller
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_bg.jpg"]];
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
        cell.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
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
    cell.contentView.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
    cell.textLabel.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
    cell.textLabel.textColor = [ UIColor colorWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1.0 ];
    cell.accessoryView.backgroundColor = [ UIColor colorWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1.0 ];
    cell.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];

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
        self.notes.text = nil;
    }
    
}

-(void)uploadMessage{
//    NSString *message = self.notes.text;
    //self.image stores the image that is going to be uploaded
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if(self.image != nil)
    {
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
        
    }
    PFFile *file = [PFFile fileWithName:fileName data:fileData];

    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Try Sending Picture Again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    
                    [alertView show];
                }
                else{
                    //Picture is sent so remove all recipients!
                    PFObject *message = [PFObject objectWithClassName:@"Messages"];
                    [message setObject:file forKey:@"file"];
                    [message setObject:fileType forKey:@"fileType"];
                    [message setObject:self.recipients forKey:@"recipientIds"];
                    [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
                    [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
                    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(error){
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Try Sending Picture Again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                            
                            [alertView show];
                        }
                        else{
                            self.image = nil;
                            [self.recipients removeAllObjects];
                            //save to parse is successful!
                            
                        }
                    }];
                }
            }];
}

//resize image to needed size
-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

@end
