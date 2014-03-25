//
//  RootVC.m
//  DemoCoreAnimation
//
//  Created by Allen1 on 14-3-24.
//  Copyright (c) 2014年 zhouyu. All rights reserved.
//

#import "RootVC.h"
#import "ImplicitAnimationsViewController.h"
#import "BitItVC.h"
#import "BezierVC.h"

@interface RootVC ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation RootVC

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.items = [NSMutableArray array];
    
    NSMutableArray *layersList = [NSMutableArray array];
    
	[layersList addObject:[ImplicitAnimationsViewController class]];
	[layersList addObject:[BitItVC class]];
	[layersList addObject:[BezierVC class]];
    
    #if 0
	[layersList addObject:[BatmanViewController class]];
	[layersList addObject:[PacmanViewController class]];
	[layersList addObject:[SublayerTransformViewController class]];
	[layersList addObject:[AVPlayerLayerViewController class]];
	[layersList addObject:[NSAViewController class]];
	[layersList addObject:[ReflectionViewController class]];
	[layersList addObject:[PulseViewController class]];
#endif
	NSDictionary *layers = @{@"Core Animation": layersList};
	[self.items addObject:layers];
	
	NSMutableArray *uiKitList = [NSMutableArray array];
#if 0
	[uiKitList addObject:[SimpleViewPropertyAnimation class]];
	[uiKitList addObject:[StickyNotesViewController class]];
	[uiKitList addObject:[FlipViewController class]];
    
#endif
	NSDictionary *uiKits = @{@"UIKit Animation": uiKitList};
	[self.items addObject:uiKits];
    
	self.title = @"Animations";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSArray *)valuesForSection:(NSUInteger)section {
	NSDictionary *dictionary = (self.items)[section];
	NSString *key = [dictionary allKeys][0];
	return dictionary[key];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.items count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [(self.items)[section] allKeys][0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self valuesForSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	NSArray *values = [self valuesForSection:indexPath.section];
	cell.textLabel.text = NSStringFromClass(values[indexPath.row]);
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *values = [self valuesForSection:indexPath.section];
	Class clazz = values[indexPath.row];
	id controller = [[clazz alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */



@end
