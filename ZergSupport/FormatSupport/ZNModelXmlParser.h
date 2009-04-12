//
//  ZNModelXmlParser.h
//  ZergSupport
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "ZNFormatterCasing.h"

@class ZNDictionaryXmlParser;
@class ZNModel;
@protocol ZNModelXmlParserDelegate;

// ModelSupport-enabled wrapper on top of DictionaryXmlParser.
//
// The wrapper instantiates ModelSupport models out of some of the items
// produced by DictionaryXmlParser.
// TODO(overmind): document schema
@interface ZNModelXmlParser : NSObject {
	ZNDictionaryXmlParser* parser;
	NSDictionary* schema;
	id<ZNModelXmlParserDelegate> delegate;
}

@property (nonatomic, assign) id context;
@property (nonatomic, assign) id<ZNModelXmlParserDelegate> delegate;

// Initializes a parser with a schema, which can be used multiple times.
-(id)initWithSchema:(NSDictionary*)schema
     documentCasing:(ZNFormatterCasing)documentCasing;

// Parses an XML document inside an NSData instance.
-(BOOL)parseData:(NSData*)data;

// Parses an XML document at an URL.
-(BOOL)parseURL:(NSURL*)url;

@end

// The interface between ZNDictionaryXMLParser and its delegate.
@protocol ZNModelXmlParserDelegate

// Called after parsing a model out of an XML tag.
-(void)parsedModel:(ZNModel*)model
           context:(id)context;

// Called after parsing an item corresponding to a known XML tag with no model.
-(void)parsedItem:(NSDictionary*)itemData
             name:(NSString*)itemName
          context:(id)context;
@end