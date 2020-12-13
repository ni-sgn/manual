#include <stdio.h>

#define LOWER 0
#define UPPER 300
#define STEP 20

int main()
{
	float fahr, cels;
	fahr = LOWER;
	while(fahr <= UPPER)
	{
		cels = 5.0/9 * (fahr - 32);
		printf("%3.0f\t%6.2f\n", fahr, cels);
		fahr+=STEP;
	}
		

return 0;
}
