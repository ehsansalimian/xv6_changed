// A simple program which just prints something on screen

#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
	int pidd=0;
	pidd =getpid();
	int forkProc=0;
	  printf(1, "processId:		%d\n\n\n\n",getpid());

	  printf(1, "parentProcessId:		 %d\n\n\n\n",getppid());
	  printf(1, "childrensOfProcess:	%d     for  prosessId:%d\n\n\n\n",getChildren(getpid()),getpid());
forkProc =fork();
if (forkProc==0)
{
	 printf(1, "in the child process\n\n\n\n");

}
else
{
 printf(1, "processId:		%d\n\n\n\n",getpid());

 printf(1, "childrensOfProcess:	%d     for  prosessId:%d\n\n\n\n",getChildren(pidd),pidd);

}
 
 exit();
}
