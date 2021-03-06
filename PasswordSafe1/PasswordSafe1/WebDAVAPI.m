//
//  WebDAVAPI.m
//  PasswordSafe
//
//  Created by CSSE Department on 1/24/13.
//  Copyright (c) 2013 Software Security Consultants Incorporated. All rights reserved.
//

#import "WebDAVAPI.h"
#import "AppDelegate.h"

@implementation WebDAVAPI

-(void) download
{    
    receivedData = [[NSMutableData alloc] initWithLength:0];
    
    NSString *filepath = [[AppDelegate sharedAppDelegate] getDownloadedFilepath];
    
    fileStream = [NSOutputStream outputStreamToFileAtPath:filepath append:NO];
    assert(fileStream != nil);
    
    [fileStream open];
    
    //Create the request
    NSURL *url = [[AppDelegate sharedAppDelegate] getServerURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    if (connection){
        NSLog(@"Connecting");
    }
    else {
        //connection failed
        NSLog(@"Connection failed");
    }
}

-(void) upload
{
    NSString *filepath = [[AppDelegate sharedAppDelegate] getFilepath];
    
    NSURL *url = [[AppDelegate sharedAppDelegate] getServerURL];
    
    NSData* fileData = [[NSData alloc] initWithContentsOfFile:filepath];
    
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:fileData];
    NSUInteger fileSize = [[[[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:nil] objectForKey:NSFileSize] unsignedIntegerValue];
    [request setValue:[NSString stringWithFormat:@"%u", fileSize] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    if (connection){
        NSLog(@"Connecting");
    }
    else {
        //connection failed
        NSLog(@"Connection failed");
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Received response");
    
    [receivedData setLength:0];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    if ((httpResponse.statusCode / 100) != 2) {
        NSLog(@"HTTP error %zd", (ssize_t) httpResponse.statusCode);
    } else {
        NSString *fileType;
        
        fileType = [[httpResponse MIMEType] lowercaseString];
        if (fileType == nil) {
            NSLog(@"No content type");
        } else if (![fileType isEqual:@"application/xml"]) {
            NSLog(@"Unsupported Content type: %@", fileType);
        } else {
            NSLog(@"Response OK");
        }
    }
}

-(void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Received Authentication Challenge");
    
    if([challenge previousFailureCount] == 0){
        NSURLCredential *credential = [NSURLCredential credentialWithUser:[[AppDelegate sharedAppDelegate] getUsername]
                                                                 password:[[AppDelegate sharedAppDelegate] getPassword]
                                                              persistence:NSURLCredentialPersistenceNone];
        
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    }else{
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // Display error message: incorrect credentials
        invalidCredentials = TRUE;
        NSLog(@"Authentication failed");
    }
}

-(void)connection: (NSURLConnection *)conn didReceiveData:(NSData *)data
{
    if(![[[conn originalRequest] HTTPMethod] isEqualToString:@"PUT"]) {
        [receivedData appendData:data];
        NSInteger       dataLength;
        const uint8_t * dataBytes;
        NSInteger       bytesWritten;
        NSInteger       bytesWrittenSoFar;
        
        //assert(conn == connection);
        
        dataLength = [data length];
        dataBytes  = [data bytes];
        
        bytesWrittenSoFar = 0;
        do {
            bytesWritten = [fileStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
            assert(bytesWritten != 0);
            if (bytesWritten == -1) {
                NSLog(@"File write error");
                break;
            } else {
                bytesWrittenSoFar += bytesWritten;
            }
        } while (bytesWrittenSoFar != dataLength);
        [[AppDelegate sharedAppDelegate] downloadDone];
        //NSString* content = [NSString stringWithContentsOfFile:[[AppDelegate sharedAppDelegate] getFilepath]
          //                                            encoding:NSUTF8StringEncoding
            //                                             error:NULL];
        //NSLog(@"Get data: %@", content);
    } else {
        // TODO  Figure out what to do here if it is a post
    }
    
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    NSLog(@"connectionDidFinishLoading");
}

- (BOOL) validCredentials
{
    invalidCredentials = FALSE;
    NSURL *url = [[AppDelegate sharedAppDelegate] getServerURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    sleep(1);
    return !invalidCredentials;
}

@end