//
//  Task.h
//  ToDoApp
//
//  Created by Amira on 17/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCopying, NSSecureCoding>

@property NSString *title;
@property NSString *desc;
@property NSString *periority;
@property NSString *status;
@property NSDate *date;

-(void) encodeWithCoder:(NSCoder *)coder;
@end

NS_ASSUME_NONNULL_END
