//
//  ViewController.m
//  TestActionSheet
//
//  Created by Dono Air on 2014. 1. 1..
//  Copyright (c) 2014년 Dono Air. All rights reserved.
//

#import "ViewController.h"
#import "DoActionSheet+Demo.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _sgSelect.selectedSegmentIndex = 0;
    _sgType.selectedSegmentIndex = 0;
    _sgStyle.selectedSegmentIndex = 0;
    
    [self onSelect:nil];
    [self onSelectAnimationType:nil];
    [self onSelectStyle:nil];
}

- (IBAction)onShowAlert:(id)sender
{
    DoActionSheet *vActionSheet = [[DoActionSheet alloc] init];
    vActionSheet.nAnimationType = _sgType.selectedSegmentIndex;
    
    if (_sgStyle.selectedSegmentIndex == 0)
        [vActionSheet setStyle1];
    else if (_sgStyle.selectedSegmentIndex == 1)
        [vActionSheet setStyle2];
    else if (_sgStyle.selectedSegmentIndex == 2)
        [vActionSheet setStyle3];

    
    if (_sgSelect.selectedSegmentIndex != 1)
        vActionSheet.dRound = 5;
    
    vActionSheet.dButtonRound = 2;
    
    if (_sgSelectImage.selectedSegmentIndex == 1)
    {
        vActionSheet.iImage = [UIImage imageNamed:@"pic1.jpg"];
        vActionSheet.nContentMode = DoASContentImage;
    }
    else if (_sgSelectImage.selectedSegmentIndex == 2)
    {
        vActionSheet.iImage = [UIImage imageNamed:@"pic2.jpg"];
        vActionSheet.nContentMode = DoASContentImage;
    }
    else if (_sgSelectImage.selectedSegmentIndex == 3)
    {
        vActionSheet.nContentMode = DoASContentMap;
        vActionSheet.dLocation = @{@"latitude" : @(37.78275123), @"longitude" : @(-122.40416442), @"altitude" : @200};
    }

    switch (_sgSelect.selectedSegmentIndex) {
        case 0:
            vActionSheet.nDestructiveIndex = 2;
            
            [vActionSheet showC:@"What do you want for this photo? "
                         cancel:@"Cancel"
                        buttons:@[@"Post to facebook", @"Post to Instagram", @"Delete this photo"]
                         result:^(int nResult) {
                             
                             NSLog(@"---------------> result : %d", nResult);
                             
                         }];
            break;

        case 1:
            [vActionSheet showC:@"What do you want for this photo?"
                         cancel:@"Cancel"
                        buttons:@[@"Post to facebook", @"Post to twitter", @"Post to Instagram", @"Send a mail", @"Save to camera roll"]
                         result:^(int nResult) {
                             
                             NSLog(@"---------------> result : %d", nResult);
                             
                         }];
            break;

        case 2:
            [vActionSheet showC:@"Cancel"
                        buttons:@[@"Open with Safari", @"Copy the link"]
                         result:^(int nResult) {
                             
                             NSLog(@"---------------> result : %d", nResult);
                             
                         }];
            break;

        case 3:
            [vActionSheet show:@"What do you want?"
                        buttons:@[@"Open with Safari", @"Copy the link"]
                        result:^(int nResult) {
                            
                            NSLog(@"---------------> result : %d", nResult);
                            
                        }];
            break;

        case 4:
            [vActionSheet show:@[@"Open with Safari", @"Copy the link"]
                         result:^(int nResult) {
                             
                             NSLog(@"---------------> result : %d", nResult);
                             
                         }];
            break;

        default:
            break;
    }
}

- (IBAction)onSelect:(id)sender
{
    switch (_sgSelect.selectedSegmentIndex) {
        case 0:
            _lbMode.text = @"With title, destructive button, cancel, others";
            break;
        case 1:
            _lbMode.text = @"With title, cancel, others";
            break;
        case 2:
            _lbMode.text = @"Cancel, others";
            break;
        case 3:
            _lbMode.text = @"With title, others";
            break;
        case 4:
            _lbMode.text = @"Only normal buttons";
            break;
            
        default:
            break;
    }
}

- (IBAction)onSelectAnimationType:(id)sender
{
    switch (_sgType.selectedSegmentIndex) {
        case DoASTransitionStyleNormal:
            _lbType.text = @"DoTransitionStyleNormal";
            break;
        case DoASTransitionStyleFade:
            _lbType.text = @"DoTransitionStyleFade";
            break;
        case DoASTransitionStylePop:
            _lbType.text = @"DoTransitionStylePop";
            break;
            
        default:
            break;
    }
}

- (IBAction)onSelectStyle:(id)sender
{
    switch (_sgStyle.selectedSegmentIndex) {
        case 0:
            _lbStyle.text = @"Style 1";
            break;
        case 1:
            _lbStyle.text = @"Style 2";
            break;
        case 2:
            _lbStyle.text = @"Style 3";
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
