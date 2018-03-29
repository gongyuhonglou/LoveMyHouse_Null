//
//  WRPAdviseViewController.m
//  LoveMyHouse
//
//  Created by WRP. on 16/6/6.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import "WRPAdviseViewController.h"

@interface WRPAdviseViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation WRPAdviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    self.messageTextField.delegate = self;
}
- (IBAction)sendMessage:(id)sender {
    
    if (self.messageTextField.text.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的意见已反馈，我们会认真考虑！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入您想提交的意见，没有提交不了哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark -- UITextFieldDelegate代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelegate:self];
    
    CGPoint center;
    center.x = self.titleLabel.center.x;
    center.y = self.titleLabel.center.y - 50;
    self.titleLabel.center = center;
    
    center.x = self.messageTextField.center.x;
    center.y = self.messageTextField.center.y -50;
    self.messageTextField.center = center;
    
    center.x = self.sendButton.center.x;
    center.y = self.sendButton.center.y - 50;
    self.sendButton.center = center;
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    CGPoint center;
    center.x = self.titleLabel.center.x;
    center.y = self.titleLabel.center.y + 50;
    self.titleLabel.center = center;
    
    center.x = self.messageTextField.center.x;
    center.y = self.messageTextField.center.y + 50;
    self.messageTextField.center = center;
    
    center.x = self.sendButton.center.x;
    center.y = self.sendButton.center.y + 50;
    self.sendButton.center = center;
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.messageTextField resignFirstResponder];
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

@end
