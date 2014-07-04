//
//  SignUpViewController.m
//  HappyNotes
//
//  Created by Ryan Sickles on 4/26/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "SignUpViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //changes the background of the view controller
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_bg.jpg"]];
    self.imagePicker =[[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
}

- (IBAction)signup:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([username length] == 0 || [password length] == 0 || [email length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some fields are incomplete" delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.email = email;
        newUser.password = password;
        
        [newUser signUpInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
            if(error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                //resize pro pic image
                UIGraphicsBeginImageContext(CGSizeMake(640, 960));
                [self.image drawInRect: CGRectMake(0, 0, 640, 960)];
                NSData *imageData = UIImageJPEGRepresentation(self.image, 0.05f);
                PFFile *imageFile = [PFFile fileWithName:@"pro-pic.jpg" data:imageData];
                //have to upload image
                PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
                [userPhoto setObject:imageFile forKey:@"imageFile"];
                [userPhoto setObject:newUser forKey:@"user"];
                [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                    else{
                        
                    }
                }];
                //end of uploading pro pic image
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        //sequential code being run
        
    }
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIImagePickerController *controller = [segue destinationViewController];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];

    }
    else{
        //alert that it is not an image
    }
}

- (IBAction)proPicUpload:(id)sender {
    [self performSegueWithIdentifier:@"imagePicker" sender:self];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
