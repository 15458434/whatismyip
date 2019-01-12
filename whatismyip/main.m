//
//  main.m
//  whatismyip
//
//  Created by Mark Cornelisse on 12/01/2019.
//  Copyright © 2019 Mark Cornelisse. All rights reserved.
//

@import Foundation;

NSString *version = @"1.0";

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray<NSString *> *myArguments = [NSMutableArray arrayWithCapacity:argc];
        for (int i = 0; i < argc; i++) {
            NSString *currentArgument = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
            [myArguments addObject:currentArgument];
        }
        
        // Show app version when -v is present
        NSPredicate *versionPredicate = [NSPredicate predicateWithFormat:@"self = %@", @"-v"];
        NSArray *presentVersionArguments = [myArguments filteredArrayUsingPredicate:versionPredicate];
        if (presentVersionArguments.count > 0) {
            printf("What is my IP version %s\n", version.UTF8String);
        }
        
        NSURL *url = [NSURL URLWithString:@"https://api.ipify.org/"];
        NSString *ipAddress = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        if (ipAddress) {
            // Show only IP address when -i is present else show human readable.
            NSPredicate *onlyIPAddressPredicate = [NSPredicate predicateWithFormat:@"self = %@", @"-i"];
            NSArray *presentOnlyIPAddressArguments = [myArguments filteredArrayUsingPredicate:onlyIPAddressPredicate];
            NSString *result;
            if (presentOnlyIPAddressArguments.count > 0) {
                result = [NSString stringWithFormat:@"%@", ipAddress];
            } else {
                result = [NSString stringWithFormat:@"Your public IP: %@", ipAddress];
            }
            printf("%s\n", result.UTF8String);
            return 0;
        } else {
            printf("Unable to locate public IP\n");
            return 1;
        }
    }
}
