//
//  ZNFormatterCasing.h
//  ZergSupport
//
//  Created by Victor Costan on 1/25/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

enum ZNFormatterCasing {
  // no particular casing convetion
  kZNFormatterNoCase = 0,
  // snake_case
  kZNFormatterSnakeCase = 1,  
  // camelCase, except the first letter is lower case
  kZNFormatterLCamelCase = 2
};
typedef enum ZNFormatterCasing ZNFormatterCasing;
