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

int checksum(list * tmp)
{   
    int sum;
    if (tmp->next == NULL)  //last node
    {
        sum = 0;
        if (tmp->value % 2 == 0) 
        {
            sum = tmp->value;
        }
        return sum;
    }
    else
    {
        sum = checksum(tmp->next); //function starts from here since first node is header and calls everytime itself until the last node
        if (tmp->value % 2 == 0)
        {
            sum = sum + tmp->value;
            return sum;
        }
        else
        {
            return sum;
        }
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
    printf("======PRINTING======\n");
    x = checksum(header);
    printf("%d\n", x);
    system("pause");
    return 1;
}