//
//  CategoryTableViewController.m
//  QarsaniOS
//
//  Created by Michael Weingert on 2015-04-11.
//  Copyright (c) 2015 PBC. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "FirebaseManager.h"
#import "NonHeaderTableViewCell.h"

@interface CategoryTableViewController ()

@end

@implementation CategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
  [self.tableView setContentInset:UIEdgeInsetsMake(80,0,0,0)];
}

-(void) viewWillAppear:(BOOL)animated
{
  //Force a reload of data from the database
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
  NSString *sectionString;
  switch (section)
  {
    case 0:
      sectionString = @"Women";
      break;
    case 1:
      sectionString = @"World";
      break;
    default:
      sectionString = @"Middle East";
  }
  return [[FirebaseManager sharedManager] getNumberOfStoriesForCategory:sectionString];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if (section == 0){
    return @"Women";
  } else if (section == 1){
    return @"World";
  } else {
    return @"Middle East";
  }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *notHeaderTableCellIdentifier = @"NotHeaderCellIdentifier";
  NonHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:notHeaderTableCellIdentifier];
  
  if (cell == nil) {
    cell = [[NonHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notHeaderTableCellIdentifier];
  }
  
  int cellIndex = [[FirebaseManager sharedManager] getIndexForSection:[indexPath section] andRow:[indexPath row]];
  
  NSString * headline = [[FirebaseManager sharedManager] getHeadlineWithId:[NSNumber numberWithInt: cellIndex]];
  NSString * article = [[FirebaseManager sharedManager] getStoryWithId:[NSNumber numberWithInt: cellIndex]];
  NSString * category = [[FirebaseManager sharedManager] getCategoryWithId:[NSNumber numberWithInt: cellIndex]];
  [cell setHeadline:headline andArticle:article andCategory:category];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([indexPath row] == -1)
  {
    return UITableViewAutomaticDimension;
  } else {
    return 80;
  }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
