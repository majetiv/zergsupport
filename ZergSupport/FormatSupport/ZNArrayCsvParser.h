//
//  ZNArrayCsvParser.h
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>


@protocol ZNArrayCsvParserDelegate

// Called when a CSV line is parsed.
-(void)parsedLine:(NSArray*)lineData context:(id)context;
@end

@interface ZNArrayCsvParser : NSObject {
	// Accumulates the bytes inside a CSV cell.
	NSMutableData* currentCell;
	// Accumulates strings on a CSV line.
	NSMutableArray* currentLine;
	
	id<ZNArrayCsvParserDelegate> delegate;
	id context;
}

@property (nonatomic, assign) id context;
@property (nonatomic, assign) id<ZNArrayCsvParserDelegate> delegate;

// Initializes a parser, which can be used multiple times.
-(id)init;

// Parses a CSV document inside a NSData instance.
-(BOOL)parseData:(NSData*) data;

@end
