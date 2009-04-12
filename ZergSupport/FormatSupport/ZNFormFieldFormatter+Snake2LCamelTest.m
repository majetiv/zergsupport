//
//  ZNFormFieldFormatter+Snake2LCamelTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/25/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNFormFieldFormatter+Snake2LCamel.h"

@interface ZNFormFieldFormatter_Snake2LCamelTest : SenTestCase {
  ZNFormFieldFormatter* snake2lCamel;
  ZNFormFieldFormatter* lCamel2snake;
}
@end

@implementation ZNFormFieldFormatter_Snake2LCamelTest

-(void)setUp {
  snake2lCamel = [ZNFormFieldFormatter snakeToLCamelFormatter];
  lCamel2snake = [ZNFormFieldFormatter lCamelToSnakeFormatter];
}

-(void)tearDown {
}

-(void)dealloc {
  [super dealloc];
}

-(void)testGenerics {
  NSString* testBattery[][2] = {
    {@"", @""}, {@"simple", @"simple"}, {@"twoWords", @"two_words"},
    {@"randomUAndV", @"random_u_and_v"}};
  
  for (NSUInteger i = 0; i < sizeof(testBattery) / sizeof(NSString*[2]); i++) {
    NSString* snaked = [lCamel2snake copyFormattedName:testBattery[i][0]];
    STAssertEqualStrings(testBattery[i][1], snaked, @"Camels to snakes");
    [snaked release];
    NSString* cameled = [snake2lCamel copyFormattedName:testBattery[i][1]];
    STAssertEqualStrings(testBattery[i][0], cameled, @"snakes to Camels");
    [cameled release];
  }
}

-(void)testSpecialCamels {
  NSString* testBattery[][2] = {
    {@"SomeHTTP", @"some_http"},
    {@"SomeHTTPRequest", @"some_http_request"}
  };

  for (NSUInteger i = 0; i < sizeof(testBattery) / sizeof(NSString*[2]); i++) {
    NSString* snaked = [lCamel2snake copyFormattedName:testBattery[i][0]];
    STAssertEqualStrings(testBattery[i][1], snaked, @"Camels to snakes");
    [snaked release];
  }
}

-(void)testSpecialSnakes {
  NSString* testBattery[][2] = {
    {@"twoWords", @"two__words"},
    {@"word", @"__word"},
    {@"word", @"word__"},
    {@"threeGoodWordsXY", @"_three___good_words_x_y__"}
  };
  
  for (NSUInteger i = 0; i < sizeof(testBattery) / sizeof(NSString*[2]); i++) {
    NSString* cameled = [snake2lCamel copyFormattedName:testBattery[i][1]];
    STAssertEqualStrings(testBattery[i][0], cameled, @"snakes to Camels");
    [cameled release];
  }  
}

@end
