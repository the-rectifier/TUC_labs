class Node:
    """Class Node with 3 attributes
    """

    def __init__(self, data):
        """Objects Constructor
        
        Args:
            data (*): Node's Data. Could be anything
        """        
        self.__data = data
        self.__next = None
        self.__prev = None

    @property
    def data(self):
        """data Getter
        
        Returns:
            type(data): Data
        """        
        return self.__data

    @data.setter
    def data(self, value):
        """data Setter
        
        Args:
            value (*): Could be anything
        """        
        self.__data = value

    @property
    def next(self):
        """next Getter
        
        Returns:
            Node: points to the next Node
        """        
        return self.__next

    @next.setter
    def next(self, value):
        """next Setter
        
        Args:
            value (Node): Next Node
        """        
        self.__next = value

    @property
    def prev(self):
        """prev Getter
        
        Returns:
            Node: Previous Node
        """        
        return self.__prev

    @prev.setter
    def prev(self, value):
        """prev Setter
        
        Args:
            value (Node): Previous Node
        """        
        self.__prev = value


