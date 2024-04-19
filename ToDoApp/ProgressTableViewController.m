//
//  ProgressTableViewController.m
//  ToDoApp
//
//  Created by Amira on 18/04/2024.
//

#import "ProgressTableViewController.h"
#import "Task.h"
#import "CustomTableViewCell.h"
#import "AddViewController.h"

@interface ProgressTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UITableView *myProgressTaple;
@property NSMutableArray *tasks;

@end

@implementation ProgressTableViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

-(void)reloadData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *tasksData = [defaults arrayForKey:@"tasks"];
    
    self.tasks = [NSMutableArray new];
    for (NSData *data in tasksData) {
        Task *task = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([task.status isEqualToString:@"progress"]){
            [self.tasks addObject:task];
            
        }
    }
    if (self.tasks == nil || self.tasks.count == 0) {
            _myImage.image = [UIImage imageNamed:@"progress"]; // Replace "empty_tasks" with your image name
            _myImage.hidden = NO;
    } else {
        _myImage.hidden = YES;
    }
    [self.myProgressTaple reloadData];
}


- (void)viewDidLoad{
    
    
    _myProgressTaple.dataSource=self;
    _myProgressTaple.delegate=self;
    
    [self reloadData];
//    printf(@"tasks number from todo screen = >>> %d ",_tasks.count);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in each section based on priority level
    return _tasks.count;
    
}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return @"High";
//        case 1:
//            return @"Medium";
//        case 2:
//            return @"Low";
//        default:
//            return @"";
//    }
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
    }

    Task *task = self.tasks[indexPath.row];
    cell.titleLabel.text = task.title;
    
    if([task.periority isEqualToString:@"High"]){
        cell.customImageView.image = [UIImage imageNamed:@"red"];
    }else if([task.periority isEqualToString:@"Low"]){
        cell.customImageView.image = [UIImage imageNamed:@"yellow"];
    }else{
        cell.customImageView.image = [UIImage imageNamed:@"green"];
    }    cell.customImageView.contentMode = UIViewContentModeScaleAspectFit;

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *selectedTask = self.tasks[indexPath.row];
    AddViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"add_id"];
    detailsVC.task = selectedTask;
    detailsVC.taskIndex=indexPath.row;
    NSLog(@"number of task index = %d",indexPath.row);
    [self.navigationController pushViewController:detailsVC animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the task from the array
        [self.tasks removeObjectAtIndex:indexPath.row];
        
        // Update UserDefaults
        NSMutableArray *tasksData = [NSMutableArray array];
        for (Task *task in self.tasks) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:task];
            [tasksData addObject:data];
        }
        [[NSUserDefaults standardUserDefaults] setObject:tasksData forKey:@"tasks"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Update the table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    //
    //- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    //    if (!cell) {
    //        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
    //    }
    //
    //    Task *task = self.tasks[indexPath.row];
    //    cell.titleLabel.text = task.title;
    //    if([task.periority isEqualToString:@"High"]){
    //        cell.customImageView.image = [UIImage imageNamed:@"red"];
    //    }else if([task.periority isEqualToString:@"Low"]){
    //        cell.customImageView.image = [UIImage imageNamed:@"yellow"];
    //    }else{
    //        cell.customImageView.image = [UIImage imageNamed:@"green"];
    //    }
    //    cell.customImageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    //    return cell;
    //}
    
    
    //- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    Task *selectedTask = self.tasks[indexPath.row];
    //    AddViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"add_id"];
    //    detailsVC.task = selectedTask;
    //    detailsVC.taskIndex=indexPath.row;
    //    [self.navigationController pushViewController:detailsVC animated:YES];
    //}
    //
    //- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (editingStyle == UITableViewCellEditingStyleDelete) {
    //        // Delete the task from the array
    //        [self.tasks removeObjectAtIndex:indexPath.row];
    //
    //        // Update UserDefaults
    //        NSMutableArray *tasksData = [NSMutableArray array];
    //        for (Task *task in self.tasks) {
    //            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:task];
    //            [tasksData addObject:data];
    //        }
    //        [[NSUserDefaults standardUserDefaults] setObject:tasksData forKey:@"tasksProgress"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //        // Update the table view
    //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //    }
    
    
    
    
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
}
@end
