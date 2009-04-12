//
//  ZNModelCsvParser.m
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNModelCsvParser.h"

#import "ModelSupport.h"
#import "ZNArrayCsvParser.h"


@interface ZNModelCsvParser () <ZNArrayCsvParserDelegate>
@end

@implementation ZNModelCsvParser

#pragma mark Lifecycle

-(id)initWithModelClass:(Class)theModelClass
            propertyNames:(NSArray*)theModelPropertyNames {
	if ((self = [super init])) {
		parser = [[ZNArrayCsvParser alloc] init];
		parser.delegate = self;
		modelClass = theModelClass;
		modelPropertyNames = [theModelPropertyNames retain];
		numProperties = [modelPropertyNames count];
	}
	return self;
}

@synthesize delegate;

-(void)dealloc {
	[parser release];
	[modelPropertyNames release];
	[super dealloc];
}

#pragma mark Context Proxy

-(id)context {
	return parser.context;
}

-(void)setContext:(id)context {
	parser.context = context;
}

#pragma mark Parsing

-(void)parsedLine:(NSArray*)lineData context:(id)context {
	NSUInteger numValues = [lineData count];
	NSDictionary* props;
	if (numValues == numProperties) {
		props = [[NSDictionary alloc] initWithObjects:lineData
                                          forKeys:modelPropertyNames];
	}
	else {
		NSUInteger numEntries =
        (numValues < numProperties) ? numValues : numProperties;
		NSArray* propNames = [modelPropertyNames subarrayWithRange:
                          NSMakeRange(0, numEntries)];
		NSArray* propValues = [lineData subarrayWithRange:
                           NSMakeRange(0, numEntries)];
		props = [[NSDictionary alloc] initWithObjects:propValues forKeys:propNames];
	}	
	ZNModel* model = [[modelClass alloc] initWithModel:nil properties:props];
	[props release];
	[delegate parsedModel:model context:context];
	[model release];
}

-(BOOL)parseData:(NSData*)data {
	return [parser parseData:data];
}

@end
