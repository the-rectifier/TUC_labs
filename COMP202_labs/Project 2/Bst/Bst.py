from .Node import Node
from timeit import default_timer as timer


class Bst:
    """Class with methods for creating and managing a BST
    """    
    def __init__(self):
        """Tree's Constructor (root = Null)
        """        
        self.__root = None
        self.comps = []
        self.comp = 0

    @property
    def root(self):
        return self.__root

    def delete(self):
        """Tree purger (gc takes care fo the rest)
        """        
        self.__root = None

    def insert(self, val):
        """Method for inserting new key insto the Tree

        Args:
            val (Integer): Key for insertion

        Returns:
            Integer, float: Return ammount of comparisons done and time spent 
        """        
        start_time = timer()
        count = 0
        if self.__root is None:
            self.__root = Node(val)
        else:
            node = self.__root
            while True:
                if val > node.key:
                    count += 1
                    if node.right is None:
                        node.right = Node(val)
                        break
                    else:
                        node = node.right
                elif val <= node.key:
                    count += 1
                    if node.left is None:
                        node.left = Node(val)
                        break
                    else:
                        node = node.left
        return count, timer() - start_time

    def populate(self, n):
        """Method for opening a particular file and populating the tree with the integers in that file

        Args:
            n (Integer): open file_ + n 

        Returns:
            List, List: return a list with all the comparisons done and time spend for each insertion
        """        
        nums = []
        comps = []
        times = []
        with open("test_" + str(n), 'rb') as f:
            while True:
                byte = f.read(4)
                if not byte:
                    break
                num = int.from_bytes(byte, 'little', signed=True)
                nums.append(num)

        for num in nums:
            compares, time_taken = self.insert(num)
            comps.append(compares)
            times.append(time_taken)

        return comps, times

    def search(self, val):
        """Search for a particular key

        Args:
            val (Integer): Key to be searched

        Returns:
            Integer, Float: return ammount of commparisons and time spent
        """        
        node = self.__root
        time_start = timer()
        count = 0
        while True:
            count += 1
            if node is None:
                time_diff = timer() - time_start
                return count, time_diff
            if node.key < val:
                node = node.right
            elif node.key > val:
                node = node.left
            elif node.key == val:
                time_diff = timer() - time_start
                return count, time_diff

    def print_io(self):
        """Inorder print the tree
        """        
        if self.__root is None:
            print("Empty Tree")
        else:
            self.__print_io(self.__root)

    def __print_io(self, node):
        if node is None:
            return
        self.__print_io(node.left)
        print(node.key)
        self.__print_io(node.right)

    def print_range(self, min_v, max_v):
        """print every key that resides inside a specific range

        Args:
            min_v (Integer): lower bound
            max_v (Integer): upper bound
        """        
        if self.__root is None:
            print("Empty Tree")
        else:
            self._print_range(self.__root, min_v, max_v)

    def _print_range(self, node, min_v, max_v):
        if node is None:
            return
        if node.key < node.left.key:
            self._print_range(node.right, min_v, max_v)
        if min_v <= node.key <= max_v:
            print(node.key)
        if node.key > node.right.key:
            self._print_range(node.left, min_v, max_v)

    def search_range(self, num, k):
        """same as print range but this time keep the ammount of comparisons done to a list

        Args:
            num (Integer): lower bound
            k (Integer): range definer
        """        
        self.comp = 0
        if self.root is None:
            print("Empty Tree")
            return
        else:
            entry = self.root
            self._search_range(entry, num, num+k)

    def _search_range(self, entry, min_r, max_r):
        if entry is None:
            self.comps.append(self.comp)
            return
        self.comp += 1
        if entry.key < max_r:
            self._search_range(entry.right, min_r, max_r)
        if min_r <= entry.key <= max_r:
            self.comps.append(self.comp)
        if entry.key > min_r:
            self._search_range(entry.left, min_r, max_r)
