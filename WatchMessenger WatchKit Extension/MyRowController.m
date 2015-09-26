//
//  MyRowController.m
//  WatchMessenger
//
//  Created by Justin Lennox on 9/25/15.
//  Copyright © 2015 Justin Lennox. All rights reserved.
//

#import "MyRowController.h"

@implementation MyRowController


- (IBAction)contactUrgencySliderPressed:(float)value {
    
    NSLog(@"Slider value: %f", value);
    if(value == 0){
        [self.contactUrgencySlider setValue:1];
        [self.contactUrgencySlider setColor:[UIColor greenColor]];
    }else if(value == 1){
        [self.contactUrgencySlider setColor:[UIColor greenColor]];
    }else if(value == 2){
        [self.contactUrgencySlider setColor:[UIColor yellowColor]];
    }else if(value == 3){
        [self.contactUrgencySlider setColor:[UIColor redColor]];
    }
}


@end
