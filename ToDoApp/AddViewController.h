//
//  AddViewController.h
//  ToDoApp
//
//  Created by Amira on 17/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddViewController : UIViewController
@property Task *task;
@property (nonatomic, assign) NSInteger taskIndex;
@end

NS_ASSUME_NONNULL_END
