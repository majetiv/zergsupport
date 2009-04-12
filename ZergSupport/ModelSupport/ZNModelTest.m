//
//  ZNModelTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/15/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"
#import "ZNTestModels.h"

#import "ZNModelDefinitionAttribute.h"
#import "ZNModelDefinition.h"

@interface ZNModelTest : SenTestCase {
	ZNTestDate* dateModel;
	NSDate* date;
	ZNTestNumbers* numbersModel;
	NSNumber* trueObject;
	NSNumber* falseObject;
	NSNumber* doubleObject;
	NSNumber* integerObject;
	NSNumber* uintegerObject;
	NSString* testString;
	double testDouble;
	NSInteger testInteger;
	NSUInteger testUInteger;
}
@end

@implementation ZNModelTest

-(void)setUp {
	date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
	dateModel = [[ZNTestDate alloc] initWithProperties: nil];
	dateModel.pubDate = date;
	
	testDouble = 3.141592;
	testInteger = -3141592;
	testUInteger = 0x87654321;
	testString = @"Awesome \0 test String";
	numbersModel = [[ZNTestNumbers alloc] initWithProperties:nil];
	numbersModel.trueVal = YES;
	numbersModel.falseVal = NO;
	numbersModel.doubleVal = testDouble;
	numbersModel.integerVal = testInteger;
	numbersModel.stringVal = testString;
	numbersModel.uintegerVal = testUInteger;
	trueObject = [[NSNumber alloc] initWithBool:YES];
	falseObject = [[NSNumber alloc] initWithBool:NO];
	doubleObject = [[NSNumber alloc] initWithDouble:testDouble];
	integerObject = [[NSNumber alloc] initWithInteger:testInteger];
	uintegerObject = [[NSNumber alloc] initWithUnsignedInteger:testUInteger];
}

-(void)tearDown {
	[date release];
	[dateModel release];
	[numbersModel release];
	[trueObject release];
	[falseObject release];
	[doubleObject release];
	[integerObject release];
	[uintegerObject release];
}

-(void)dealloc {
	[super dealloc];
}

-(void)testPrimitiveBoxing {
	NSDictionary* numbersDict = [numbersModel
								 copyToDictionaryForcingStrings:NO];
	STAssertEqualObjects(trueObject, [numbersDict objectForKey:@"trueVal"],
						 @"Boxed YES should reflect the original value");
	STAssertEqualObjects(falseObject, [numbersDict objectForKey:@"falseVal"],
						 @"Boxed NO should reflect the original value");
	STAssertEqualObjects(doubleObject, [numbersDict objectForKey:@"doubleVal"],
						 @"Boxed double should reflect the original value");
	STAssertEqualObjects(integerObject, [numbersDict
										 objectForKey:@"integerVal"],
						 @"Boxed integer should reflect the original value");
	STAssertEqualObjects(uintegerObject, [numbersDict
										  objectForKey:@"uintegerVal"],
						 @"Boxed uinteger should reflect the original value");
	STAssertEqualStrings(testString, [numbersDict objectForKey:@"stringVal"],
						 @"Boxed string should equal the original value");
	ZNTestNumbers* thawedModel = [[ZNTestNumbers alloc]
								  initWithProperties:numbersDict];
	STAssertEquals(YES, thawedModel.trueVal,
				   @"Unboxed YES should equal original");
	STAssertEquals(NO, thawedModel.falseVal,
				   @"Unboxed NO should equal original");
	STAssertEquals(testDouble, thawedModel.doubleVal,
				   @"Unboxed double should equal original");
	STAssertEquals(testInteger, thawedModel.integerVal,
				   @"Unboxed integer should equal original");
	STAssertEquals(testUInteger, thawedModel.uintegerVal,
				   @"Unboxed uinteger should equal original");
	STAssertEqualStrings(testString, thawedModel.stringVal,
						 @"Unboxed string should equal original");
	[numbersDict release];
	[thawedModel release];
	
	numbersDict = [numbersModel copyToDictionaryForcingStrings:YES];
	STAssertEqualStrings(@"true", [numbersDict objectForKey:@"trueVal"],
						 @"String-boxed YES should reflect original");
	STAssertEqualStrings(@"false", [numbersDict objectForKey:@"falseVal"],
						 @"String-boxed NO should reflect original");
	STAssertEqualStrings(@"3.141592", [numbersDict objectForKey:@"doubleVal"],
						 @"String-boxed double should reflect original");
	STAssertEqualStrings(@"-3141592", [numbersDict objectForKey:@"integerVal"],
						 @"String-boxed integer should reflect original");
	STAssertEqualStrings(@"2271560481", [numbersDict
										 objectForKey:@"uintegerVal"],
						 @"String-boxed uinteger should reflect original");
	STAssertEqualStrings(testString, [numbersDict objectForKey:@"stringVal"],
						 @"String-boxed string should equal original");
	thawedModel = [[ZNTestNumbers alloc] initWithProperties:numbersDict];
	STAssertEquals(YES, thawedModel.trueVal,
				   @"String-unboxed YES should equal original");
	STAssertEquals(NO, thawedModel.falseVal,
				   @"String-unboxed NO should equal original");
	STAssertEquals(testDouble, thawedModel.doubleVal,
				   @"String-unboxed double should equal original");
	STAssertEquals(testInteger, thawedModel.integerVal,
				   @"String-unboxed integer should equal original");
	STAssertEquals(testUInteger, thawedModel.uintegerVal,
				   @"String-unboxed uinteger should equal original");
	STAssertEqualStrings(testString, thawedModel.stringVal,
						 @"String-unboxed string should equal original");
	[numbersDict release];
	[thawedModel release];
}

-(void)testDateBoxing {
	NSDictionary* dateDict = [dateModel copyToDictionaryForcingStrings:NO];
	STAssertEqualObjects(date, [dateDict objectForKey:@"pubDate"],
						 @"Boxed date should equal original date");
	ZNTestDate* thawedModel = [[ZNTestDate alloc] initWithProperties:dateDict];
	STAssertEqualObjects(date, thawedModel.pubDate,
						 @"Unboxed date should equal original date");
	[dateDict release];
	[thawedModel release];
	
	dateDict = [dateModel copyToDictionaryForcingStrings:YES];
	NSDate* date2 = [NSDate dateWithString:
					 [dateDict objectForKey:@"pubDate"]];
	STAssertEqualsWithAccuracy(0.0, [date2 timeIntervalSinceDate:date], 1.0,
							   @"String-boxed date should equal original date");
	thawedModel = [[ZNTestDate alloc] initWithProperties:dateDict];
	STAssertEqualsWithAccuracy(0.0, [thawedModel.pubDate
									 timeIntervalSinceDate:date],
							   1.0,
							   @"String-unboxed date should equal original");
	[dateDict release];
	[thawedModel release];
}

-(void)testNullBoxing {
	ZNTestNumbers* nullCarrier = [[[ZNTestNumbers alloc] init] autorelease];
	nullCarrier.stringVal = nil;
	
	NSDictionary* dict = [nullCarrier copyToDictionaryForcingStrings:NO];
	STAssertNil([dict objectForKey:@"stringVal"],
				@"Nil strings should be ignored while boxing");
	ZNTestNumbers* thawedNulls = [[ZNTestNumbers alloc]
								  initWithProperties:dict];
	STAssertNil(thawedNulls.stringVal,
				@"Nil strings should be unboxed to nil strings");
	[dict release];
	[thawedNulls release];

	dict = [nullCarrier copyToDictionaryForcingStrings:YES];
	STAssertNil([dict objectForKey:@"stringVal"],
				@"Nil strings should be ignored while string-boxing");
	thawedNulls = [[ZNTestNumbers alloc] initWithProperties:dict];
	STAssertNil(thawedNulls.stringVal,
				@"Nil strings should be string-unboxed to nil strings");
	[dict release];
	[thawedNulls release];

	dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"stringVal",
          nil];
	thawedNulls = [[ZNTestNumbers alloc] initWithProperties:dict];
	STAssertNil(thawedNulls.stringVal,
              @"NSNull instances should be string-unboxed to nil strings");
	[thawedNulls release];
}

-(void)testIsModelClass {
	STAssertTrue([ZNModel isModelClass:[ZNTestDate class]],
				 @"ZNTestDate is a model class");
	STAssertTrue([ZNModel isModelClass:[ZNTestNumbers class]],
				 @"ZNTestNumbers is a model class");
	
	STAssertFalse([ZNModel isModelClass:[NSObject class]],
				  @"NSObject is not a model class");

	STAssertFalse([ZNModel isModelClass:date],
				  @"A date is not a model class");
	STAssertFalse([ZNModel isModelClass:dateModel],
				  @"A model instance is not a model class");
}

-(void)testAllModelClasses {
  NSArray* allModelClasses = [ZNModel allModelClasses];
	STAssertTrue([allModelClasses containsObject:[ZNTestDate class]],
               @"ZNTestDate is a model class");
	STAssertTrue([allModelClasses containsObject:[ZNTestNumbers class]],
               @"ZNTestNumbers is a model class");  
  STAssertFalse([allModelClasses containsObject:[NSObject class]],
                @"NSObject is not a model class");
}

-(void)testExtendedAttributes {
  ZNModel* testModel = [[ZNTestNumbers alloc] initWithProperties:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         testString, @"undefined property", nil]];
  NSDictionary* dict = [testModel copyToDictionaryForcingStrings:NO];
  STAssertEqualStrings(testString, [dict objectForKey:@"undefined property"],
                       @"Extended property in serialized model");
  [dict release];
  
  dict = [testModel copyToDictionaryForcingStrings:YES];
  STAssertEqualStrings(testString, [dict objectForKey:@"undefined property"],
                       @"Extended property in string-serialized model");
  [dict release];
  
  [testModel release];
}

@end