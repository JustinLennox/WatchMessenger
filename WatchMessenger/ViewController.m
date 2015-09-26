//
//  ViewController.m
//  WatchMessenger
//
//  Created by Justin Lennox on 9/25/15.
//  Copyright © 2015 Justin Lennox. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *venueURL = @"localhost:3000/messages.json";   //Send a GET to the backend at /users/fbUser/fbAcessToken
    //Example, our user's access token is 12XY, sends request to /users/fbUser/fbAcessToken/
    
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL
                                         URLWithString:venueURL]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10
     ];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&urlResponse error:&requestError];
    
    
    NSError *e = nil;
    NSArray *jsonArray;
    
    if(response1){
        jsonArray = [NSJSONSerialization JSONObjectWithData:response1 options: NSJSONReadingMutableContainers error: &e];
        
        if (!jsonArray) {
            //This user hasn't been signed up yet. Creating a new user.
            NSLog(@"No json array");
        } else {
            NSLog(@"json Array: %@", jsonArray);
            
        }
        
        
    }else{
        NSLog(@"We appear to be offline!");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
