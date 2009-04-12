//
//  ZNModelCsvParser.h
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@class ZNArrayCsvParser;
@protocol ZNArrayCsvParserDelegate;
@class ZNModel;

@protocol ZNModelCsvParserDelegate

// Called when a model is parsed.
-(void)parsedModel:(ZNModel*)model context:(id)context;
@end

@interface ZNModelCsvParser : NSObject {
	ZNArrayCsvParser* parser;
	// The ZNModel subclass to instantiate for every row.
	Class modelClass;
	// The names of the model properties contained in the fields in every row.
	NSArray* modelPropertyNames;
	NSUInteger numProperties;
	
	id<ZNModelCsvParserDelegate> delegate;	
}

@property (nonatomic, assign) id context;
@property (nonatomic, assign) id<ZNModelCsvParserDelegate> delegate;

// Initializes a parser, which can be used multiple times.
-(id)initWithModelClass:(Class)modelClass
			propertyNames:(NSArray*)modelPropertyNames;

// Parses a CSV document inside a NSData instance.
-(BOOL)parseData:(NSData*) data;

@end
