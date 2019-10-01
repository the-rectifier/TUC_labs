#include <stdio.h>
#include <stdlib.h>

typedef struct list
{
    int value;
    struct list * next;
}list;

void printemall(list * header)
{
    list * tmp;
    tmp = header;
    while (tmp != NULL)
    {
        printf("%d\n", tmp->value);
        tmp = tmp->next;
    }
}

int checksum3(list * node)
{
    int sum;
    if(node == NULL)
    {
        return 0;
    }
    else
    {
        sum = checksum3(node->next);
        if(node->value % 2 == 1)
        {
            sum += node->value;
        }
        printf("\n%d[%d]", node->value, sum);
        return sum;
    }
    
}

int findAltResult(struct list* node, int position){
    int sum;

    if(node==NULL) 
    {
        sum=0;
        return 0;
    }

    sum = findAltResult(node->next, position = position + 1);
    if(position % 2 == 0)
    {
        sum = sum - node->value;
    }
    else
    {
       sum += node->value;
    }

    printf("%d[%d]\n", node->value, sum);
    return sum;
}

int checksum(list * tmp)
{   int sum;
    if (tmp->next == NULL)  //last node
    {
        sum = 0; // the sum is obv 0 (duhhhh)
        printf("%d[%d](yes)\n", tmp->value, sum); //0 is divisable by anything so we get sneaky
        sum = tmp->value; //sets the sum to the value of the last node
        return sum; //returns the value
    }
    else
    {
        sum = checksum(tmp->next); //function starts from here since first node is header and calls everytime itself until the last node
        if (tmp->value == 0)
        {
            printf("Can't divide by 0\n");
            return sum;
        }
        else
        {
            printf("%d[%d]", tmp->value, sum);
            if(sum % tmp->value == 0)printf("(yes)\n");
            else printf("(no)\n");
            sum = sum + tmp->value; //increment the sum by the value of the node and pass it on to the previous function
            return sum;
        }
    }

}

void checksum2(list * tmp,int sum)
{  
	if(tmp == NULL)
	{
		return;
	}
	checksum2(tmp->next, sum + tmp->value);
	if(sum % tmp->value == 0)
	{
		printf("%d[%d](Yes)\n", tmp->value, sum);
	}
	else
	{
		printf("%d[%d](No)\n", tmp->value, sum);
	}
}

void insertnode(int val,list ** header)
{
    list * node;
    list * tmp;
    tmp = *header;
    node = (list *)malloc(sizeof(list)); //created an empty node somewhere in memory
    node->value = val;
    node->next = NULL; //filed it up
    printf("======ANNEXING======\n");
    if (*header == NULL) //this is only for the FIRST node of the list, for evey other node while takes over
    {
        *header = node;
    }
    else
    {
        while(tmp->next != NULL) //searches for the node before the new last one
        {
            tmp = tmp->next; //when found assigns tmp the semi-last address
        }
        tmp->next = node; //annex the new node
    }
}

int main()
{
    int nums, i,temp, x;
    list * header;
    list * tmp;
    header = NULL;
    printf("How many numbers? \n");
    scanf("%d", &nums);
    for (i=0;i<nums;i++)
    {
        printf("Enter a val for node: \n");
        scanf("%d", &temp);
        insertnode(temp, &header);
    }
    printf("======DONE CREATING LIST======\n");
    printemall(header);
    tmp = header;
    printf("======PRINTING======\n");
    x= checksum(tmp);
	printf("======PRINTING======\n");
	checksum2(tmp, 0);
    printf("======PRINTING======\n");
    x = findAltResult(tmp, 1);
    printf("======PRINTING======\n");
    x = checksum3(header);
    //system("pause");
    return 0;
}