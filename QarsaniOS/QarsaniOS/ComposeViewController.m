//
//  ComposeViewController.m
//  QarsaniOS
//
//  Created by Michael Weingert on 2015-04-12.
//  Copyright (c) 2015 PBC. All rights reserved.
//

#import "ComposeViewController.h"
#import "FirebaseManager.h"

@interface ComposeViewController ()
{
  NSArray * _pickerData;
}
@property (weak, nonatomic) IBOutlet UIPickerView *themePicker;
@property (weak, nonatomic) IBOutlet UITextField *headlineTextFIeld;
@property (weak, nonatomic) IBOutlet UITextView *storyTextView;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  _themePicker.dataSource = self;
  _themePicker.delegate = self;
  
  _storyTextView.delegate = self;
  
  _pickerData = @[@"Women", @"World", @"Middle East"];
  
  UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(hideKeyBoard)];
  
  [self.view addGestureRecognizer:tapGesture];
}

-(void)hideKeyBoard {
  [_storyTextView resignFirstResponder];
  [_headlineTextFIeld resignFirstResponder];
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
  NSLog(@"Done Clicked");
  int row = [_themePicker selectedRowInComponent:0];
  NSString * category = [_pickerData objectAtIndex:row];
  //First save to firebase
  [[FirebaseManager sharedManager] saveArticle:category  headline:_headlineTextFIeld.text article:_storyTextView.text];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:@"Type Article Here"])
  {
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
  }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:@""])
  {
    textView.textColor = [UIColor lightGrayColor];
    textView.text = @"Type Article Here";
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return _pickerData[row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)donePressed:(UIBarButtonItem *)sender {
}
@end
