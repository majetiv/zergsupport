//
//  ZNModelDefinition.h
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@class ZNModelDefinitionAttribute;

@interface ZNModelDefinition : NSObject {
	NSString* name;
	NSDictionary* attributes;
}

@property (nonatomic, readonly, retain) NSString* name;
@property (nonatomic, readonly, retain) NSDictionary* attributes;

-(ZNModelDefinitionAttribute*)attributeNamed:(NSString*)name;

+(ZNModelDefinition*)newDefinitionForClass:(Class)klass;

@end
