//
//  MJViewController.m
//  WebApp
//
//  Created by Mike Jin on 14-7-3.
//  Copyright (c) 2014年 Mike Jin. All rights reserved.
//

#import "MJViewController.h"


@interface MJViewController ()

@end

@implementation MJViewController

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;
@synthesize phoneNOText;
@synthesize messageShow;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    

    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];


    
}







- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)startDecoder:(id)sender {

    ProtocolConnectionStatus state=  [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
    
    NSString *mess=nil;
    
    
    
    switch (state) {
        case ProtocolConnectionStatusAlreadyConnected:
            mess=@"already connected";
            break;
            case ProtocolConnectionStatusUnableToConnect:
            mess=@"error connecting";
            break;
            case ProtocolConnectionStatusConnected:
            mess=@"connecting";
            break;
            case ProtocolConnectionStatusUnableToConnectIncompatiableSledFirmware:
            mess=@"incompatible firmware";
            break;
            case ProtocolConnectionStatusBatteryDepleted:
            mess=@"battery depleted";
            break;
            
        default:
            break;
    }
    {UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                    message:mess
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [alert show];}
}

- (IBAction)stopDecoder:(id)sender {
    [[Captuvo sharedCaptuvoDevice]stopDecoderHardware];
}


-(void)captuvoDisconnected{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:@"Captuvo Disconnected"
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
}


- (void)decoderReady
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:@"decoder ready"
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
    
    
}
-(void)captuvoConnected{
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:@"Captuvo Connected"
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
}






// 按下开始扫描
- (IBAction)scanningBtn:(id)sender {
    


    [[Captuvo sharedCaptuvoDevice] startDecoderScanning];


    
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:@"scan 被调用"
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];


        

    
}

//松开按钮结束扫描
- (IBAction)scanningBtnLoss:(id)sender {
    
    [[Captuvo sharedCaptuvoDevice] stopDecoderScanning];
    

    
    
}

//扫描获得数据
-(void) decoderDataReceived:(NSString *)data
{
    

    self.phoneNOText.text = data;
    
    
}

- (void)decoderRawDataReceived:(NSData *)data
{

    self.phoneNOText.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
}
// 按下键盘return按钮隐藏键盘
- (IBAction)textFiledReturnEditing:(id)sender
{
    [sender resignFirstResponder];
}

//触摸屏幕其他位置隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNOText resignFirstResponder];
    
}

//按下submit按钮链接服务器查询相关信息

- (IBAction)phoneQuery:(id)sender {
    
    NSString *number = phoneNOText.text;
    
    //设置WebMethod
    NSString *webMethod=@"JobInfo";
    //参数
    NSString *parameter1=@"job";

    
    // 设置我们之后解析XML时用的关键字,用于查找节点
    matchingElement = @"JobInfoResult";
    
    // 创建SOAP消息，内容格式就是网站上提示的请求报文的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version='1.0' encoding='utf-8'?>"
                         "<soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'>"
                         "<soap12:Body>"
                         "<%@ xmlns='http://MobileServiceTest'>"
                         "<%@>%@</%@>"
                         "</%@>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",webMethod,parameter1,number,parameter1,webMethod];
    
    // 将这个XML字符串打印出来
    NSLog(@"%@", soapMsg);
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    NSURL *url = [NSURL URLWithString: @"http://3.41.199.73:8086/mobileservicetest.asmx"];
    // 根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    // 创建连接
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}



// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
    [webData setLength: 0];
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    [webData appendData:data];
}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    conn = nil;
    webData = nil;
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes]
                                                length:[webData length]
                                              encoding:NSUTF8StringEncoding];
    
    // 打印出得到的XML
    NSLog(@"%@", theXML);
    // 使用NSXMLParser解析出我们想要的结果
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}




// 开始解析一个元素名
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
    if ([elementName isEqualToString:matchingElement]) {
        if (!soapResults) {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
}

// 追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string {
    if (elementFound) {
        [soapResults appendString: string];
    }
}

// 结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:matchingElement]) {
        
        messageShow.text=soapResults;

        elementFound = FALSE;
        // 强制放弃解析
        [xmlParser abortParsing];
    }
}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (soapResults) {
        soapResults = nil;
    }
}

// 出错时，例如强制结束解析
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (soapResults) {
        soapResults = nil;
    }
}





@end