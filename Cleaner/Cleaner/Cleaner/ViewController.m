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
#import "AppSettings.h"


@interface ViewController ()
{
    
    __weak IBOutlet UILabel *lblHeader;
    __weak IBOutlet UIButton *btnA;
    __weak IBOutlet UIButton *btnB;
    __weak IBOutlet UIButton *btnC;
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
    
    float fontSize = 100.0;
    if (IS_IPAD()) {
        fontSize = 150.0;
    }
    
    btnA.titleLabel.font = [UIFont AppFontWithType:FontType_Bold andSize:fontSize];
    btnB.titleLabel.font = [UIFont AppFontWithType:FontType_Bold andSize:fontSize];
    btnC.titleLabel.font = [UIFont AppFontWithType:FontType_Bold andSize:fontSize];


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
        AppSettings *appSettings = [AppSettings loadAppSettings];
        
        [appSettings setIsfirstLaunch:NO];
        [appSettings setUserSelectedGate:[NSString stringWithFormat:@"%@",gate]];
        [appSettings saveTheAppSetting];
        
        CleanerDetailController* cleanerDetailController = [segue destinationViewController];
        [cleanerDetailController setGate:gate];
    }
}

@end
