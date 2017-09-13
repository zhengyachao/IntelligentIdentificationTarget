//
//  ViewController.m
//  IntelligentIdentificationTarget
//
//  Created by ifreeplay on 2017/8/28.
//  Copyright © 2017年 ifreeplay. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "FaceRecognitionViewController.h"   // 人脸识别

@interface ViewController ()

@property (nonatomic, strong) UIButton *fingerprintBtn;

@property (nonatomic, strong) UIButton *faceBtn;

@property (nonatomic, strong) UIButton *voiceBtn;

@property (nonatomic, strong) LAContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"智能识别";
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createFingerprintButton];
    [self createFaceButton];
    [self createVoiceButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createFingerprintButton {
    
    self.fingerprintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fingerprintBtn.frame = CGRectMake(20, 84, self.view.frame.size.width - 40, 44);
    self.fingerprintBtn.backgroundColor = [UIColor lightGrayColor];
    [self.fingerprintBtn setTitle:@"指纹识别" forState:UIControlStateNormal];
    [self.fingerprintBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.fingerprintBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.fingerprintBtn addTarget:self action:@selector(_showFingerprintRecognition:) forControlEvents:UIControlEventTouchUpInside];
    self.fingerprintBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:self.fingerprintBtn];
}

- (void)createFaceButton {
    
    self.faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceBtn.frame = CGRectMake(20, 84 + 44 * 2, self.view.frame.size.width - 40, 44);
    self.faceBtn.backgroundColor = [UIColor lightGrayColor];
    [self.faceBtn setTitle:@"人脸识别" forState:UIControlStateNormal];
    [self.faceBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.faceBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.faceBtn addTarget:self action:@selector(_showFaceRecognition:) forControlEvents:UIControlEventTouchUpInside];
    self.faceBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:self.faceBtn];
}

- (void)createVoiceButton {
    
    self.voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceBtn.frame = CGRectMake(20, 84 + 44 * 4, self.view.frame.size.width - 40, 44);
    self.voiceBtn.backgroundColor = [UIColor lightGrayColor];
    [self.voiceBtn setTitle:@"声音识别" forState:UIControlStateNormal];
    [self.voiceBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.voiceBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.voiceBtn addTarget:self action:@selector(_showVoiceRecognition:) forControlEvents:UIControlEventTouchUpInside];
    self.voiceBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:self.voiceBtn];
}

#pragma mark -- 按钮事件

- (void)_showFingerprintRecognition:(UIButton *)button {
    
    if ([UIDevice currentDevice].systemVersion.floatValue > 8.0) {
        _context = [[LAContext alloc] init];
        NSError *error;
        
        if ([_context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            
            if (error == nil) {
                [_context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹识别" reply:^(BOOL success, NSError * _Nullable error) {
                    
                    if (success)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self _showAlertViewControllerTitle:@"确定" message:@"指纹识别成功" style:UIAlertActionStyleDefault];
                        });
                        
                    } else
                    {
                        if (error.code == LAErrorUserCancel) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self _showAlertViewControllerTitle:@"确定" message:@"用户取消指纹识别" style:UIAlertActionStyleDefault];
                            });
                        } else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self _showAlertViewControllerTitle:@"确定" message:@"指纹识别失败" style:UIAlertActionStyleDefault];
                            });
                        }
                    }
                }];
            }
        }
    } else
    {
        [self _showAlertViewControllerTitle:@"确定" message:@"您的设备版本不支持指纹识别功能" style:UIAlertActionStyleDefault];    }
    
}

- (void)_showFaceRecognition:(UIButton *)button {
    
    FaceRecognitionViewController *faceVC = [[FaceRecognitionViewController alloc] init];
    [self.navigationController pushViewController:faceVC animated:YES];
}

- (void)_showVoiceRecognition:(UIButton *)button {
    
}

- (void)_showAlertViewControllerTitle:(NSString *)title message:(NSString *)message style:(UIAlertActionStyle)style
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
