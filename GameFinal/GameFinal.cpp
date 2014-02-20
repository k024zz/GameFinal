// GameFinal.cpp : ���� DLL Ӧ�ó���ĵ���������
//

#include "stdafx.h"
#include "GameFinal.h"
#include "CWin32Device.h"

// ���ǵ���������һ��ʾ��
GAMEFINAL_API int nGameFinal=0;

// ���ǵ���������һ��ʾ����
GAMEFINAL_API int fnGameFinal(void)
{
	return 42;
}

GAMEFINAL_API IDevice* createDevice(E_DRIVER_TYPE driverType, u32 width, u32 height, u32 style, bool vsync, const SDeviceContextSettings& settings)
{
	SCreationParameters creationParams;
	creationParams.ClientWidth = width;
	creationParams.ClientHeight = height;
	creationParams.DriverType = driverType;
	creationParams.DepthBits = settings.DepthBits;
	creationParams.StencilBits = settings.StencilBits;
	creationParams.MultiSamplingCount = settings.MultiSamplingCount;
	creationParams.MultiSamplingQuality = settings.MultiSamplingQuality;

	CWin32Device* device = new CWin32Device(creationParams);
	HRESULT hr = device->init();
	if (FAILED(hr))
		return NULL;
	return device;
}