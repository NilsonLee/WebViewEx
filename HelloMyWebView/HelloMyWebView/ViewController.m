//
//  ViewController.m
//  HelloMyWebView
//
//  Created by 李祐昇 on 2016/01/20.
//  Copyright (c) 2016年 Nilson Lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadindIndicatorView;
@property (weak, nonatomic) IBOutlet UIWebView *theWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _urlTextField.text = @"http://s.golfdas.com/buynow/index/";
    
    [self goBtnPressed:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBtnPressed:(id)sender {

    NSURL *url = [NSURL URLWithString:_urlTextField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_theWebView loadRequest:request];
    
}

#pragma mark    -   UITextFieldDelegate Support
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    
    //模擬使用者按下按鈕
    [self goBtnPressed:nil];
    
    //return true 代表可以換行
    return false;
}

#pragma mark    -   UIWebViewDelegate Support
//shouldStartLoadWithRequest 假設使用者要連到我的網頁,我可以對他做一些事情,如權限之類的
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //absoluteString-->原始字串
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"shouldStartLoadWithRequest:%@",urlString);
  
    if ([urlString containsString:@"golfdas.com"] == false) {
        return false;
    }
    
    //過濾掉特定字串
    if ([urlString hasPrefix:@"webtoappaction://"]) {
        NSString *parameter = [urlString stringByReplacingOccurrencesOfString:@"webtoappaction://" withString:@""];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Got WebView Action" message:parameter preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
        //不載入網址改載入其他相關功能
        return false;
    }
    
    
    //讓網址列隨著網址的變動而更新
    if (navigationType == UIWebViewNavigationTypeLinkClicked
        || navigationType == UIWebViewNavigationTypeBackForward) {
        _urlTextField.text = urlString;
    }
    
    return true;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [_loadindIndicatorView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [_loadindIndicatorView stopAnimating];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_loadindIndicatorView stopAnimating];
    NSLog(@"didFailLoadWithError:%@",error.description);
}



@end
