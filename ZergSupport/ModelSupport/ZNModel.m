//
//  Model.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNModel.h"

#import "ZNModelDefinition.h"
#import "ZNModelDefinitionAttribute.h"
#import "ZNMSAttributeType.h"
#import "ZNMSRegistry.h"

@interface ZNModel ()
-(void)loadFromDictionary:(NSDictionary*)dictionary;
@end


@implementation ZNModel

@synthesize supplementalProperties = props;

#pragma mark Lifecycle

// Designated initializer.
-(id)initWithModel:(ZNModel*)model properties:(NSDictionary*)dictionary {
	if ((self = [super init])) {
		if (!model) {
			[self loadFromDictionary:dictionary];
		}
		else { 
			NSMutableDictionary* dict =
			    [model copyToMutableDictionaryForcingStrings:NO];
			[dict addEntriesFromDictionary:dictionary];
			[self loadFromDictionary:dict];
			[dict release];
		}
	}
	return self;
}

-(id)initWithProperties:(NSDictionary*)dictionary {
	return [self initWithModel:nil properties:dictionary];
}

-(id)initWithModel:(ZNModel*)model {
	return [self initWithModel:model properties:nil];
}

-(void)dealloc {
	[props release];
	[super dealloc];
}

#pragma mark Boxing

-(void)loadFromDictionary:(NSDictionary*)dictionary {
	NSMutableDictionary* supplementalProps = [[NSMutableDictionary alloc] init];

	ZNModelDefinition* definition = [[ZNMSRegistry sharedRegistry]
									 definitionForModelClass:[self class]];
	NSDictionary* defAttributes = [definition attributes];
	for(NSString* attributeName in dictionary) {
		NSObject* boxedObject = [dictionary objectForKey:attributeName];
		ZNModelDefinitionAttribute* attribute = [defAttributes
												 objectForKey:attributeName];
		if (attribute) {
			ZNMSAttributeType* attributeType = [attribute type];
			[attributeType unboxAttribute:attribute
							   inInstance:self
									 from:boxedObject];
		}
		else {
			[supplementalProps setObject:boxedObject forKey:attributeName];
		}
	}
	
	[props release];
	props = [[NSDictionary alloc] initWithDictionary:supplementalProps];
	[supplementalProps release];
}



-(NSMutableDictionary*)copyToMutableDictionaryForcingStrings:(BOOL)forceStrings {
	NSMutableDictionary* attributes = [[NSMutableDictionary alloc]
						 			   initWithDictionary:props];
	ZNModelDefinition* definition = [[ZNMSRegistry sharedRegistry]
									 definitionForModelClass:[self class]];
	
	NSDictionary* defAttributes = [definition attributes];
	for (NSString* attributeName in defAttributes) {
		ZNModelDefinitionAttribute* attribute = [defAttributes
												 objectForKey:attributeName];
		ZNMSAttributeType* attributeType = [attribute type];
		NSObject* boxedValue = [attributeType boxAttribute:attribute															  
												inInstance:self
											   forceString:forceStrings];
		if (boxedValue != nil)
			[attributes setObject:boxedValue forKey:attributeName];
	}
	return attributes;
}

-(NSDictionary*)copyToDictionaryForcingStrings:(BOOL)forceStrings {
	NSMutableDictionary* attributes =
	    [self copyToMutableDictionaryForcingStrings:forceStrings];
	
	NSDictionary* dictionary = [[NSDictionary alloc]
								initWithDictionary:attributes];
	[attributes release];
	return dictionary;
}

-(NSDictionary*)attributeDictionaryForcingStrings:(BOOL)forceStrings {
	return [[self copyToDictionaryForcingStrings:forceStrings] autorelease];
}

-(NSMutableDictionary*)attributeMutableDictionaryForcingStrings:(BOOL)forceStrings {
	return [[self copyToMutableDictionaryForcingStrings:forceStrings]
			autorelease];
}

#pragma mark Debugging

-(NSString*)description {
	return [NSString stringWithFormat:@"<ZNModel name=%s attributes=%@>",
			class_getName([self class]),
			[[self attributeDictionaryForcingStrings:YES] description]];
}


#pragma mark Dynamic Instantiation

+(BOOL)isModelClass:(id)maybeModelClass {
	// Plain objects.
	if (![maybeModelClass respondsToSelector:@selector(alloc)])
		return NO;
	
	// Walk up the chain and find ZNModel
	while (maybeModelClass && maybeModelClass != [NSObject class]) {
		if (maybeModelClass == [ZNModel class])
			return YES;
		maybeModelClass = [maybeModelClass superclass];
	}
	return NO;
}

+(NSArray*)allModelClasses {
  // Get all the classes from the Objective C runtime. 
  int numClasses = objc_getClassList(NULL, 0);
  Class* classes = (Class*)calloc(sizeof(Class), numClasses);
  numClasses = objc_getClassList(classes, numClasses);
  
  // Filter the classes descending from ZNModel.
  int modelClasses = 0;
  SEL mss = @selector(methodSignatureForSelector:);
  for (int i = 0; i < numClasses; i++) {
    Class klass = classes[i];
    if (class_respondsToSelector(klass, mss) && [ZNModel isModelClass:klass])
      classes[modelClasses++] = klass;
  }
  
  // Wrap the result in an NSArray.
  NSArray* returnValue = [NSArray arrayWithObjects:classes count:modelClasses];
  free(classes);
  return returnValue;
}


@end
