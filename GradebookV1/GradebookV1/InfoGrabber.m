//
//  InfoGrabber.m
//  GradebookV1
//
//  Created by lokistudios on 5/25/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import "InfoGrabber.h"
#import "JSONKit.h"
#import "NSString+Base64Encoding.h"


@implementation InfoGrabber
@synthesize authHead = _authHead;

- (NSString*) authenticationHeader: (NSString*)username
                          password:(NSString*)password
{
    NSString *loginString = [NSString
                             stringWithFormat:@"%@:%@", username, password];
    return [NSString stringWithFormat:@"Basic %@",
            [loginString base64Encode]];
}

- (id)initWithAuthenticationHeader: (NSString*)aHead{
    self.authHead = aHead;
    return self;
}
- (NSDictionary*) getDictFromURL: (NSString*) url {
    NSURL* URL = [NSURL URLWithString:url];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 10];
    [req addValue:self.authHead forHTTPHeaderField:@"Authorization"];
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&error];
    
    NSDictionary *result = [[NSDictionary alloc] init];
    if (error == nil) {
    
    JSONDecoder * decoder = [JSONDecoder decoder];
     result = [decoder objectWithData: data];
        return result;
    }
    else {
        return nil;
    }

}

@end
