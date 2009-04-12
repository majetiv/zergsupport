//
//  DictionaryXmlParserTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/9/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#include "TestSupport.h"

#include "ZNDictionaryXmlParser.h"
#include "ZNFormFieldFormatter.h"

@interface ZNDictionaryXmlParserTest
    : SenTestCase <ZNDictionaryXmlParserDelegate> {
	ZNDictionaryXmlParser* parser;
  
	NSMutableArray* items;
	NSMutableArray* dupItems;
	NSMutableArray* names;
	NSMutableArray* dupNames;
}

@end

static NSString* kContextObject = @"This is the context";

@implementation ZNDictionaryXmlParserTest

-(void)setUp {
  ZNFormFieldFormatter* fromSnake =
      [ZNFormFieldFormatter formatterToPropertiesFrom:kZNFormatterSnakeCase];
	NSDictionary* schema = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNull null], @"itemA",
                          [NSSet setWithObjects:@"keyB", @"keyC", nil],
                          @"itemB",
                          [NSArray arrayWithObjects:
                           fromSnake, [NSNull null], nil], @"itemD",
                          nil];
	
	parser = [[ZNDictionaryXmlParser alloc] initWithSchema:schema];
	parser.context = kContextObject;
	parser.delegate = self;
	
	items = [[NSMutableArray alloc] init];
	dupItems = [[NSMutableArray alloc] init]; 
	names = [[NSMutableArray alloc] init];
	dupNames = [[NSMutableArray alloc] init]; 
	
}

-(void)tearDown {
	[parser release];
	[items release];
	[dupItems release];
	[names release];
	[dupNames release];
}

-(void)dealloc {
	[super dealloc];
}

-(void)checkItems {
	STAssertEqualObjects(names, dupNames, @"Item names changed during parsing");
	STAssertEqualObjects(items, dupItems, @"Item data changed during parsing");
	
	NSArray* goldenNames = [NSArray arrayWithObjects:@"itemA",
                          @"itemB", @"itemA", @"itemD", nil];
	STAssertEqualObjects(goldenNames, names,
                       @"Failed to parse all the right items");
	
	NSDictionary* goldenFirst = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"A prime", @"keyA", @"B prime", @"keyB", nil];
	STAssertEqualObjects(goldenFirst, [items objectAtIndex:0],
                       @"Failed to parse item with open schema");
  
	NSDictionary* goldenSecond = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"B second", @"keyB", nil];
	STAssertEqualObjects(goldenSecond, [items objectAtIndex:1],
                       @"Failed to parse item with closed schema");
  
	NSDictionary* goldenThird = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"B third", @"keyB",
                               @"Entity fun '>", @"keyC", nil];
	STAssertEqualObjects(goldenThird, [items objectAtIndex:2],
                       @"Failed to parse XML entities");

	NSDictionary* goldenFourth = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"value_one", @"keyOne",
                                @"value_two", @"keyTwo", nil];
	STAssertEqualObjects(goldenFourth, [items objectAtIndex:3],
                       @"Failed to format XML elements");
}

-(void)testParsingURLs {
	NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNDictionaryXmlParserTest.xml"];
	BOOL success = [parser parseURL:[NSURL fileURLWithPath:filePath]];	
	STAssertTrue(success, @"Parsing failed on ZNDictionaryXmlParserTest.xml");
	
	[self checkItems];
}

-(void)testParsingData {
	NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNDictionaryXmlParserTest.xml"];
	BOOL success = [parser parseData:[NSData dataWithContentsOfFile:filePath]];
	STAssertTrue(success, @"Parsing failed on ZNDictionaryXmlParserTest.xml");
	
	[self checkItems];
}

-(void)parsedItem:(NSDictionary*)itemData
               name:(NSString*)itemName
            context:(id)context {
	STAssertEquals(kContextObject, context,
                 @"Wrong context passed to -parsedItem");
  
	[names addObject:itemName];
	[dupNames addObject:[NSString stringWithString:itemName]];
	
	[items addObject:itemData];
	[dupItems addObject:[NSDictionary dictionaryWithDictionary:itemData]];	
}

@end
