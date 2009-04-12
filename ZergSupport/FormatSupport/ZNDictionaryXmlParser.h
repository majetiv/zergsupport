//
//  DictionaryXmlParser.h
//  ZergSupport
//
//  Created by Victor Costan on 1/9/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@protocol ZNDictionaryXmlParserDelegate;
@class ZNFormFieldFormatter;


// XML document parser between DOM and SAX, based on NSXMLParser.
//
// This parser assumes that the document contains some elements that are
// interesting objects (e.g. <item> in an RSS feed), and the objects' attributes
// are described by sub-elements (e.g. <title> and <pubDate> in an RSS feed).
//
// This design leads to less memory consumption and complexity than a DOM
// parser, and much more user friendliness than a SAX parser. It is ideal for
// documents which are flat (not hierarchical) collections of objects.
//
// The "schema" supplied to the reader is a dictionary mapping element names to
// "descriptor" objects that indicate how the element should be transformed into
// an object. The descriptors can be:
//   * a NSArray where the first element is a key formatter
//   (ZNFormFieldFormatter) and the second element is the actual descriptor
//   * a NSSet containing the names of the sub-element that are valid attributes
//   (all the other sub-elements shall be discarded)
//   * any other object, meaning that all sub-elements are valid attributes
//
// The parser reads through an XML document, and builds NSDictionaries out of
// elements that match the "schema". After an element is parsed completely, the
// resulting dictionary is sent to the parser's delegate via the
// -parsedItem:name:context message.
@interface ZNDictionaryXmlParser : NSObject {
	id<ZNDictionaryXmlParserDelegate> delegate;
	id context;
	NSDictionary* schema;
	
	// underlying XML parser
	NSXMLParser* parser;
	// accumulates the properties of the currently parsed item 
	NSMutableDictionary* currentItem;
	// the current item's name
	NSString* currentItemName;
	// the currently parsed property of the currently parsed item
	NSString* currentProperty;
	// the value for the currently parsed property
	NSMutableString* currentValue;
	// the schema for the currently parsed item
	NSSet* currentItemSchema;
	// if YES, the current item accepts all sub-elements given to it
	BOOL currentItemHasOpenSchema;
  // if not nil, formats the keys that 
  ZNFormFieldFormatter* currentKeyFormatter;
}

@property (nonatomic, assign) id context;
@property (nonatomic, assign) id<ZNDictionaryXmlParserDelegate> delegate;

// Initialized a parser for a schema, which can be used multiple times.
-(id)initWithSchema:(NSDictionary*)schema;

// Parses an XML document inside an NSData instance.
-(BOOL)parseData:(NSData*)data;

// Parses an XML document at an URL.
-(BOOL)parseURL:(NSURL*)url;

@end


// The interface between ZNDictionaryXMLParser and its delegate.
@protocol ZNDictionaryXmlParserDelegate

// Called after parsing an item corresponding to a known XML tag.
-(void)parsedItem:(NSDictionary*)itemData
             name:(NSString*)itemName
          context:(id)context;
@end
