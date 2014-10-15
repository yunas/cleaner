//
//  ViewController.m
//  Cleaner
//
//  Created by Yunas Qazi on 10/13/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import "ViewController.h"
#import "CleanerDetailController.h"
#import "ClientDetailController.h"
#import "UIFont+Cleaner.h"

@interface ViewController ()
{
    
    __weak IBOutlet UILabel *lblHeader;
}

@end

@implementation ViewController

#pragma mark - Actions

- (IBAction)gateSelected:(UIButton*)button {

    if (IS_IPAD()){
        [self performSegueWithIdentifier:@"showDetail" sender:button];
    }else{
        [self performSegueWithIdentifier:@"showCleanerDetail" sender:button];
    }

}

#pragma mark - Standard Life Cycle

-(void) initContentView{

    UIFont *font = [lblHeader font];
    [lblHeader setFont:[UIFont AppFontWithType:FontType_Bold andSize:[font pointSize]]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSString *gate = @"A";
    
    if (btn.tag == 2){
        gate = @"B";
    }
    else if (btn.tag == 3){
        gate = @"C";
    }
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        ClientDetailController* clientDetailController = [segue destinationViewController];
        [clientDetailController setGate:gate];
        
    }
   else if ([[segue identifier] isEqualToString:@"showCleanerDetail"])
    {
        CleanerDetailController* cleanerDetailController = [segue destinationViewController];
        [cleanerDetailController setGate:gate];
    }
}

@end
