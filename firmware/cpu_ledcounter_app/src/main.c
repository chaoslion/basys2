#include <stdio.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "xiomodule.h"
#include "xil_exception.h"

XIOModule iomodule;
volatile u8 counter = 0;

void fit1_irq(void* ref) {
	XIOModule_DiscreteWrite(&iomodule, 0x1, counter++);
}

void pit1_irq(void* ref) {
	XIOModule_DiscreteWrite(&iomodule, 0x1, counter++);
}

int main() {
	Xil_ICacheEnable();
	Xil_DCacheEnable();


    XIOModule_Initialize(&iomodule, XPAR_IOMODULE_0_DEVICE_ID);
    XIOModule_Start(&iomodule);


     XIOModule_Connect(&iomodule, XIN_IOMODULE_FIT_1_INTERRUPT_INTR, fit1_irq, NULL);
     XIOModule_Enable(&iomodule, XIN_IOMODULE_FIT_1_INTERRUPT_INTR);
/*
    XIOModule_Timer_Initialize(&iomodule, XPAR_IOMODULE_0_DEVICE_ID);
    XIOModule_SetResetValue(&iomodule, 0, 390625*1);
    XIOModule_Timer_SetOptions(&iomodule, 0, XTC_AUTO_RELOAD_OPTION);
    XIOModule_Connect(&iomodule, XIN_IOMODULE_PIT_1_INTERRUPT_INTR, pit1_irq, NULL);
    XIOModule_Enable(&iomodule, XIN_IOMODULE_PIT_1_INTERRUPT_INTR);
    XIOModule_Timer_Start(&iomodule, 0);
*/


    microblaze_enable_interrupts();

    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler) XIOModule_DeviceInterruptHandler, NULL);
    Xil_ExceptionEnable();
    // XIOModule_DiscreteWrite(&iomodule, 0x1, 0xFF);
    while(1);
    return 0;
}
