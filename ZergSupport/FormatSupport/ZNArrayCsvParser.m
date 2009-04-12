//
//  ZNArrayCsvParser.m
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNArrayCsvParser.h"

@implementation ZNArrayCsvParser

#pragma mark Lifecycle

-(id)init {
	if ((self = [super init])) {
		currentLine = [[NSMutableArray alloc] init];
		currentCell = [[NSMutableData alloc] init];
	}
	return self;
}

@synthesize delegate, context;

-(void)dealloc {
	[currentCell release];
	[currentLine release];
	[super dealloc];
}

#pragma mark CSV Parser

-(BOOL)parseData:(NSData*) data {
	const uint8_t *bytes = [data bytes];
	const uint8_t *endOfBytes = bytes + [data length];
		
	[currentLine removeAllObjects];
	[currentCell setLength:0];
	while (bytes < endOfBytes) {  // outer loop -- parses a line		
		while (bytes < endOfBytes) {  // inner loop -- parses a cell
			BOOL quotedValue;
			if (*bytes == '"') {
				bytes++;
				quotedValue = YES;
			}
			else
				quotedValue = NO;
			while (bytes < endOfBytes) {  // put together the cell body
				const uint8_t* dataStart = bytes;  // quickly eat standard text
				if (quotedValue) {
					for (; bytes < endOfBytes; bytes++) {
						if (*bytes == '"')
							break;
					}
				}
				else {
					for (; bytes < endOfBytes; bytes++) {
						if (*bytes == '\n' ||
							*bytes == ',')
							break;
					}
				}
				[currentCell appendBytes:dataStart length:(bytes - dataStart)];
				
				// if the cell value is quoted, this might not quite be the end
				if (quotedValue && bytes < endOfBytes) {
					bytes++;
					// double "" is the escape value for a "
					if (bytes != endOfBytes && *bytes == '"') {
						[currentCell appendBytes:bytes length:1];
						bytes++;
						continue;
					}
				}
				break;
			}  // end of loop that puts together the cell body
			
			// append the cell value to the line
			NSString* currentCellString =
			[[NSString alloc] initWithData:currentCell encoding:NSUTF8StringEncoding];
			[currentLine addObject:currentCellString];
			[currentCellString release];
			[currentCell setLength:0];
			
			if (*bytes == '\n') {
				// end of line, go out to report the line
				bytes++;
				break;
			}
			else if (*bytes == ',') {
				// end of cell, keep going to complete the line
				bytes++;
				continue;
			}
			else {
				// weird way to end a cell, keep chugging along
				continue;
			}
			
		}  // end of inner loop that parses a cell
		NSArray* lineData = [[NSArray alloc] initWithArray:currentLine];
		[delegate parsedLine:lineData context:context];
		[lineData release];
		[currentLine removeAllObjects];
	}  // end of outer loop that parses a line
	return YES;
}

@end
