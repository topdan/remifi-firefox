// File: 
// mouse.m
//
// Compile with: 
// gcc -o mouse mouse.m -framework ApplicationServices -framework Foundation
//
// Usage:
// ./mouse -a 2 -x 10 -y 10


#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

void PostMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point) 
{
 CGEventRef theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
 CGEventPost(kCGHIDEventTap, theEvent);
 CFRelease(theEvent);
}

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
  
  int action = [args integerForKey:@"a"];
  
  int x;
  int y;
  int up;
  
  CGPoint pt;

  switch(action)
  {
    // click
    case 1:
      pt.x = [args integerForKey:@"x"];
      pt.y = [args integerForKey:@"y"];
      
      PostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, pt);
      [NSThread sleepForTimeInterval:0.1];
      PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, pt);
      [NSThread sleepForTimeInterval:0.1];
      PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, pt);
      break;
    
    // over
    case 2:
      pt.x = [args integerForKey:@"x"];
      pt.y = [args integerForKey:@"y"];

      PostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, pt);
      break;
    
    // down
    case 3:
      pt.x = [args integerForKey:@"x"];
      pt.y = [args integerForKey:@"y"];
      
      PostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, pt);
      [NSThread sleepForTimeInterval:0.1];
      PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, pt);
      break;
      
    // up
    case 4:
      pt.x = [args integerForKey:@"x"];
      pt.y = [args integerForKey:@"y"];
      
      PostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, pt);
      [NSThread sleepForTimeInterval:0.1];
      PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, pt);
      break;
    
    default:
      break;
  }
  
  [pool release];
  return 0;
}