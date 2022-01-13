//
//  ViewController.m
//  Test1
//
//  Created by zhenhui yang on 2022/1/12.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) UIActivityViewController *activityViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{

   
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self sourceShare];
}

- (void)sourceShare{
    
    NSString *textToShare1 = @"ccc";
//    UIImage *imageToShare  = [UIImage imageNamed:@"icon_login_logo"];
//    NSURL *urlToShare      = [NSURL URLWithString:@""];
    NSArray *activityItems = @[textToShare1];
    // 初始化方法
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:@[]];

//    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItemsConfiguration:activityItems];
    
    //去除一些不需要的图标选项
//    activityVC.excludedActivityTypes = [self excludetypes];

    //成功失败的回调block
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {

        if (completed){
            NSLog(@"completed");
        }else{
            NSLog(@"canceled");
        }
    };
    activityVC.completionWithItemsHandler = myBlock;
    activityVC.modalPresentationStyle = UIModalPresentationPopover;

    [self presentViewController:activityVC animated:YES completion:nil];

}

-(NSArray *)excludetypes{

    NSMutableArray *excludeTypeM = [NSMutableArray arrayWithArray:@[//UIActivityTypePostToFacebook,

    UIActivityTypePostToTwitter,

    UIActivityTypePostToWeibo,

    UIActivityTypeMessage,

    UIActivityTypeMail,

    UIActivityTypePrint,

    UIActivityTypeAssignToContact,

    UIActivityTypeSaveToCameraRoll,

    UIActivityTypeAddToReadingList,

    UIActivityTypePostToFlickr,

    UIActivityTypePostToVimeo,

    UIActivityTypePostToTencentWeibo,

    UIActivityTypeAirDrop,

    UIActivityTypeOpenInIBooks]];

    if (@available(iOS 11.0, *)) {

        [excludeTypeM addObject:UIActivityTypeMarkupAsPDF];

    } else {

        // Fallback on earlier versions

    }

    return excludeTypeM;

}

@end
