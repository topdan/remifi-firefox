// gcc -o ../../bin/x11/keyPress keyPress.c -lX11
// http://stackoverflow.com/questions/643413/sending-string-of-characters-to-active-window

#include <X11/Xlib.h>
#include<stdio.h>
#include<unistd.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>

#include <X11/Xutil.h>

void SendEvent(XKeyEvent *event, int press)
{
    if (press)
        XSendEvent(event->display, event->window, True, KeyPressMask, (XEvent *)event);
    else
        XSendEvent(event->display, event->window, True, KeyReleaseMask, (XEvent *)event);
    XSync(event->display, False);
}

void keyPress(int keyCode)
{
  Display *dpy = XOpenDisplay(NULL);
  Window cur_focus;   // focused window
  int revert_to;      // focus state
  XGetInputFocus(dpy, &cur_focus, &revert_to);    // get window with focus
  if (cur_focus == None)
  {
    printf("WARNING! No window is focused\n");
    return;
  }
  else
  {
    XKeyEvent event;
    event.display = dpy;
    event.window = cur_focus;
    event.root = RootWindow(event.display, DefaultScreen(event.display));
    event.subwindow = None;
    event.time = CurrentTime;
    event.x = 1;
    event.y = 1;
    event.x_root = 1;
    event.y_root = 1;
    event.same_screen = True;
    event.type = KeyPress;
    event.state = 0;
    event.keycode = XKeysymToKeycode(dpy, keyCode);
    SendEvent(&event, True);
    event.type = KeyRelease;
    SendEvent(&event, False);
  }
  
  XCloseDisplay(dpy);
}

int main(int argc,char * argv[]) {
  unsigned int keyCode;
  keyCode = atoi(argv[1]);
  keyPress(keyCode);
  return 0;
}