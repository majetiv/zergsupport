//
//  ZNModelDefinition.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNModelDefinition.h"

#import <objc/runtime.h>

#import "ZNModelDefinitionAttribute.h"

@implementation ZNModelDefinition

@synthesize name, attributes;

#pragma mark Lifecycle

-(id)initWithName:(NSString*)theName
		 attributes:(NSDictionary*)theAttributes {
	if ((self = [super init])) {
		name = [theName retain];
		attributes = [theAttributes retain];
	}
	return self;
}

-(void)dealloc {
	[name release];
	[attributes release];
	[super dealloc];
}

-(ZNModelDefinitionAttribute*)attributeNamed:(NSString*)attributeName {
	return [attributes objectForKey:attributeName];
}

-(NSString*)description {
	return [NSString
			stringWithFormat:@"<ZNModel definition name=%@ attributes=%@>",
			[name description], [attributes description]];
}

#pragma mark ObjC Metadata Parsing

+(objc_property_t*)copyModelPropertiesForClass:(Class)klass
										outCount:(unsigned int*)outCount {
	// Iterate through implemented protocols, see if one of them is named
	// ClassName_ZNMS.
	const char* className = class_getName(klass);
	const size_t classNameLength = strlen(className);
	
	unsigned int protocolCount;
	Protocol** protocols = class_copyProtocolList(klass, &protocolCount);
	for (unsigned int i = 0; i < protocolCount; i++) {
		Protocol* protocol = protocols[i];
		const char* protocolName = protocol_getName(protocol);
		if (strncmp(protocolName, className, classNameLength))
			continue;
		if (strcmp(protocolName + classNameLength, "_ZNMS"))
			continue;
		
		free(protocols);
		return protocol_copyPropertyList(protocol, outCount);
	}
	
	free(protocols);
	return class_copyPropertyList(klass, outCount);
}

+(ZNModelDefinition*)newDefinitionForClass:(Class)klass {
	unsigned int propertyCount;
	const objc_property_t* properties =
	    [self copyModelPropertiesForClass:klass outCount:&propertyCount];
	
	ZNModelDefinitionAttribute** attributesCarray =
	   (ZNModelDefinitionAttribute**)calloc(propertyCount,
	   sizeof(ZNModelDefinitionAttribute*));
	NSString** attributeNamesCarray = (NSString**)calloc(propertyCount,
														 sizeof(NSString*));
	for (unsigned int i = 0; i < propertyCount; i++) {
		attributesCarray[i] = [ZNModelDefinitionAttribute
							   newAttributeFromProperty:properties[i]
							                    ofClass:klass];
		attributeNamesCarray[i] = [attributesCarray[i] name];
	}	
	NSDictionary* attributes =
	    [NSDictionary dictionaryWithObjects:attributesCarray
									forKeys:attributeNamesCarray
									  count:propertyCount];
	free(attributesCarray);
	free(attributeNamesCarray);
	
	NSString* className = [NSString stringWithCString:class_getName(klass)];
	
	return [[ZNModelDefinition alloc] initWithName:className
										attributes:attributes];
}

@end
