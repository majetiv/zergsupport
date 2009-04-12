//
//  ZNFormFieldFormatterTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/27/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNFormFieldFormatter.h"

@interface ZNFormFieldFormatterTest : SenTestCase {
}
@end

@implementation ZNFormFieldFormatterTest

-(void)testKnowsPropertiesAreLCamel {
  ZNFormFieldFormatter* fromLCamel =
     [ZNFormFieldFormatter formatterToPropertiesFrom:kZNFormatterLCamelCase];
  STAssertEquals([ZNFormFieldFormatter identityFormatter],
                 fromLCamel, @"lCamel -> properties should be identity");

  ZNFormFieldFormatter* toLCamel =
  [ZNFormFieldFormatter formatterFromPropertiesTo:kZNFormatterLCamelCase];
  STAssertEquals([ZNFormFieldFormatter identityFormatter],
                 toLCamel, @"properties -> lCamel should be identity");  
  
  ZNFormFieldFormatter* fromSnake = 
      [ZNFormFieldFormatter formatterToPropertiesFrom:kZNFormatterSnakeCase];
  STAssertEqualStrings(@"twoWords",
                       [[fromSnake copyFormattedName:@"two_words"] autorelease],
                       @"snake -> properties should convert to lCamel");
  ZNFormFieldFormatter* toSnake = 
  [ZNFormFieldFormatter formatterFromPropertiesTo:kZNFormatterSnakeCase];
  STAssertEqualStrings(@"two_words",
                       [[toSnake copyFormattedName:@"twoWords"] autorelease],
                       @"properties -> snake should do the conversion");
}

@end
