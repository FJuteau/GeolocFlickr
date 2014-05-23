//
//  CitiesTableViewController.m
//  GeolocFlickr
//
//  Created by orsys on 22/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import "CitiesTableViewController.h"
#import "City.h"
#import "City+DAO.h"
#import "PicturesViewController.h"

@interface CitiesTableViewController ()

@property (strong, nonatomic) NSMutableArray * cities;

@end

@implementation CitiesTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Boxing en mutable
    self.cities = [[City allCities] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    City * c = self.cities[indexPath.row];
    BOOL isLocalized = (c.name != nil);
    
    UITableViewCell *cell;
    
    if (isLocalized)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CITY_CELL" forIndexPath:indexPath];
        
        cell.textLabel.text = c.name;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WAIT_CELL" forIndexPath:indexPath];
        
        UILabel * textLabel = (UILabel *)[cell viewWithTag:1];
        textLabel.text = NSLocalizedString(@"Loading", nil);
    }
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        City * c = self.cities[indexPath.row];
        
        [City deleteCity:c];
        
        [self.cities removeObject:c];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

//In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CITY_SELECTED_SEGUE"])
    {
        // Récupération de la city sélectionné
        NSIndexPath * selectedCityIndexPath = self.tableView.indexPathForSelectedRow;
//        NSIndexPath * selectedCityIndexPath = [self.tableView indexPathForCell:sender];
        
        City * selectedCity = self.cities[selectedCityIndexPath.row];
        
        // Création de la location
        // On utilise cette syntaxe car PictureServiceLocation est une structure donc C
        PicturesServiceLocation location;
        // Déboxing en double value
        location.latitude = selectedCity.latitude.doubleValue;
        location.longitude = selectedCity.longitude.doubleValue;
        
        
        // Passage au PictureViewController
        PicturesViewController * vc = [segue destinationViewController];
        vc.location = location;
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)handleAddCity:(id)sender
{
    City * c = [City new];
    [self.cities addObject:c];
    [self.tableView reloadData];
    
    [c addObserver:self
        forKeyPath:@"name"
           options:NSKeyValueObservingOptionNew
           context:nil];
}

#pragma mark - KVO

// Callback de "addObserver"
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // On reload les datas de la tableView vu qu'on vient de recevoir les datas
    [self.tableView reloadData];
    
    [object removeObserver:self forKeyPath:keyPath];
}

@end
