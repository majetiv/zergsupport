//
//  Model.h
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>


// Base class for the models using Model Support.
//
// Classes representing models are created by inheriting from this class. Models
// have accessible attributes, which are defined by Objective C properties, and
// extended attributes. Extended attributes hold any attributes received at
// model initialization that are not accessible, and are preserved when the
// model is serialized.
//
// Extended attributes are useful when the models are backed by external
// services. Due to Apple's approval process, iPhone software is much more
// difficult to update than a Web service, so it's not uncommon that Web
// services will make their models richer. Extended attributes allow an iPhone
// application to correctly pass models between Web services, and to cache
// models backed by these services. Caches of serialized models will be read
// correctly, even if the model is updated with new accessible attributes.
//
// The easiest way to define accessible attributes is to declare corresponding
// properties in the model class. ModelSupport will honor the property
// specification keywords (nonatomic, readonly, readwrite, assign, copy, retain)
// and the following types:
//   double, BOOL, NSInteger, NSUInteger, NSString, NSDate
//
// If you want to define properties that are not model attributes in the model
// class, you can place the properties defining attributes in a protocol named
// after the model class, with the suffix _ZNModel, and implement the protocol
// in your model class. For example:
//    @class SomeModel : ZNModel <SomeModel_ZNModel>
// If such a protocol exists, only its properties are used to define accessible
// attributes. 
//
// Models are designed to be immutable, to avoid synchronization issues.
@interface ZNModel : NSObject {
	NSDictionary* props;
}

@property (nonatomic, readonly) NSDictionary* supplementalProperties;

#pragma mark Initializers

// Designated initializer.
//
// args:
//   model: the model to copy attributes from (can be nil)
//   properties: overrides attributes in the source model (can be nil) 
-(id)initWithModel:(ZNModel*)model properties:(NSDictionary*)dictionary;

// Initializes with the properties in the given dictionary.
-(id)initWithProperties:(NSDictionary*)dictionary;

// Initializes with the properties of the given model.
-(id)initWithModel:(ZNModel*)model;

#pragma mark Saving Attributes

// Serializes the model's attributes.
//
// args:
//   forceStrings: if YES, the attributes are converted to strings
//                 otherwise, the attributes are encapsulated in Cocoa objects
//                 such as NSNumber and NSDate
// returns:
//   a dictionary with the attributes, keyed by NSStrings reflecting the
//   attribute names
-(NSDictionary*)attributeDictionaryForcingStrings:(BOOL)forceStrings;

-(NSDictionary*)copyToDictionaryForcingStrings:(BOOL)forceStrings;

// Serializes the model's attributes.
//
// args:
//   forceStrings: if YES, the attributes are converted to strings
//                 otherwise, the attributes are encapsulated in Cocoa objects
//                 such as NSNumber and NSDate
// returns:
//   a mutable dictionary with the attributes, keyed by NSStrings reflecting
//   the attribute names
-(NSMutableDictionary*)attributeMutableDictionaryForcingStrings:(BOOL)forceStrings;

-(NSMutableDictionary*)copyToMutableDictionaryForcingStrings:(BOOL)forceStrings;


#pragma mark Dynamic Instantiation

// Checks if an Objective C object is a ModelSupport model, or a class for a
// ModelSupport model.
+(BOOL)isModelClass:(id)maybeModelClass;

// All the classes for ModelSupport models.
+(NSArray*)allModelClasses;

@end
