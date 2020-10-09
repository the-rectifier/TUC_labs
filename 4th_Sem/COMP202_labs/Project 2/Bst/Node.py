class Node:
    def __init__(self, key):
        """Nodes constructor

        Args:
            key (Integer): Nodes key
        """        
        try:
            self.__key = int(key)
        except ValueError as e:
            print(f"Enter Integer!: {e}")
        self.__left = None
        self.__right = None

    def __str__(self):
        """Print the subtree with THIS Node as root

        Returns:
            String: Every subtree
        """        
        return "%s: [%s, %s]" % (str(self.key),self.left,self.right)

    @property
    def key(self):
        return self.__key

    @property
    def left(self):
        return self.__left

    @left.setter
    def left(self, node):
        self.__left = node

    @property
    def right(self):
        return self.__right

    @right.setter
    def right(self, node):
        self.__right = node
