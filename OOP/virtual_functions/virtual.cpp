#include <iostream>

class parent {
public:
	virtual void print()
	{
	std::cout << "hello form parent" << std::endl;
	}
};

class child : public parent {
public:
	void print()
	{
	std::cout << "hello from child" << std::endl;
	}
};	

int main()
{
parent parent_obj;
child child_obj;
parent_obj.print();
child_obj.print();

parent* pParent_obj = &child_obj;
pParent_obj->print();

return 0;
}
