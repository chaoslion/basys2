#define	_CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <ctime>
#include <iostream>
#include <sstream>

#include "dpcdecl.h"
#include "depp.h"
#include "dmgr.h"


#define REG_MIN01 (BYTE)0x0
#define REG_MIN10 (BYTE)0x1
#define REG_HRS01 (BYTE)0x2
#define REG_HRS10 (BYTE)0x3
#define REG_SDMOD (BYTE)0x4

HIF hif = hifInvalid;


#define SDMODE_FLASH_ALL8			(BYTE)0x00
#define SDMODE_PROGRESS8			(BYTE)0x01
#define SDMODE_COUNT8				(BYTE)0x02
#define SDMODE_FLASH_ALL4			(BYTE)0x03
#define SDMODE_PROGRESS4			(BYTE)0x04
#define SDMODE_PROGRESS8_FLASH4		(BYTE)0x05

void write_sdmode(BYTE mode) {
	DeppPutReg(hif, REG_SDMOD, mode, false);
}

void write_minute(uint8_t minute) {
	if (!(minute >= 0 && minute <= 59)) {
		return;
	}
	// get x1 and x10 parts
	uint8_t x1 = (uint8_t)(minute % 10);
	uint8_t x10 = (uint8_t)(minute / 10);
	DeppPutReg(hif, REG_MIN01, (BYTE)x1, false);
	DeppPutReg(hif, REG_MIN10, (BYTE)x10, false);
}

void write_hour(uint8_t hour) {
	if (!(hour >= 0 && hour <= 23)) {
		return;
	}
	// get x1 and x10 parts
	uint8_t x1 = (uint8_t)(hour % 10);
	uint8_t x10 = (uint8_t)(hour / 10);
	DeppPutReg(hif, REG_HRS01, (BYTE)x1, false);
	DeppPutReg(hif, REG_HRS10, (BYTE)x10, false);
}

void main(int argc, char** argv) {

	if (argc != 2) {
		std::cerr << "invalid arguments. expected sd_mode (0-5)" << std::endl;
		return;
	}

	// parse mode from command line
	std::istringstream ss(argv[1]);
	uint16_t sd_mode;
	if (!(ss >> sd_mode)) {
		std::cerr << "invalid argument. expected sd_mode: integer (0-5)" << std::endl;
		return;
	}

	if (!(
		sd_mode == SDMODE_FLASH_ALL8 ||
		sd_mode == SDMODE_PROGRESS8 ||
		sd_mode == SDMODE_COUNT8 ||
		sd_mode == SDMODE_FLASH_ALL4 ||
		sd_mode == SDMODE_PROGRESS4 ||
		sd_mode == SDMODE_PROGRESS8_FLASH4
		)) {
		std::cerr << "invalid mode. expected integer (0-5)" << std::endl;
		return;
	}

	char* device = "Basys2";
	if (!DmgrOpen(&hif, device)) {
		std::cerr << "can not open device" << std::endl;
		return;
	}

	if (!DeppEnable(hif)) {
		std::cerr << "can not enable device" << std::endl;
		return;
	}	

	// get locale time
	time_t t = time(0);
	struct tm *now = localtime(&t);
	
	write_hour((uint8_t)now->tm_hour);
	write_minute((uint8_t)now->tm_min);
	write_sdmode((BYTE)sd_mode);

	if (hif != hifInvalid) {
		DeppDisable(hif);
		DmgrClose(hif);
	}

	std::cout << "time was set to: " << now->tm_hour << ":" << now->tm_min << " o'clock" << std::endl;
}