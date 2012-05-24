// remifi.cpp : main project file.

#include "stdafx.h"
#include <windows.h>
#include <stdio.h>

using namespace System;

void PressEscape ( )
{
	INPUT    Input={0};
	Input.type      = INPUT_KEYBOARD;
	Input.ki.wVk = VK_ESCAPE;
	::SendInput(1,&Input,sizeof(INPUT));
}

void PressReturn ( )
{
	INPUT    Input={0};
	Input.type      = INPUT_KEYBOARD;
	Input.ki.wVk = VK_RETURN;
	::SendInput(1,&Input,sizeof(INPUT));
}

int CALLBACK WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	int action;
	
	if (__argc != 2)
		return 0;

	action = atoi(__argv[1]);

	switch(action)
	{
	// escape
	case 1:
		PressEscape();
		break;

	// return
	case 2:
		PressReturn();
		break;

	default:
		break;
	}

	return 0;
}
