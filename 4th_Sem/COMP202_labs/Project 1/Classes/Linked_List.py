from .Node import Node
import gc

class Linked_List:
    """Linked_List Class with 2 attributes
    """    
    def __init__(self):
        """Linked_List constructor
        Head (Node): Head Node
        Tail (Node): Tail Node (auto set after each appending)
        numbered (Bool): numbered setting deciding nubmered output if True
        """        
        self.__head = None
        self.__tail = None
        self.__numbered = True

    @property
    def head(self):
        """head Getter
        
        Returns:
            Node: List's Head
        """        
        return self.__head

    @property
    def tail(self):
        """tail Getter
        
        Returns:
            Node: List's Tail
        """        
        return self.__tail

    def purge(self):
        """Clears the List's HEAD/TAIL. GC will do the rest(also invoke it manualy)
        """        
        print("List Purged")
        self.__head = None
        self.__tail = None
        gc.collect()
        # GC does the rest

    def append(self, data):
        """Method for appending new Node to existing List. Since we have a double Linked List and i have implemented
        the tail node as well we can just insert a new node after the last tail. No need for  using the old while loop
        
        Args:
            data (*): Data for the new Node 

        """        
        node = self.__head
        if node is None:
            self.__head = Node(data)
            self.__tail = self.__head
        else:
            new_node = Node(data)
            self.__tail.next = new_node
            new_node.prev = self.__tail
            self.__tail = new_node

    def insert_after(self, node, data):
        """Method for inserting a new Node after said node
        
        Args:
            node (Node): Insert new Node after this
            data (*): New Node's Data
        
        Returns:
            Node: If the list is empty return the newly created Head. Else return the current node(no change)
        """        
        new_node = Node(data)
        if node is None:
            # new head
            self.__head = new_node
            return self.__head
        if node.next is None:
            # append it
            node.next = new_node
            new_node.prev = node
            self.__tail = new_node
        else:
            node.next.prev = new_node
            new_node.next = node.next
            new_node.prev = node
            node.next = new_node
        return node

    def insert_before(self, node, data):
        """Method for inserting new Node before said node
        
        Args:
            node (Node): Insert new Node before this
            data (*): New Node's Data
        
        Returns:
            Node: Just like the above method return head if the list is empty else return the current node
        """        
        new_node = Node(data)
        if node.prev is None:
            # prepend it
            new_node.next = node
            node.prev = new_node
            self.__head = new_node
            return self.__head
        else:
            prev_node = node.prev
            prev_node.next = new_node
            new_node.prev = prev_node
            new_node.next = node
            node.prev = new_node
            return node

    def remove_node(self, node):
        """Method for popping said node from List
        
        Args:
            node (Node): Pop this Node from List
        
        Returns:
            Node: If popping Head return the next Node
                If popping Tail return previous Node
                If Head is Tail (1 Node in List) return None
        """        
        if node.prev is None and node.next is None:
            # single Node in list
            self.purge()
            return None
        elif node.next is None:
            prev_node = node.prev
            # last node in list
            self.__tail = prev_node
            prev_node.next = None
            return self.__tail
        elif node.prev is None:
            # head in the list
            self.__head = node.next
            node.next.prev = None
            return self.__head
        else:
            prev_node = node.prev
            next_node = node.next
            prev_node.next = next_node
            next_node.prev = prev_node
            return prev_node


    def print_list(self):
        """Method for printing the entire List
        Checks its internal numbered for numbered output or not
        """        
        node = self.__head
        count = 1
        while node is not None:
            if self.__numbered:
                print(f"{str(count)}.) -> {node.data}")
            elif not self.__numbered:
                print(f"{node.data}")
            count += 1
            node = node.next

    def get_stats(self):
        """Method for counting lines and characters in the List
        """        
        lines = 0
        chars = 0
        node = self.__head
        while node is not None:
            lines += 1
            chars += len(node.data)
            node = node.next
        print(f"Lines -> {lines}, Characters -> {chars}")

    def get_line(self, node):
        """Method for printing current node number
        
        Args:
            node (Node): Print this Node's number (aka the line number)
        """        
        count = 1
        curr_node = self.__head
        while curr_node != node:
            count += 1
            curr_node = curr_node.next
        print(count)


    def print_line(self, node):
        """Same as the above method but print the text as well(taking into consideration the numbered flag)
        
        Args:
            node (Node): Print this Node's data and line number if numbered specifies it
        """        
        if not self.__numbered:
            print(f"{node.data}")
            return
        temp = self.__head
        counter = 1
        while temp != node:
            temp = temp.next
            counter += 1
        print(f"{counter}.) {node.data}")

    def toggle(self):
        """Method for toggling the numbered flag
        """        
        self.__numbered = not self.__numbered
