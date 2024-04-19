//
//  Task.m
//  ToDoApp
//
//  Created by Amira on 17/04/2024.
//

#import "Task.h"

@implementation Task

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_desc forKey:@"desc"];
    [coder encodeObject:_periority forKey:@"periority"];
    [coder encodeObject:_status forKey:@"status"];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        
        _title=[coder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _desc=[coder decodeObjectOfClass:[NSString class] forKey:@"desc"];
        _periority=[coder decodeObjectOfClass:[NSString class] forKey:@"periority"];
        _status=[coder decodeObjectOfClass:[NSString class] forKey:@"status"];
        _date=[coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding{
    return YES;
}
@end
