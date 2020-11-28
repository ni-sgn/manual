#include <iostream>

using namespace std;
class test_class 
{
private:
	int x;
public:
	void method_set(int x){
		this->x = x;
	}


	int method_here()
	{
		return this->x;
	}
};
int main()
{
	test_class test_obj;
	test_obj.method_set(4);
	test_obj.method_here();
        	
        
return 0;
}

