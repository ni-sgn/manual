#include <stdio.h>

int main()
{
	float cels, fahr;
	float lower, upper, step;

	step = 20;
	lower = 0;
	upper = 300;

	for(fahr=lower; fahr <= upper; fahr+=step)
	{
		cels = 5.0/9*(fahr - 32);
		printf("%3.0f\t%6.2f\n", fahr, cels);
	}	

return 0;
}
