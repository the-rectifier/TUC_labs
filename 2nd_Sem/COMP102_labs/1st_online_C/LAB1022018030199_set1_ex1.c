#include <stdio.h>
#include <stdlib.h>

typedef struct list
{
    int value;
    struct list * next;
}list;

void insertnode(int val,list ** header);
void printemall(list * header);
void totheback(list * node, list **header, int x);
list* search(int x,list * header);
list* first_to_back(list * header);

int main()
{
    int nums;
    int i, temp, x;
    list * header;
    list * node;
    header = NULL;
    printf("How many numbers? \n");
    scanf("%d", &nums);
    for (i=0;i<nums;i++)
    {
        printf("Enter a val for node: \n");
        scanf("%d", &temp);
        insertnode(temp, &header);
    }
    printf("-----DONE CREATING LIST------\n");
    printemall(header);
    printf("Seach for which value? \n");
    scanf("%d", &x);
    node = search(x, header);
    //printf("%d\n", node->value);
    if ((node == NULL)||(node->next == NULL))
    {
        printf("Node not found or Node already last \n");
    }
    else if((node == header) && (node->value < node->next->value))
    {
        //if the node is first (header = node) special occasion 
        header = first_to_back(node); //(first) TO THE BACK!
    }
    else if(node->value < node->next->value)
    {
        totheback(node, &header, node->value); //TO THE BACK!
    }
    else {printf("no changes were made\n");}
    printemall(header);
    system("pause");
    return 1;
}

void insertnode(int val,list ** header)
{
    list * node;
    list * tmp;
    tmp = *header;
    node = (list *)malloc(sizeof(list)); //created an empty node somewhere in memory
    node->value = val;
    node->next = NULL; //filed it up 
    printf("-----ANNEXING-----\n");
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

list * search(int x, list * header)
{
    printf("-----SEARCHING-----\n");
    list * tmp;
    tmp = header;
    while ((tmp->value != x) && (tmp->next != NULL)) //searches for the node if not found or reaches end of list returns the node address
    {
        tmp = tmp->next;
    }
    return tmp; //if found regardless of being in the first/last pos return the address
}

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

void totheback(list * node, list ** header, int x)
{
    list * last;
    list * prev;
    last = *header;
    prev = *header;
    while(last->next != NULL) //grab the last node 
    {
        last = last->next;
    }
    while(prev->next->value != x) //grab the address of the node before "node"
    {
        prev = prev->next;
    }
    prev->next = node->next; //the previous node shows to the next one
    last->next = node; //last node point to newly last 
    node->next = NULL; //newly last points to null
}

list * first_to_back(list * header)
{
    list *tmp, *last = header;
    tmp = header->next; //tmp is the 2nd node (to become 1st)
    while(last->next != NULL){last = last->next;} //fin the last node
    last->next = header; //last node points to first, oroborus 
    last->next->next = NULL; //1st's pointer is severed
    return tmp; //returns the new header
}