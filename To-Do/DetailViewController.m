//
//  ViewController.m
//  To-Do
//
//  Created by Alienated on 21.04.2023.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isDetail) {
        self.textField.text = self.eventName;
        self.textField.userInteractionEnabled = NO;
        
//        self.datePicker.date = self.eventDate;
//        [self performSelector:@selector(setDatePickerValueWithAnimation) withObject:nil afterDelay:0.5];
        self.datePicker.userInteractionEnabled = NO;
                
        self.buttonSave.userInteractionEnabled = NO;
        self.buttonSave.alpha = 0;
    }
    else {
        self.datePicker.minimumDate = [NSDate date];
        [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];

        
        self.buttonSave.userInteractionEnabled = NO;
        [self.buttonSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer * handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndEditing)];
        [self.view addGestureRecognizer:handleTap];
    }
}

- (void) setDatePickerValueWithAnimation {
    [self.datePicker setDate:self.eventDate animated:YES];
}

- (void) datePickerValueChanged {
    self.eventDate = self.datePicker.date;
    NSLog(@"Event date: %@", self.eventDate);
}

- (void) handleEndEditing {
    if ([self.textField.text length] != 0) {
        [self.view endEditing:YES]; // hide keyboard
        self.buttonSave.userInteractionEnabled = YES;
    }
    else {
        [self showAlertWithMessage:@"This field has no text!"];
    }
}

- (void) save {
    if (self.eventDate) {
        if ([self.eventDate compare:[NSDate date]] == NSOrderedSame) {
            [self showAlertWithMessage:@"Еhe event is the same as the current date."];
        }
        else if ([self.eventDate compare:[NSDate date]] == NSOrderedAscending) {
            [self showAlertWithMessage:@"Event earlier than current date."];
        }
        else {
            [self setNotification];
        }
    }
    else {
        [self showAlertWithMessage:@"Сhange event to later."];
    }
  
    NSLog(@"Save Button");
}

- (void) setNotification {
    NSString * eventName = self.textField.text;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm dd.MMMM.yyyy";
    NSString * eventDate = [formatter stringFromDate:self.eventDate];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                           eventName, @"EventName",
                           eventDate, @"EventDate", nil];
    
    UILocalNotification * notif = [[UILocalNotification alloc] init];
    notif.userInfo = dict;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.fireDate = self.eventDate;
    notif.alertBody = eventName;
    notif.applicationIconBadgeNumber = 1;
    notif.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication]scheduleLocalNotification:notif];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewEvent" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.textField]) {
        if ([self.textField.text length] != 0) {
            [self.textField resignFirstResponder]; // hide keyboard
            self.buttonSave.userInteractionEnabled = YES;
            return YES;
        }
        else {
            [self showAlertWithMessage:@"This field has no text!"];
        }
    }
    
    return NO;
}

- (void) showAlertWithMessage:(NSString *) message {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

@end
