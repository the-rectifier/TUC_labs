"""
This module contains 2 classes:
Node: The node class having 3 arguments:
private key
public left child
public right child
Bst:  The actual Tree representation with the basic methods search/insert/delete and its str representation
"""


class Node:
    def __init__(self, key):
        """
        Node's Constructor:
        >>> Node(key)
        :param key: Node's value
        """
        self._key = key
        self.right = None
        self.left = None

    def get_key(self):
        """
        Method to return node's key
        """
        return self._key


class Bst:
    def __init__(self):
        """
        Tree's Constructor
        """
        self._root = None

    def get_root(self):
        """
        Method that returns tree's root
        """
        return self._root

    def del_tree(self):
        """
        Method that deletes the tree
        Sets root as None then gb does the rest
        """
        self._root = None

    def insert(self, val):
        """
        User Callable method that begins insertion
        """
        if self._root is None:
            self._root = Node(val)
        else:
            self._do_ins(val, self._root)

    def _do_ins(self, val, node):
        """
        Recursively add each value to the right place
        """
        if val > node.get_key():
            if node.right is None:
                node.right = Node(val)
            else:
                self._do_ins(val, node.right)
        else:
            if node.left is None:
                node.left = Node(val)
            else:
                self._do_ins(val, node.left)

    def search(self, val):
        """
        User callable method that begins search
        """
        if self._root is None:
            return None
        else:
            return self._search(val, self._root)

    def _search(self, val, node):
        """
        Recursively search each node and return it upwards in the calling sequence
        """
        if val == node.get_key():
            return node
        elif val > node.get_key() and node.right is not None:
            return self._search(val, node.right)
        elif val < node.get_key() and node.left is not None:
            return self._search(val, node.left)
        else:
            return None
