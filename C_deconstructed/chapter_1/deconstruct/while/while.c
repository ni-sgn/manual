#include <stdio.h>

int main()
{
int lower, upper;
int fahr, celsius, step;

step = 20;
upper = 300;
lower = 0;

fahr = lower;
while(fahr <= upper)
{
	celsius = 5*(fahr - 32)/9;
        printf("%3d\t, %6d\n", fahr, celsius);
	fahr+=20;
}	

return 0;
}
