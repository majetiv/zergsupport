//
//  ZNArrayCsvParserTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNArrayCsvParser.h"

@interface ZNArrayCsvParserTest : SenTestCase <ZNArrayCsvParserDelegate> {
	ZNArrayCsvParser* parser;
	
	NSMutableArray* lines;
	NSMutableArray* dupLines;
}

@end

static NSString* kContextObject = @"This is the context";

@implementation ZNArrayCsvParserTest

-(void)setUp {
	parser = [[ZNArrayCsvParser alloc] init];
	parser.context = kContextObject;
	parser.delegate = self;
	
	lines = [[NSMutableArray alloc] init];
	dupLines = [[NSMutableArray alloc] init]; 
	
}

-(void)tearDown {
	[parser release];
	[lines release];
	[dupLines release];
}

-(void)dealloc {
	[super dealloc];
}

-(void)checkLines {
	STAssertEqualObjects(lines, dupLines, @"Line data changed during parsing");
	
	NSArray* goldenFirst = [NSArray arrayWithObjects:
                          @"Simple string",
                          @"0", @"1", @"10",
                          @"1/21/09 4:19", nil];
	STAssertEqualObjects(goldenFirst, [lines objectAtIndex:0],
                       @"Failed to parse simple line");
	
	NSArray* goldenSecond = [NSArray arrayWithObjects:
                           @"String with \", and \"\"", @"",
                           @"100,000.00", @"$9,999.99 ",
                           @"\"Quote here\"", nil];
	STAssertEqualObjects(goldenSecond, [lines objectAtIndex:1],
                       @"Failed to parse line with quoting and escaping");
	
	NSArray* goldenThird = [NSArray arrayWithObjects:
                          @"Bad line", @"with two objects",
                          @"and a crappy end", nil];
	STAssertEqualObjects(goldenThird, [lines objectAtIndex:2],
                       @"Failed to parse line with edge cases");
}

-(void)testParsingData {
	NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNArrayCsvParserTest.csv"];
	BOOL success = [parser parseData:[NSData dataWithContentsOfFile:filePath]];
	STAssertTrue(success, @"Parsing failed on ZNArrayCsvParserTest.csv");
	
	[self checkLines];
}

-(void)parsedLine:(NSArray*)lineData context:(id)context {
	STAssertEquals(kContextObject, context, @"Wrong context for -parsedLine");
  
	[lines addObject:lineData];
	[dupLines addObject:[NSArray arrayWithArray:lineData]];	
}

@end
