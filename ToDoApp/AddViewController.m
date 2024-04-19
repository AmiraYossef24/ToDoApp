//
//  AddViewController.m
//  ToDoApp
//
//  Created by Amira on 17/04/2024.
//

#import "AddViewController.h"
#import "Task.h"
#import "ViewController.h"
#import "ProgressTableViewController.h"
@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UITextField *titleTx;
@property (weak, nonatomic) IBOutlet UITextField *descTx;
@property (weak, nonatomic) IBOutlet UISegmentedControl *periority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *status;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property NSMutableArray<Task*> * existingTasksData;
@property int per;
@property int sta;
@property NSDate *da;

@end

@implementation AddViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.task!=nil){
        [self showImage:self.task];
        [self.addBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [self.titleTx setText:self.task.title];
        [self.descTx setText:self.task.desc];
         _per = [self showPeriority:self.task];
        [self.periority setSelectedSegmentIndex:[self showPeriority:self.task] ];
        _sta = [self showStatus:self.task];
        [self.status setSelectedSegmentIndex:[self showStatus:self.task] ];
        [self.date setDate:self.task.date animated:YES];

        
    }
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"]; // Set your desired date format here
    return [formatter stringFromDate:date];
}

-(int) showPeriority:(Task*)task{
    if([task.periority isEqualToString:@"High"]){
        return 0;
    }
    else if([task.periority isEqualToString:@"Low"]){
        return 2;
    }
    else{
        return 1;
    }
}

-(int) showStatus:(Task*)task{
    if([task.status isEqualToString:@"todo"]){
        return 0;
    }
    else if([task.status isEqualToString:@"done"]){
        return 2;
    }
    else{
        return 1;
    }
}

-(void) showImage:(Task*)task{
    if([task.periority isEqualToString:@"High"]){
        UIImage *img=[UIImage imageNamed:@"red"];
        _myImage.image=img;
        [self.myImage setHidden:false];

    }
    else if ([task.periority isEqualToString:@"Low"] ){
        UIImage *img=[UIImage imageNamed:@"yellow"];
        _myImage.image=img;
        [self.myImage setHidden:false];
    }
    else{
        UIImage *img=[UIImage imageNamed:@"green"];
        _myImage.image=img;
        [self.myImage setHidden:false];

    }
}

- (IBAction)addBtnAction:(id)sender {
    
    if(self.task==nil){
        NSString *title=_titleTx.text;
        NSString *desc=_descTx.text;
        NSString *per=[self stateStringFromPeriority:_periority.selectedSegmentIndex];
        NSString *status=[self stateStringFromStatus:_status.selectedSegmentIndex];
        NSDate *date=_date.date;
        Task *task=[[Task alloc] init];
        
        task.title=title;
        task.desc =desc;
        task.periority=per;
        task.status=status;
        task.date=date;
        NSError *error;
        if([self checkTask:task]==false){
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Warning" message:@"Must Complete information" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
            NSData *encodedTask = [NSKeyedArchiver archivedDataWithRootObject:task];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                NSArray *existingTasksData = [defaults arrayForKey:@"tasks"];
                NSMutableArray *updatedTasksData = existingTasksData ? [existingTasksData mutableCopy] : [NSMutableArray new];
                [updatedTasksData addObject:encodedTask];
                [defaults setObject:updatedTasksData forKey:@"tasks"];
                [defaults synchronize];
                
                printf("%d the number of tasks =  >>>>",existingTasksData.count);
            
//                ViewController *home=[self.storyboard instantiateViewControllerWithIdentifier:@"home"];
//                [self.navigationController pushViewController:home animated:YES];
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
    }else if(self.task!=nil){
        NSLog(@"i have a task its name = %@", self.task.title);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSArray *existingTasksData = [defaults arrayForKey:@"tasks"];
        
            NSData *taskData = existingTasksData[self.taskIndex];
            Task *task = [NSKeyedUnarchiver unarchiveObjectWithData:taskData];
            
            NSLog(@">>>>>>task title = %@",task.title);
            task.title =_titleTx.text;
            task.desc=_descTx.text;
            task.periority=[self stateStringFromPeriority:_periority.selectedSegmentIndex];
            task.status=[self stateStringFromStatus:_status.selectedSegmentIndex];
            
            NSData *encodedTask = [NSKeyedArchiver archivedDataWithRootObject:task];
            
            NSMutableArray *updatedTasksData = existingTasksData ? [existingTasksData mutableCopy] : [NSMutableArray new];
        
            [updatedTasksData replaceObjectAtIndex:self.taskIndex withObject:encodedTask];
            [defaults setObject:updatedTasksData forKey:@"tasks"];
            [defaults synchronize];

            [self.navigationController popViewControllerAnimated:YES];
        
        
    }
}
    

-(Boolean) checkTask:(Task*)task{
    if([task.title isEqualToString:@""] || [task.desc isEqualToString:@""]){
        return false;

    }else
        return true;
}

-(NSString*) stateStringFromPeriority :(NSInteger*)index{
    if(index == 0){
        return @"High";
        
    }else if(index == 1){
        return @"Medium";
    }else{
        return @"Low";
    }
}

-(NSString*) stateStringFromStatus :(NSInteger*)index{
    if(index == 0){
        return @"todo";
        
    }else if(index == 1){
        return @"progress";
    }else{
        return @"done";
    }
}@end
