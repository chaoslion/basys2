#define	_CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "dpcdecl.h"
#include "depp.h"
#include "dmgr.h"

HIF hif = hifInvalid;
BYTE refbuf[255];
BYTE eppbuf[255];


void do_test(void) {
	UINT32 i;
	BYTE src, dst;
	time_t start, end;

	time(&start);	
	for (i = 0; i < 256; ++i) {
		src = refbuf[i];
		// write to epp
		DeppPutReg(hif, (BYTE)i, src, fFalse);
		// read back
		DeppGetReg(hif, (BYTE)i, &dst, fFalse);
		
		if (src != dst) {
			std::cout << "buffer mismatched. test failed!" << std::endl;
			return;
		}
	}
	time(&end);

	double dif = difftime(end, start);	
	std::cout << "buffer matched. test succeeded in " << dif << "s" << std::endl;
}

void main() {
	UINT32 i;
	char* device = "Basys2";
	if (!DmgrOpen(&hif, device)) {
		return;
	}

	if (!DeppEnable(hif)) {
		return;
	}

	// build reference
	for (i = 0; i < 256; ++i) {
		refbuf[i] = i;
	}

	do_test();

	if (hif != hifInvalid) {
		DeppDisable(hif);
		DmgrClose(hif);
	}
}