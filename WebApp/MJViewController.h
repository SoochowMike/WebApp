//
//  MJViewController.h
//  WebApp
//
//  Created by Mike Jin on 14-7-3.
//  Copyright (c) 2014年 Mike Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captuvo.h"

@interface MJViewController : UIViewController<NSXMLParserDelegate,  NSURLConnectionDelegate ,CaptuvoEventsProtocol>




@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNOText;
@property (weak, nonatomic) IBOutlet UILabel *messageShow;






- (IBAction)phoneQuery:(id)sender;
- (IBAction)scanningBtn:(id)sender;
- (IBAction)scanningBtnLoss:(id)sender;
- (IBAction)textFiledReturnEditing:(id)sender;


@end
