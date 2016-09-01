//
//  ViewController.m
//  MySocket
//
//  Created by dennis.zhao on 16/8/24.
//  Copyright © 2016年 dennis.zhao. All rights reserved.
//

#import "ViewController.h"
#import <CoreFoundation/CFSocket.h>

@interface ViewController ()

@property (nonatomic,assign) CFSocketRef socketRef;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)customInit{
    
//    CFSocketContext();
    CFSocketContext sockContext = {0,(__bridge void *)(self),NULL,NULL,NULL};
    
    _socketRef = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, ServerConnectCallBack, &sockContext);
    
    struct sockaddr_in addr;
    
    memset(&addr, 0, sizeof(addr));
    
    addr.sin_len = sizeof(addr);
    
    addr.sin_family = AF_INET;
    
    addr.sin_port = htons(19992);
//    addr.sin_addr.s_addr = inet_addr(192.168.1.333);
    addr.sin_addr.s_addr = inet_addr("192.168.1.333");
    
    CFDataRef dataRef = CFDataCreate(kCFAllocatorDefault, (UInt8*)&addr, sizeof(addr));
    
    CFSocketConnectToAddress(_socketRef, dataRef, -1);
    
    CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
    
    CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socketRef, 0);
    
    CFRunLoopAddSource(runLoopRef, sourceRef, kCFRunLoopCommonModes);
    
    CFRelease(sourceRef);
    
}

void ServerConnectCallBack ( CFSocketRef s, CFSocketCallBackType callbackType, CFDataRef address, const void *data, void *info )
{
    ViewController *vc = (__bridge ViewController*)(info);
    if (data!=NULL) {
        
        printf("链接失败");
        
        //TODO: release socket
        
        [vc performSelector:@selector(releaseSocket) withObject:nil];
        
        
    }else{
        
        [vc performSelectorInBackground:@selector(readSteamData) withObject:nil];
        
    }
}

-(void)releaseSocket{
    
    
}

-(void)readSteamData{
    
    char buffer[512];
    
    long readData;
    
    while ((readData = recv(CFSocketGetNative(_socketRef), buffer, sizeof(buffer), 0))) {
        
        NSString *content = [[NSString alloc]initWithBytes:buffer length:readData encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //TODO: update info
            
            NSLog(@"%@",content);
        });
    }
    
    perror("recv");
}


-(void)sendData:(NSString*)str{
    
    const char * data = [str UTF8String];
    
    int sendData = send(CFSocketGetNative(_socketRef), data , strlen(data)+1, 0);
    
    if (sendData<0) {
        perror("send");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
