//
//  ViewController.h
//  To-Do
//
//  Created by Alienated on 21.04.2023.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (nonatomic, strong) NSDate * eventDate;
@property (nonatomic, strong) NSString * eventName;
@property (nonatomic, assign) BOOL isDetail;

@end

