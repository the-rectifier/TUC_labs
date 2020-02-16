class Node {
    private int key;
    protected Node left;
    protected Node right;

    public Node(int val)
    {
        this.key = val;
        this.left = this.right = null;
    }

    public int get_key()
    {
        return this.key;
    }
}
class Tree {
    private Node root;

    public Tree()
    {
        this.root = null;
    }

    public Node search(int val)
    {
        return do_search(root, val);
    }

    private Node do_search(Node node, int val)
    {
        if (node == null || node.get_key() == val)
        {
            return node;
        }
        if(node.get_key() > val)
            return do_search(node.left, val);
        return do_search(node.right, val);
    }

    public void insert(int val)
    {
        this.root = do_insert(this.root, val);
    }

    private Node do_insert(Node node, int val)
    {
        if(node == null)
        {
            node = new Node(val);
            return node;
        }
        if (val > node.get_key())
        {
            node.right = do_insert(node.right, val);
        }
        else
            node.left = do_insert(node.left, val);
        return node;
    }
}

public class test {

    public static void main(String args[])
    {
        Tree tree = new Tree();
        tree.insert(0);
        tree.insert(20);
        tree.insert(4);
        tree.insert(-1);
        tree.insert(9);

        Node node = tree.search(20);
        System.out.println(node.get_key());
    }
}
