//
//  SenTestCase+Fixtures.m
//  ZergSupport
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "SenTestCase+Fixtures.h"

#import <objc/runtime.h>

#import "FormatSupport.h"
#import "ModelSupport.h"

@interface ZNFixtureParser : NSObject <ZNModelXmlParserDelegate> {
  ZNModelXmlParser* xmlParser;
}

-(NSArray*)parseData:(NSData*)data;

+(NSDictionary*)parserSchema;

@end


@implementation ZNFixtureParser
-(id)init {
  if ((self = [super init])) {
    NSDictionary* parserSchema = [ZNFixtureParser parserSchema];
    xmlParser = [[ZNModelXmlParser alloc] initWithSchema:parserSchema 
                                          documentCasing:kZNFormatterSnakeCase];
    xmlParser.delegate = self;
  }
  return self;
}
-(void)dealloc {
  [xmlParser release];
  [super dealloc];
}

-(NSArray*)parseData:(NSData*)data {
  NSMutableArray* fixtures = [[NSMutableArray alloc] init];
  xmlParser.context = fixtures;
  BOOL parseSuccess = [xmlParser parseData:data];
  NSAssert(parseSuccess, @"Failed to parse fixture");
  
  NSArray* returnValue = [NSArray arrayWithArray:fixtures];
  [fixtures release];
  return returnValue;
}


+(NSDictionary*)parserSchema {
  NSArray* modelClasses = [ZNModel allModelClasses];
  ZNFormFieldFormatter* snakeFormatter =
      [ZNFormFieldFormatter formatterFromPropertiesTo:kZNFormatterSnakeCase];
  
  NSMutableDictionary* schema = [[NSMutableDictionary alloc] init];
  for (Class klass in modelClasses) {
    NSString* className = [NSString stringWithCString:class_getName(klass)];
    [schema setObject:klass forKey:className];
    NSString* snakeClassName = [snakeFormatter copyFormattedName:className];
    [schema setObject:klass forKey:snakeClassName];
    [snakeClassName release];
  }
  return schema;
}

-(void)parsedModel:(ZNModel*)model
           context:(id)context {
  [(NSMutableArray*)context addObject:model];
}
-(void)parsedItem:(NSDictionary*)itemData
             name:(NSString*)itemName
          context:(id)context {
  NSAssert(NO, @"-parsedItem called while parsing fixtures");
}

@end


@implementation SenTestCase (Fixtures)

// Loads fixtures (models) from the given file.  
-(NSArray*)fixturesFrom:(NSString*)fileName {
	NSString* fixturePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:fileName];
  NSData* fixtureData = [NSData dataWithContentsOfFile:fixturePath];
  ZNFixtureParser* parser = [[ZNFixtureParser alloc] init];
  NSArray* fixtures = [parser parseData:fixtureData];
  [parser release];
  return fixtures;
}

@end
