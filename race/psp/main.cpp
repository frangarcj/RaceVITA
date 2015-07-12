#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <psp2/moduleinfo.h>

#include <psplib/pl_snd.h>
#include <psplib/video.h>
#include <psplib/pl_psp.h>
#include <psplib/ctrl.h>

#include "./menu.h"

PSP2_MODULE_INFO(0,0,PSP_APP_NAME);
//PSP_MAIN_THREAD_ATTR(THREAD_ATTR_USER | THREAD_ATTR_VFPU);

extern int m_bIsActive;

static void ExitCallback(void* arg)
{
  m_bIsActive = 0;
  ExitPSP = 1;
}

int main(int argc, char **argv)
{
  /* Initialize PSP */
  //pl_psp_init(argv[0]);
  printf("RUNNING");
  pl_psp_init("cache0:/VitaDefilerClient/Documents/");
  printf("PSP_INIT");
  pl_snd_init(512, 0);
  printf("SND_INIT");
  pspCtrlInit();
  printf("CTRL_INIT");
  pspVideoInit();
  printf("VIDEO_INIT");

  /* Initialize callbacks */
  pl_psp_register_callback(PSP_EXIT_CALLBACK,
                           ExitCallback,
                           NULL);
  printf("REGISTER EXIT");
  pl_psp_start_callback_thread();
  printf("START_CALLBACK");

  if (InitMenu())
  {
    printf("INIT_MENU");
    DisplayMenu();
    TrashMenu();
  }

  /* Release PSP resources */
  pl_snd_shutdown();
  pspVideoShutdown();
  pl_psp_shutdown();

  return(0);
}
