//
//  ViewController.m
//  ToDoApp
//
//  Created by Amira on 17/04/2024.
//
#import "ViewController.h"
#import "AddViewController.h"
#import "CustomTableViewCell.h"
#import "Task.h"
@interface ViewController (){
    NSMutableArray *filterArray;
    BOOL isFiltered;
}
@property (weak, nonatomic) IBOutlet UIImageView *myImage;

@property (weak, nonatomic) IBOutlet UIButton *add;
@property (weak, nonatomic) IBOutlet UINavigationItem *myBar;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property NSMutableArray *tasks;


@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Reload data here
    [self reloadData];
}


-(void)reloadData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *tasksData = [defaults arrayForKey:@"tasks"];
 
    self.tasks = [NSMutableArray new];
    for (NSData *data in tasksData) {
        Task *task = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.tasks addObject:task];
    }
    if (self.tasks == nil || self.tasks.count == 0) {
            _myImage.image = [UIImage imageNamed:@"tasks"]; // Replace "empty_tasks" with your image name
            _myImage.hidden = NO;
    } else {
        _myImage.hidden = YES;
    }
    [self.myTable reloadData];
}

- (void)viewDidLoad{
    
    isFiltered=false;
    self.searchBar.delegate=self;
    _myTable.dataSource=self;
    _myTable.delegate=self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *tasksData = [defaults arrayForKey:@"tasks"];
    self.tasks = [NSMutableArray new];
    for (NSData *data in tasksData) {
        Task *task = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.tasks addObject:task];
    }
    [self.myTable reloadData];
    printf(@"tasks number from todo screen = >>> %d ",_tasks.count);
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        isFiltered=false;
    }else{
        isFiltered=true;
        filterArray=[[NSMutableArray alloc]init];
        
        for(Task *taskk in _tasks){
            NSRange nameRange=[taskk.title rangeOfString:searchText options: NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound){
                [filterArray addObject:taskk];
            }
        }
    }
    [self.myTable reloadData];
}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    [self.myTable reloadData];
//    UIBarButtonItem *customButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
//                                                                         style:UIBarButtonItemStylePlain
//                                                                        target:self
//                                                                        action:@selector(customButtonTapped)];
//        // Set the button to the right side of the navigation bar
//        self.navigationItem.rightBarButtonItem = customButton;
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isFiltered){
        return  filterArray.count;
    }
    return _tasks.count;
   }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
    }

    
    if (isFiltered){
        
        Task *task = filterArray[indexPath.row];
        cell.titleLabel.text = task.title;
        if([task.periority isEqualToString:@"High"]){
            cell.customImageView.image = [UIImage imageNamed:@"red"];
        }else if([task.periority isEqualToString:@"Low"]){
            cell.customImageView.image = [UIImage imageNamed:@"yellow"];
        }else{
            cell.customImageView.image = [UIImage imageNamed:@"green"];
        }    cell.customImageView.contentMode = UIViewContentModeScaleAspectFit;

        
    }else{
        Task *task = self.tasks[indexPath.row];
        cell.titleLabel.text = task.title;
        
        if([task.periority isEqualToString:@"High"]){
            cell.customImageView.image = [UIImage imageNamed:@"red"];
        }else if([task.periority isEqualToString:@"Low"]){
            cell.customImageView.image = [UIImage imageNamed:@"yellow"];
        }else{
            cell.customImageView.image = [UIImage imageNamed:@"green"];
        }    cell.customImageView.contentMode = UIViewContentModeScaleAspectFit;

    }
    
    return cell;
}
- (IBAction)plusTask:(id)sender {
    AddViewController *add=[self.storyboard instantiateViewControllerWithIdentifier:@"add_id"];
    [self.navigationController pushViewController:add animated:YES];
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
