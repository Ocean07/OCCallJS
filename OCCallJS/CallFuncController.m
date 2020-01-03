//
//  ViewController.m
//  OCCallJS
//
//  Created by ocean on 2019/9/30.
//  Copyright © 2019 ocean. All rights reserved.
//

#import "CallFuncController.h"
#import <WebKit/WebKit.h>

@interface CallFuncController () <WKScriptMessageHandler, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation CallFuncController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"OC->JS" style:UIBarButtonItemStylePlain target:self action:@selector(ocCallJs:)];
    self.navigationItem.rightBarButtonItem = item;
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    configuration.userContentController = userController;
    
    //以下代码适配大小
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [userController addUserScript:wkUScript];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration:configuration];
    _webView.UIDelegate = self;
    [userController addScriptMessageHandler:self name:@"currentCookies"];
    [self.view addSubview:_webView];
    
    NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"CallFunc.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [_webView loadRequest: request];
}

// oc call js
- (void)ocCallJs:(id)sender {
    NSString *base64Str = @"call";
    NSString *callJSInfo = [NSString stringWithFormat:@"callJS('%@')", base64Str];
    [self.webView evaluateJavaScript:callJSInfo completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"obj = %@, oc call js err = %@", obj, error);
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"show alert -> %@", message);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"oc调用js传递数据" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
    completionHandler();
}


//JS调用的OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"currentCookies"]) {
        NSDictionary *infoDic = message.body;
        NSLog(@"当前的cookie为： %@", infoDic);
        BOOL isStart = [infoDic[@"start"] boolValue];
        NSString *msg = isStart ? @"JS调用oc -> 开始录音" : @"JS调用oc -> 停止录音";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
