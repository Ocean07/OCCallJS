//
//  ViewController.m
//  OCCallJS
//
//  Created by Bloveocean on 2019/9/29.
//  Copyright © 2019 Auth. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn1 = [[UIButton alloc] init];
    btn1.frame = CGRectMake(100, 100, 100, 35);
    [btn1 setTitle:@"UIWebView" forState:UIControlStateNormal];
    btn1.backgroundColor = UIColor.lightGrayColor;
    btn1.tag = 1000;
    [btn1 addTarget:self action:@selector(showWebView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] init];
    btn2.frame = CGRectMake(100, 160, 100, 35);
    [btn2 setTitle:@"WKWebView" forState:UIControlStateNormal];
    btn2.backgroundColor = UIColor.lightGrayColor;
    btn2.tag = 1000;
    [btn2 addTarget:self action:@selector(showWebView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] init];
    btn3.frame = CGRectMake(100, 220, 100, 35);
    [btn3 setTitle:@"JSCore" forState:UIControlStateNormal];
    btn3.backgroundColor = UIColor.lightGrayColor;
    btn3.tag = 1000;
    [btn3 addTarget:self action:@selector(showWebView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
}

- (void)showWebView:(UIButton *)btn {
    
}

/**
   uiwebView
 
 stringByEvaluatingJavaScriptFromString
 
 */

/**
 wkwebview:
 
 evaluateJavaScript
 */


/**
 JSCore: uiwebview
 
 --> didFinishLoad
 //JSContext就为其提供着运行环境 H5上下文
 JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
 self.jsContext = jsContext;
 [jsContext evaluateScript:@"var arr = ['1','2','3','4']"];
 
 self.jsContext[@"showMessage"] = ^{
 NSLog(@"来了");
 // 参数 (JS 带过来的)
 NSArray *args = [JSContext currentArguments];
 NSLog(@"args = %@",args);
 NSLog(@"currentThis   = %@",[JSContext currentThis]);
 NSLog(@"currentCallee = %@",[JSContext currentCallee]);
 
 // OC-JS
 NSDictionary *dict = @{@"name":@"1",@"age":@10};
 [[JSContext currentContext][@"ocCalljs"] callWithArguments:@[dict,@"oneStr"]];
 
 };
 
 //JS-OC
 self.jsContext[@"showDict"] = ^{
 NSLog(@"来了");
 // 参数 (JS 带过来的)
 NSArray *args = [JSContext currentArguments];
 NSLog(@"args = %@",args);
 };
 
 
 // oc call js
 NSData *imgData = UIImageJPEGRepresentation(resultImage, 0.01);
 NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
 NSString *imageString = [self removeSpaceAndNewline:encodedImageStr];
 NSString *jsFunctStr = [NSString stringWithFormat:@"showImage('%@')",imageString];
 [self.jsContext evaluateScript:jsFunctStr];
 
 --> js func
 function showImage(imageDataStr){
 var tz_img = document.getElementById("tz_image");
 tz_img.innerHTML = "<image style='width:200px;' src='data:image/png;base64,"+imageDataStr+"'>";
 }
 
 */


/**
  webviewjavascriptbridge
 
 self.wjb = [WebViewJavascriptBridge bridgeForWebView:self.webView];
 // 如果你要在VC中实现 UIWebView的代理方法 就实现下面的代码(否则省略)
 [self.wjb setWebViewDelegate:self];
 
 [self.wjb registerHandler:@"jsCallsOC" handler:^(id data, WVJBResponseCallback responseCallback) {
 
 NSLog(@"data == %@ -- %@",data,responseCallback);
 }];
 
 
 [self.wjb callHandler:@"OCCallJSFunction" data:@"occalljs" responseCallback:^(id responseData) {
 
 NSLog(@"responseData == %@",responseData);
 }];
 
 */


@end
