//
//  ZNFormURLEncoder.h
//  ZergSupport
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@class ZNFormFieldFormatter;

// Convert form data into the application/x-www-form-urlencoded MIME encoding.
@interface ZNFormURLEncoder : NSObject {
  NSMutableData* output;
  ZNFormFieldFormatter* fieldFormatter;
}

+(NSData*)copyEncodingFor:(NSDictionary*)dictionary
        usingFieldFormatter:(ZNFormFieldFormatter*)formatter;

@end
