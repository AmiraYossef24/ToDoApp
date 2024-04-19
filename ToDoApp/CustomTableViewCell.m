//
//  CustomTableViewCell.m
//  ToDoApp
//
//  Created by Amira on 17/04/2024.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialize and add subviews
        self.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)]; 
        [self.contentView addSubview:self.customImageView];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, self.contentView.frame.size.width - 70, 20)]; // Adjust frame as needed
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
