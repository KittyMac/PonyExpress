//
//  URLDownload.m
//  PonyExpress
//
//  Created by Rocco Bowling on 4/23/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "app.h"

void Apple_URLDownload(String * uuid, String * url, URLDownload * sender) {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:String_val_cstring_o(url)]]];
    
    [[NSURLSession alloc] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != NULL) {
            URLDownload_tag_response_ooZo__send(sender, uuid, (char *)[data bytes], [data length]);
        }else{
            URLDownload_tag_response_ooZo__send(sender, uuid, (char *)NULL, 0);
        }
    }];
}
