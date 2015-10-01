//
//  AddCityViewController.m
//  GeolocFlickr
//
//  Created by François Juteau on 27/08/2015.
//  Copyright (c) 2015 François Juteau. All rights reserved.
//

#import "AddCityViewController.h"
#import <AddressBook/AddressBook.h>

@interface AddCityViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *switchLocalize;
@property (weak, nonatomic) IBOutlet UITextField *txtfieldCity;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItemSave;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation AddCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cityName = @"";
    
    [self.txtfieldCity setDelegate:self];
    
    [self.spinner stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Outlet handler methods

- (IBAction)handleLocalizeSwitch:(UISwitch *)sender
{
    if (sender.isOn)
    {
        [self.txtfieldCity setText:@""];
        [self.txtfieldCity setEnabled:NO];
        [self.barButtonItemSave setEnabled:YES];
        [self.spinner stopAnimating];
    }
    else
    {
        [self.txtfieldCity setEnabled:YES];
        [self.barButtonItemSave setEnabled:NO];
    }
}


#pragma mark - UITextField delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.spinner startAnimating];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder geocodeAddressString:self.txtfieldCity.text
                 completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"Geocode failed with error : %@", error.localizedDescription);
         }
         else
         {
             if (placemarks.count > 0)
             {
                 CLPlacemark *placeMark = [placemarks objectAtIndex:0];
                 CLLocation *location = placeMark.location;
                 self.coords = location.coordinate;
             }
             [self setCityName:self.txtfieldCity.text];
             [self.spinner stopAnimating];
             [self.barButtonItemSave setEnabled:YES];
             NSLog(@"Trouver");
         }
     }];
    
    
    
    return YES;
}

@end
