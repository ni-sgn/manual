#include <stdio.h>

int main()
{
	float fahr, cels;
	float lower, upper, step;

	lower = 0;
	upper = 300;
	step = 20;
	
	fahr = lower;
	while(fahr <= upper)
	{
		cels = 5.0/9 * (fahr - 32);
		printf("%3.f\t%6.2f\n", fahr, cels);
		fahr+=step;
	}	
return 0;
}
