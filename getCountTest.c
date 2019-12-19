#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
	
	forktest();
	getppid(getpid());
	wait();
	getChildren(getppid());
	printf(1, "number of called sys getppid=  %d ",getCount(21));
	printf(1, "number of called sys getChildren=  %d ",getCount(22));
 
 exit();
}