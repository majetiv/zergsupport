//
//  ZNFormFieldFormatter.h
//  ZergSupport
//
//  Created by Victor Costan on 1/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "ZNFormatterCasing.h"

// Re-formats form fields to make up for impedance mismatches between the Cocoa
// name casing convention (CamelCase) and the Web service naming convention
// (which is usually snake_case).
@interface ZNFormFieldFormatter : NSObject {
}

// Produces the formatted version of a form field.
-(NSString*)copyFormattedName:(NSString*)name;

// A formatter that transforms property names to the given casing.
+(ZNFormFieldFormatter*)formatterFromPropertiesTo:(ZNFormatterCasing)casing;

// A formatter that transforms names in the given casing to property names.
+(ZNFormFieldFormatter*)formatterToPropertiesFrom:(ZNFormatterCasing)casing;

@end

@interface ZNFormFieldFormatter (Identity)

// A formatter that simply copies its input.
+(ZNFormFieldFormatter*)identityFormatter;

@end
