//
//  ZNModelCsvParserTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNModelCsvParser.h"
#import "ModelSupport.h"

@interface ZNModelCsvParserTestModel : ZNModel {
	NSString* name;
	double askPrice;
	double bidPrice;
	double previousClose;
}

@property (nonatomic, readonly, retain) NSString* name;
@property (nonatomic, readonly) double askPrice;
@property (nonatomic, readonly) double bidPrice;
@property (nonatomic, readonly) double previousClose;
@end

@implementation ZNModelCsvParserTestModel

@synthesize name, askPrice, bidPrice, previousClose;
-(void)dealloc {
	[name release];
	[super dealloc];
}
@end

@interface ZNModelCsvParserTest : SenTestCase <ZNModelCsvParserDelegate> {
	ZNModelCsvParser* parser;
	
	NSMutableArray* models;
}

@end

static NSString* kContextObject = @"This is the context";

@implementation ZNModelCsvParserTest

-(void)setUp {
	parser = [[ZNModelCsvParser alloc]
            initWithModelClass:[ZNModelCsvParserTestModel class]
            propertyNames:[NSArray arrayWithObjects:@"name", @"askPrice",
                           @"bidPrice", @"previousClose", nil]];
	parser.context = kContextObject;
	parser.delegate = self;
	
	models = [[NSMutableArray alloc] init];
	
}

-(void)tearDown {
	[parser release];
	[models release];
}

-(void)dealloc {
	[super dealloc];
}

-(void)checkModels {
	ZNModelCsvParserTestModel* model = [models objectAtIndex:0];
	STAssertEqualStrings(@"Apple Inc.", model.name, @"First stock name");
	STAssertEqualsWithAccuracy(79.51, model.askPrice, 0.0001,
                             @"First stock ask price");
	STAssertEqualsWithAccuracy(79.20, model.bidPrice, 0.0001,
                             @"First stock bid price");
	STAssertEqualsWithAccuracy(78.20, model.previousClose, 0.0001,
                             @"First stock previous close");
	
	model = [models objectAtIndex:2];
	STAssertEqualStrings(@"Microsoft Corpora", model.name, @"3rd stock name");
	STAssertEqualsWithAccuracy(18.84, model.askPrice, 0.0001,
                             @"3rd stock ask price");
	STAssertEqualsWithAccuracy(18.19, model.bidPrice, 0.0001,
                             @"3rd stock bid price");
}

-(void)testParsingData {
	NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNModelCsvParserTest.csv"];
	BOOL success = [parser parseData:[NSData dataWithContentsOfFile:filePath]];
	STAssertTrue(success, @"Parsing failed on ZNModelCsvParserTest.csv");
	
	[self checkModels];
}

-(void)parsedModel:(ZNModel*)model context:(id)context {
	STAssertEquals(kContextObject, context,
                 @"Wrong context passed to -parsedModel");
	STAssertTrue([model isKindOfClass:[ZNModelCsvParserTestModel class]],
               @"Wrong model class instantiated");
	
	[models addObject:model];
}

@end
