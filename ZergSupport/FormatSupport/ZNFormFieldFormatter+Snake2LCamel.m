//
//  ZNFormFieldFormatter+Snake2LCamel.m
//  ZergSupport
//
//  Created by Victor Costan on 1/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNFormFieldFormatter+Snake2LCamel.h"


#pragma mark Snake Case to Camel Case

@interface ZNFormFieldFormatterSnake2LCamel : ZNFormFieldFormatter
@end

@implementation ZNFormFieldFormatterSnake2LCamel

-(NSString*)copyFormattedName:(NSString*)name {
  NSUInteger nameLength = [name length];
  unichar* nameChars = (unichar*)calloc(nameLength, sizeof(unichar));
  [name getCharacters:nameChars];
  BOOL upcaseNextChar = NO;
  NSUInteger formattedNameLength = 0;
  for(NSUInteger i = 0; i < nameLength; i++) {
    if (nameChars[i] == '_') {
      upcaseNextChar = (formattedNameLength > 0) ? YES : NO;
      continue;
    }
    if (upcaseNextChar) {
      nameChars[formattedNameLength++] = toupper(nameChars[i]);
      upcaseNextChar = NO;
    }
    else
      nameChars[formattedNameLength++] = nameChars[i];
  }
  NSString* formattedName =
      [[NSString alloc] initWithCharacters:nameChars length:formattedNameLength];
  free(nameChars);
  return formattedName;
}

@end

@interface ZNFormFieldFormatterLCamel2Snake : ZNFormFieldFormatter
@end

@implementation ZNFormFieldFormatterLCamel2Snake

-(NSString*)copyFormattedName:(NSString*)name {
  NSMutableString* formattedName = [[NSMutableString alloc] init];
  NSUInteger nameLength = [name length];
  unichar* nameChars = (unichar*)calloc(nameLength, sizeof(unichar));
  [name getCharacters:nameChars];

  NSCharacterSet* upcaseLetters = [NSCharacterSet uppercaseLetterCharacterSet];
  NSUInteger i = 0;
  while (i < nameLength) {
    NSUInteger segmentStart = i;
    while (i < nameLength) {
      if ([upcaseLetters characterIsMember:nameChars[i]]) {
        if (i + 1 < nameLength &&
            ![upcaseLetters characterIsMember:nameChars[i + 1]] &&
            i != segmentStart) {          
          break;
        }
        else
          i++;
      }
      else {
        i++;
        if (i < nameLength && [upcaseLetters characterIsMember:nameChars[i]])
          break;
      }
    }
    NSString* segment =
        [[NSString alloc] initWithCharacters:&nameChars[segmentStart]
                                      length:(i - segmentStart)];
    [formattedName appendString:[segment lowercaseString]];
    [segment release];
    if (i < nameLength)
      [formattedName appendString:@"_"];
  }
  NSString* resultString = [[NSString alloc] initWithString:formattedName];
  [formattedName release];
  return resultString;
}

@end


#pragma mark Singletons

@implementation ZNFormFieldFormatter (Snake2LCamel)

static ZNFormFieldFormatter* snakeToLCamelFormatterSingleton;
static ZNFormFieldFormatter* lCamelToSnakeFormatterSingleton;

+(ZNFormFieldFormatter*)snakeToLCamelFormatter {
  @synchronized ([ZNFormFieldFormatterSnake2LCamel class]) {
    if (snakeToLCamelFormatterSingleton == nil) {
      snakeToLCamelFormatterSingleton =
          [[ZNFormFieldFormatterSnake2LCamel alloc] init]; 
    }
  }
  return snakeToLCamelFormatterSingleton;
}

+(ZNFormFieldFormatter*)lCamelToSnakeFormatter {
  @synchronized ([ZNFormFieldFormatterLCamel2Snake class]) {
    if (lCamelToSnakeFormatterSingleton == nil) {
      lCamelToSnakeFormatterSingleton =
          [[ZNFormFieldFormatterLCamel2Snake alloc] init]; 
    }
  }
  return lCamelToSnakeFormatterSingleton;  
}

@end
