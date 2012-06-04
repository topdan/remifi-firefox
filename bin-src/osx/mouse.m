// File: 
// mouse.m
//
// Compile with: 
// gcc -o mouse mouse.m -framework ApplicationServices -framework Foundation
//
// Usage:
// ./mouse -a click -x 10 -y 10
// ./mouse -a over -x 10 -y 10
// ./mouse -a down -x 10 -y 10
// ./mouse -a up -x 10 -y 10
// ./mouse -a drag -x1 10 -y1 10 -x2 20 -y2 20 -up 0


#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

void PostMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point) 
{
 CGEventRef theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
 CGEventSetType(theEvent, type);
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