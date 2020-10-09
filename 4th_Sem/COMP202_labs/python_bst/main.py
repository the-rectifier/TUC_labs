from bst import Bst

if __name__ == "__main__":
    tree = Bst()

    tree.insert(5)
    tree.insert(1)
    tree.insert(6)
    tree.insert(4)
    tree.insert(0)
    tree.insert(8)
    tree.insert(7)
    tree.insert(5.7)

    node = tree.search(4)
    print(node.get_key())