//
//  MenuCell.m
//  GoSkinCare
//


#import "MenuCell.h"


@implementation MenuCell

- (void)awakeFromNib {
    // Initialization code
    
    switch (self.tag) {
        case MenuItem_FastOrder:
            self.imageName = @"FastOrder";
            break;
        case MenuItem_MagicOrder:
            self.imageName = @"Magic";
            break;
        case MenuItem_Profile:
            self.imageName = @"Profile";
            break;
        case MenuItem_History:
            self.imageName = @"History";
            break;
        case MenuItem_Terms:
            self.imageName = @"Terms";
            break;
        case MenuItem_Help:
            self.imageName = @"Help";
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    if (selected) {
        if (self.imageName)
            self.menuImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Sel", self.imageName]];
        self.menuNameLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
    }
    else {
        if (self.imageName)
            self.menuImageView.image = [UIImage imageNamed:self.imageName];
        self.menuNameLabel.textColor = self.tag == MenuItem_Logout ? [UIColor lightGrayColor] : [UIColor blackColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        if (self.imageName)
            self.menuImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Sel", self.imageName]];
        self.menuNameLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
    }
    else {
        if (self.imageName)
            self.menuImageView.image = [UIImage imageNamed:self.imageName];
        self.menuNameLabel.textColor = self.tag == MenuItem_Logout ? [UIColor lightGrayColor] : [UIColor blackColor];
    }
}

- (void)setImageName:(NSString*)imageName {
    _imageName = imageName;
}

@end
