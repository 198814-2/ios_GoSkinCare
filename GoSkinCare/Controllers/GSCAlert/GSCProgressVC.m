//
//  GSCProgressVC.m
//  GoSkinCare

#import "GSCProgressVC.h"

@interface GSCProgressVC ()

@property (weak, nonatomic) IBOutlet UIView* bgView;
@property (weak, nonatomic) IBOutlet UIImageView* lipsImageView;
@property (weak, nonatomic) IBOutlet UILabel* statusLabel;

@end

@implementation GSCProgressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initUI {
    self.bgView.layer.cornerRadius = 18.f;
    
//    self.lipsImageView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
//    self.lipsImageView.layer.shadowOffset = CGSizeMake(2.f, 2.f);
//    self.lipsImageView.layer.shadowOpacity = 1.f;
//    self.lipsImageView.layer.shadowRadius = 3.f;
//    self.lipsImageView.layer.masksToBounds = YES;
}

- (void)setStatus:(NSString*)status {
    self.statusLabel.text = status;
}

- (void)startAnimation {
    [self stopAnimation];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    animation.duration = 2.0;

    [self.lipsImageView.layer addAnimation:animation forKey:@"rotation"];

    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / 500.0;
    self.lipsImageView.layer.transform = transform;
    
//    [UIView animateWithDuration:1.f animations:^{
//        //        [self.lipsImageView.layer setAffineTransform:CGAffineTransformMakeScale(-1, 1)];
//        self.lipsImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1.f animations:^{
//            //            [self.lipsImageView.layer setAffineTransform:CGAffineTransformMakeScale(1, 1)];
//            self.lipsImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 0.0f);
//        } completion:^(BOOL finished) {
//            [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.01f];
//        }];
//    }];
    
    
//    CALayer *layer = self.lipsImageView.layer;
//    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
//    rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
//    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI / 0.3, 0.0f, 1.0f, 0.0f);
//    layer.transform = rotationAndPerspectiveTransform;
//    [UIView animateWithDuration:1.0 animations:^{
//        layer.transform = CATransform3DIdentity;
//    }];
}

- (void)stopAnimation {
    
    [self.lipsImageView.layer removeAnimationForKey:@"rotation"];
}


@end
