//
//  ZNModelXmlParserTest.m
//  ZergSupport
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ModelSupport.h"
#import "ZNModelXmlParser.h"

// Model for the response returned by the testbed.
@interface ZNXmlParserTestModel : ZNModel {
	NSString* theName;
	double number;
	BOOL boolean;
}

@property (nonatomic, retain) NSString* theName;
@property (nonatomic) double number;
@property (nonatomic) BOOL boolean;

@end

@implementation ZNXmlParserTestModel

@synthesize theName, number, boolean;
-(void)dealloc {
	[theName release];
	[super dealloc];
}

@end

@interface ZNModelXmlParserTest
: SenTestCase <ZNModelXmlParserDelegate> {
	ZNModelXmlParser* parser;
  
	NSMutableArray* items;
	NSMutableArray* dupItems;
	NSMutableArray* names;
	NSMutableArray* dupNames;
}

@end

static NSString* kContextObject = @"This is the context";

@implementation ZNModelXmlParserTest

-(void)setUp {
	NSDictionary* schema = [NSDictionary dictionaryWithObjectsAndKeys:
                          [ZNXmlParserTestModel class],
                          @"ZNXmlParserTestModel",
                          [NSNull class], @"itemA",
                          nil];
	
	parser = [[ZNModelXmlParser alloc] initWithSchema:schema
                                     documentCasing:kZNFormatterSnakeCase];
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
	
	NSArray* goldenNames = [NSArray arrayWithObjects:@"itemA", nil];
	STAssertEqualObjects(goldenNames, names,
                       @"Failed to parse the right items");
	
  ZNXmlParserTestModel* firstModel = [items objectAtIndex:0];
  STAssertTrue([firstModel isKindOfClass:[ZNXmlParserTestModel class]],
               @"Wrong model class instantiated for first item");
  STAssertEqualStrings(@"First name", firstModel.theName,
                       @"Wrong value for first model's string property");
  STAssertEqualsWithAccuracy(3.141592, firstModel.number, 0.0000001,
                             @"Wrong value for first model's float property");
  STAssertEquals(YES, firstModel.boolean,
                 @"Wrong value for first model's boolean property");  
  
	NSDictionary* goldenSecond = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"A prime", @"keyA", @"B prime", @"keyB", nil];
	STAssertEqualObjects(goldenSecond, [items objectAtIndex:1],
                       @"Failed to parse item with no model");
  
  ZNXmlParserTestModel* secondModel = [items objectAtIndex:2];
  STAssertTrue([secondModel isKindOfClass:[ZNXmlParserTestModel class]],
               @"Wrong model class instantiated for third item");
  STAssertEqualStrings(@"Second name", secondModel.theName,
                       @"Wrong value for second model's string property");
  STAssertEqualsWithAccuracy(64.0, secondModel.number, 0.0000001,
                             @"Wrong value for second model's float property");
  STAssertEquals(NO, secondModel.boolean,
                 @"Wrong value for second model's boolean property");  
}

-(void)testParsingURLs {
	NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNModelXmlParserTest.xml"];
	BOOL success = [parser parseURL:[NSURL fileURLWithPath:filePath]];	
	STAssertTrue(success, @"Parsing failed on ZNModelXmlParserTest.xml");
	
	[self checkItems];
}

-(void)testParsingData {
	NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNModelXmlParserTest.xml"];
	BOOL success = [parser parseData:[NSData dataWithContentsOfFile:filePath]];
	STAssertTrue(success, @"Parsing failed on ZNModelXmlParserTest.xml");
	
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

-(void)parsedModel:(ZNModel*)model
           context:(id)context {
	STAssertEquals(kContextObject, context,
                 @"Wrong context passed to -parsedModel");
  
	[items addObject:model];
	[dupItems addObject:model];
}

@end

