// remifi.cpp : main project file.

#include "stdafx.h"
#include <windows.h>
#include <stdio.h>

using namespace System;

void LeftMouseDown ( )
{
	INPUT    Input={0};
	// left down 
	Input.type      = INPUT_MOUSE;
	Input.mi.dwFlags  = MOUSEEVENTF_LEFTDOWN;
	::SendInput(1,&Input,sizeof(INPUT));
}

void LeftMouseUp ( )
{
	INPUT    Input={0};
	Input.type      = INPUT_MOUSE;
	Input.mi.dwFlags  = MOUSEEVENTF_LEFTUP;
	::SendInput(1,&Input,sizeof(INPUT));
}

void LeftMouseClick ( )
{
	LeftMouseDown();
	LeftMouseUp();
}

void MouseMove (int x, int y )
{  
  double fScreenWidth    = ::GetSystemMetrics( SM_CXSCREEN )-1; 
  double fScreenHeight  = ::GetSystemMetrics( SM_CYSCREEN )-1; 
  double fx = x*(65535.0f/fScreenWidth);
  double fy = y*(65535.0f/fScreenHeight);
  INPUT  Input={0};
  Input.type      = INPUT_MOUSE;
  Input.mi.dwFlags  = MOUSEEVENTF_MOVE|MOUSEEVENTF_ABSOLUTE;
  Input.mi.dx = fx;
  Input.mi.dy = fy;
  ::SendInput(1,&Input,sizeof(INPUT));
}

int CALLBACK WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	int action, x, y;
	
	if (__argc != 4)
		return 0;

	action = atoi(__argv[1]);
	x = atoi(__argv[2]);
	y = atoi(__argv[3]);

	switch(action)
	{
	// click
	case 1:
		MouseMove(x, y);
		LeftMouseClick();
		break;

	// over
	case 2:
		MouseMove(x, y);
		break;

	// down
	case 3:
		MouseMove(x, y);
		LeftMouseDown();

		break;

	// up
	case 4:
		MouseMove(x, y);
		LeftMouseUp();

		break;
	default:
		MouseMove(100, 100);
		break;
	}

	return 0;
}
