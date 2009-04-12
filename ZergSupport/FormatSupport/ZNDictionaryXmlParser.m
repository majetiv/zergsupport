//
//  DictionaryXmlParser.m
//  ZergSupport
//
//  Created by Victor Costan on 1/9/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNDictionaryXmlParser.h"

#import "ZNFormFieldFormatter.h"


@implementation ZNDictionaryXmlParser

#pragma mark Lifecycle

-(id)initWithSchema:(NSDictionary*) theSchema {
	if ((self = [super init])) {
		schema = [theSchema retain];
		
		currentValue = [[NSMutableString alloc] init];
		currentItem = [[NSMutableDictionary alloc] init];
		
		currentItemSchema = nil;
		currentItemName = nil;
		currentProperty = nil;		
	}
	
	return self;
}

-(void)dealloc {
	[schema release];
	[currentValue release];
	[currentItem release];
	[currentItemName release];
	[currentProperty release];
	[super dealloc];
}

@synthesize context;
@synthesize delegate;

#pragma mark Parsing Lifecycle

-(void)cleanUpAfterParsing {
	currentItemSchema = nil;
	[currentItemName release];
	currentItemName = nil;
	[currentProperty release];
	currentProperty = nil;
	
	[currentItem removeAllObjects];
	[currentValue setString:@""];
	
	[parser release];
	parser = nil;
}

-(BOOL)parseData:(NSData*)data {
	parser = [[NSXMLParser alloc] initWithData:data];
	parser.delegate = self;
	BOOL success = [parser parse];
	[self cleanUpAfterParsing];
	return success;
}

-(BOOL)parseURL:(NSURL*)url {
	parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	parser.delegate = self;
	BOOL success = [parser parse];
	[self cleanUpAfterParsing];
	return success;
}

#pragma mark Schema management

-(void)loadSchemaDirective:(NSObject*)schemaDirective
                     forName:(NSString*)name {
  currentItemName = [name retain];
  
  if ([schemaDirective isKindOfClass:[NSArray class]]) {
    NSArray* arrayDirective = (NSArray*)schemaDirective;
    NSAssert([arrayDirective count] >= 2, @"Array schema directive needs to at "
             @"least contain a key formatter and interpretation information!");
    
    currentKeyFormatter = [arrayDirective objectAtIndex:0];
    NSAssert([currentKeyFormatter respondsToSelector:
             @selector(copyFormattedName:)], @"Formatter object in schema "
             @" directive does not respond to -copyFormattedName:");
    schemaDirective = [arrayDirective objectAtIndex:1];
  }
  else
    currentKeyFormatter = nil;
  
  currentItemHasOpenSchema = ![schemaDirective isKindOfClass:[NSSet class]];
  if (currentItemHasOpenSchema)
    currentItemSchema = nil;
  else
    currentItemSchema = (NSSet*)schemaDirective;
}

#pragma mark NSXMLParser Delegate

-(void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict {
	if (currentItemName != nil) {
		// already parsing an item, see if it's among the keys
		if (currentItemHasOpenSchema || [currentItemSchema containsObject:
                                     elementName]) {
			currentProperty = [elementName retain];
		}
	}
	else if (currentItemSchema = [schema objectForKey:elementName]) {
		// parsing new item
    [self loadSchemaDirective:currentItemSchema forName:elementName];
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (currentProperty != nil) {
		[currentValue appendString:string];
	}
}

-(void)parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName {
	if (currentProperty != nil) {
		// parsing a property
		if ([currentProperty isEqualToString:elementName]) {
			// done parsing the property
      NSString* propertyKey;
      if (currentKeyFormatter)
        propertyKey = [currentKeyFormatter copyFormattedName:currentProperty];
      else
        propertyKey = currentProperty;
      NSString* propertyValue = [[NSString alloc] initWithString:currentValue];
			[currentItem setObject:[NSString stringWithString:propertyValue]
                      forKey:propertyKey];
      if (currentKeyFormatter)
        [propertyKey release];
      [propertyValue release];
			
			[currentProperty release];
			currentProperty = nil;
			[currentValue setString:@""];
		}
	}
	else if ([currentItemName isEqualToString:elementName]) {
		// done parsing an entire item
		[delegate parsedItem:[NSDictionary dictionaryWithDictionary:currentItem]
                    name:currentItemName
                 context:context];
		
		[currentItem removeAllObjects];
		currentItemSchema = nil;
		[currentItemName release];
		currentItemName = nil;
    currentKeyFormatter = nil;
	}	
}

@end
