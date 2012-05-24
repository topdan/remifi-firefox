// File: 
// keyboard.m
//
// Compile with: 
// gcc -o keyboard keyboard.m -framework ApplicationServices -framework Foundation
//
// Usage:
// ./keyboard -key a
// ./keyboard -key RETURN


#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

void PostKeyboardEvent(CGKeyCode keyCode) 
{
  CGEventRef downEvent = CGEventCreateKeyboardEvent(NULL, keyCode, YES);
  CGEventSetFlags(downEvent, kCGEventFlagMaskControl);

  CGEventRef upEvent = CGEventCreateKeyboardEvent(NULL, keyCode, NO);

  CGEventPost(kCGAnnotatedSessionEventTap, downEvent);
  CGEventPost(kCGAnnotatedSessionEventTap, upEvent);

  CFRelease(downEvent);
  CFRelease(upEvent);
}

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
  
  NSString *keyString = [args stringForKey:@"key"];
  int keyCode = 0;
  
  if ([keyString isEqualToString:@"escape"]) {
    keyCode = 53;
    
  } else if ([keyString isEqualToString:@"return"]) {
    keyCode = 36;
    
  }
  
  if (keyCode != 0) {
    PostKeyboardEvent(keyCode);
  }
  
  [pool release];
  return 0;
}