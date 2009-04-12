//
//  SenTestCase+Fixtures.h
//  ZergSupport
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "GTMSenTestCase.h"


// Implements fixtures for Model Support models.
//
// To use fixtures, create XML (better format on the TODO list) files containing
// your fixture definitions, and include them in your test target, then use the
// methods below to instantiate the models in the fixtures. For bonus points,
// remember not to include your fixtures in your release builds.
//
// The sample fixture below defines two UserModel instances:
// <?xml version="1.0" encoding="UTF-8"?>
// <fixtures>
//   <UserModel>
//     <name>victor</name>
//     <password>secret</password>
//   </UserModel>
//   <UserModel>
//     <name>admin</name>
//     <password>pa55w0rd</password>
//   </UserModel>
// </fixtures>
//
// Fixtures can instantiate any Model Support model class. Class and attribute
// names in fixtures can use snake_case, so fixtures can be conveniently shared
// with other languages.
@interface SenTestCase (Fixtures)

// Loads fixtures (models) from the given file.  
-(NSArray*)fixturesFrom:(NSString*)fileName;

@end
