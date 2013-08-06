//
//  Livejournal.m
//  SocialClient
//
//  Created by Admin on 19.07.13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "Livejournal.h"
#import "LJDialog.h"


#define XMLRPC_URL @"http://www.livejournal.com/interface/xmlrpc"
#define METHOD_LOGIN @"LJ.XMLRPC.login"
#define METHOD_POSTEVENT @"LJ.XMLRPC.postevent"



#pragma mark - XMLRPCHelper

@implementation XMLRPCHelper

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response
{
}

-(void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"LJ request error %@", error);
}

-(BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

-(void)request:(XMLRPCRequest *)request didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
}

-(void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
}

@end


#pragma mark - LJInfo

@implementation LJInfo
@end


#pragma mark - LJAuth

@implementation LJAuth
{
    NSString* _login;
    NSString* _pass;
    AuthHandler _handler;
}

-(void)auth:(NSString*)login pass:(NSString*)pass complete:(AuthHandler)handler
{
    _login = login;
    _pass = pass;
    _handler = handler;
    
    NSURL *URL = [NSURL URLWithString:XMLRPC_URL];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    
    NSArray* params = @[@{@"username":login, @"password":pass, @"getpickws" : @"1", @"getpickwurls": @"1"}];
    [request setMethod:METHOD_LOGIN withParameters:params];
    
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
}

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response
{
    LJInfo* info = nil;

    if ([response isFault]) {
        NSLog(@"Fault code: %@", [response faultCode]);
        NSLog(@"Fault string: %@", [response faultString]);
    } else {
        NSLog(@"Parsed response: %@", [response object]);
        if (response.object != nil){
            info = [[LJInfo alloc]init];
            info.login = _login;
            info.pass = _pass;
            info.username = response.object[@"username"];
            info.userpic = response.object[@"defaultpicurl"];
        }
    }
    
    //NSLog(@"Response body: %@", [response body]);
    if (_handler) _handler(info);
}

@end



#pragma mark - LJShare

typedef void (^ShareHandler)(BOOL success);

@interface LJShare : XMLRPCHelper

@property (nonatomic, copy) NSString* login;
@property (nonatomic, copy) NSString* pass;

@end

@implementation LJShare
{
    ShareHandler _handler;
}

-(void)shareItem:(ShareItem*)item complete:(ShareHandler)handler
{
    _handler = handler;
    
    NSURL *URL = [NSURL URLWithString:XMLRPC_URL];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    
    NSDate* date = [NSDate date];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:date];
    
    NSArray* params = @[@{@"username":self.login,
                          @"password":self.pass,
                          @"ver" : @"1",
                          @"lineendings": @"pc",
                          @"event": item.text,
                          @"subject": item.title,
                          @"year": @(comp.year),
                          @"mon": @(comp.month),
                          @"day": @(comp.day),
                          @"hour": @(comp.hour),
                          @"min": @(comp.minute)
                          }];
    [request setMethod:METHOD_POSTEVENT withParameters:params];
    
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
}

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response
{
    if ([response isFault]) {
        NSLog(@"Fault code: %@", [response faultCode]);
        NSLog(@"Fault string: %@", [response faultString]);
    } else {
        NSLog(@"Parsed response: %@", [response object]);
        if (response.object != nil){
            NSLog(@"share success");
            if (_handler) _handler(YES);
            return;
        }
    }
    
    //NSLog(@"Response body: %@", [response body]);
    if (_handler) _handler(NO);
}

@end


#pragma mark - Livejournal

@interface Livejournal ()//<LJAuthViewControllerDelegate>

@end

@implementation Livejournal
{
    CompleteHandler _authHandler;
    CompleteHandler _shareHandler;
    BOOL _isAuthorized;
}

+(id)livejournal
{
    static Livejournal* x;
    if (x ==nil) x = [[Livejournal alloc]init];
    return x;    
}

-(void)logout
{
    NSLog(@"acc deleted");
    
    self.login = nil;
    self.pass = nil;
    self.username = nil;
    self.userpic = nil;
    _isAuthorized = NO;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults removeObjectForKey:@"livejournalLogin"];
    [standardUserDefaults removeObjectForKey:@"livejournalPassword"];    
    [standardUserDefaults synchronize];
}

-(BOOL)tryRestoreAccount
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* login = [standardUserDefaults objectForKey:@"livejournalLogin"];
    NSString* pass = [standardUserDefaults objectForKey:@"livejournalPassword"];
    if (login && pass){
        NSLog(@"acc resored");
        _login = login;
        _pass = pass;
        return YES;
    }else{
        NSLog(@"acc not resored");        
    }
    return NO;
}

-(void)onAuthSuccess:(LJInfo*)info
{
    NSLog(@"acc saved");
    
    self.login = info.login;
    self.pass = info.pass;
    self.username = info.username;
    self.userpic = info.userpic;
    _isAuthorized = YES;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:_login forKey:@"livejournalLogin"];
    [standardUserDefaults setObject:_pass forKey:@"livejournalPassword"];
    [standardUserDefaults synchronize];
    
    [self raiseAuthHandler];
}

-(void)autorizeWithHandler:(CompleteHandler)handler
{
    _authHandler = handler;
    
    if ([self tryRestoreAccount]){
        [[[LJAuth alloc]init] auth:_login pass:_pass complete:^(LJInfo *info) {
            if (info){
                [self onAuthSuccess:info];
                
            }else{
                [self showForm];
            }
        }];
    }else{
        [self showForm];
    }
}

-(void)showForm
{
    LJDialog* dlg = [[LJDialog alloc]init];
    [dlg show];
}

-(void)raiseAuthHandler
{
    if (_authHandler) _authHandler(_isAuthorized);
}

-(void)shareItem:(ShareItem*)item complete:(CompleteHandler)handler
{
    LJShare* ls = [[LJShare alloc]init];
    ls.login = self.login;
    ls.pass = self.pass;
    [ls shareItem:item complete:^(BOOL success) {
        if (handler) handler(success);
    }];
}

@end
