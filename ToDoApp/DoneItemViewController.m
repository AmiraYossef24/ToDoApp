//
//  DoneItemViewController.m
//  ToDoApp
//
//  Created by Amira on 17/04/2024.
//

#import "DoneItemViewController.h"
#import "Task.h"
#import "CustomTableViewCell.h"
#import "AddViewController.h"

@interface DoneItemViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UITableView *myDoneTable;
@property NSMutableArray *tasks;

@end

@implementation DoneItemViewController

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
        if([task.status isEqualToString:@"done"]){
            [self.tasks addObject:task];
        }
    }
    if (self.tasks == nil || self.tasks.count == 0) {
            _myImage.image = [UIImage imageNamed:@"done"]; // Replace "empty_tasks" with your image name
            _myImage.hidden = NO;
    } else {
        _myImage.hidden = YES;
    }
    [self.myDoneTable reloadData];
}


- (void)viewDidLoad{
    
    
    _myDoneTable.dataSource=self;
    _myDoneTable.delegate=self;
    
    [self reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tasks.count;
}


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
}

@end
