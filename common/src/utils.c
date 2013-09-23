#include "utils.h"
#include <stdio.h>


void displayArray(char* name, char* data, int length) 
{
	printf ("%s ", name);
	int i;
	for (i=0; i < length; i++) {
		printf("%x ", data[i]);
	}
	printf("\n");
}

void displayCharArray(char* name, char* data, int length) 
{
	printf ("%s ", name);
	int i;
	for (i=0; i < length; i++) {
		printf("%x ", data[i]);
	}
	printf("\n");
}

void displayIntArray(char* name, int* data, int length) 
{
	printf ("%s ", name);
	int i;
	for (i=0; i < length; i++) {
		printf("%x ", data[i]);
	}
	printf("\n");
}
