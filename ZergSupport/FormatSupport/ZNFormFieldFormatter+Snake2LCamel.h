//
//  ZNFormFieldFormatter+Snake2LCamel.h
//  ZergSupport
//
//  Created by Victor Costan on 1/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNFormFieldFormatter.h"


@interface ZNFormFieldFormatter (Snake2LCamel)

+(ZNFormFieldFormatter*)snakeToLCamelFormatter;

+(ZNFormFieldFormatter*)lCamelToSnakeFormatter;

@end
