//
//  ZNModelXmlParser.m
//  ZergSupport
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNModelXmlParser.h"

#import "ModelSupport.h"
#import "ZNDictionaryXmlParser.h"
#import "ZNFormFieldFormatter.h"

@interface ZNModelXmlParser () <ZNDictionaryXmlParserDelegate>

+(NSDictionary*)copyParserSchemaFor:(NSDictionary*)responseModels
                             casing:(ZNFormatterCasing)responseCasing;
@end


@implementation ZNModelXmlParser

#pragma mark Lifecycle

-(id)initWithSchema:(NSDictionary*)theSchema
     documentCasing:(ZNFormatterCasing)documentCasing {
  if ((self = [super init])) {
    NSDictionary* parserSchema =
        [ZNModelXmlParser copyParserSchemaFor:theSchema
                                       casing:documentCasing];
    parser = [[ZNDictionaryXmlParser alloc] initWithSchema:parserSchema];
    parser.delegate = self;
    [parserSchema release];

    schema = [theSchema retain];
  }
  return self;
}
-(void)dealloc {
  [parser release];
  [schema release];
  [super dealloc];
}

@synthesize delegate;

-(void)setContext:(id)context {
  parser.context = context; 
}
-(id)context {
  return parser.context;
}

-(BOOL)parseData:(NSData*)data {
	return [parser parseData:data];
}
-(BOOL)parseURL:(NSURL*)url {
	return [parser parseURL:url];
}


#pragma mark ZNDictionaryXmlParser Delegate

-(void)parsedItem:(NSDictionary*)itemData
             name:(NSString*)itemName
          context:(id)context {
	id modelClass = [schema objectForKey:itemName];
	if ([ZNModel isModelClass:modelClass]) {
		ZNModel* model = [[modelClass alloc]
                               initWithModel:nil properties:itemData];
		[delegate parsedModel:model context:context];
		[model release];
	}
	else {
		[delegate parsedItem:itemData name:itemName context:context];
	}
}

+(NSDictionary*)copyParserSchemaFor:(NSDictionary*)models
                             casing:(ZNFormatterCasing)documentCasing {
  ZNFormFieldFormatter* formatter =
  [ZNFormFieldFormatter formatterToPropertiesFrom:documentCasing];
  NSMutableArray* keys = [[NSMutableArray alloc]
                          initWithCapacity:[models count]];
  NSMutableArray* values = [[NSMutableArray alloc]
                            initWithCapacity:[models count]];
  for (NSString* modelName in models) {
    [keys addObject:modelName];
    NSArray* directions = [[NSArray alloc] initWithObjects:
                           formatter, [models objectForKey:modelName],
                           nil];
    [values addObject:directions];
    [directions release];
  }
  NSDictionary* schema = [[NSDictionary alloc] initWithObjects:values
                                                       forKeys:keys];
  [keys release];
  [values release];
  return schema;
}
@end
