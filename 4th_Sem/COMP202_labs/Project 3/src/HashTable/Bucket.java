package HashTable;

import java.util.Vector;

/**
 * @author Odysseas Stavrou (ostavrou@isc.tuc.gr)
 * The Bucket as 10 places for storing data
 * Data is stored in a Vector
 */
public class Bucket {
    private final Vector<Integer> data;
    private static final int bucketSize = 10;
    private static int comps = 0;
    private Bucket next; // "pointer" to the overflow bucket

    /**
     * Data getter
     * @return Vector with the Bucket's Data
     */
    public Vector<Integer> getData() {
        return data;
    }

    /**
     * Overflow getter
     * @return Next overflow bucket (Could be Null)
     */
    public Bucket getNext() {
        return next;
    }

    /**
     * Bucket's Constructor
     */
    public Bucket(){
        this.data = new Vector<>();
        this.next = null;
    }

    /**
     * Removes an element from the Bucket
     * To tackle the restructuring of the elements, ALL elements are copied into a Vector
     * The WHOLE Bucket AND its overflows are destroyed
     * Then from the Vector the Key is removed if available
     * Re-insert every element back to the Bucket using its own {@link #insert(int)} method
     * ignoring its comparisons
     * @param x Key to remove
     * @return >0 for successful removal <0 for failed removal so that the {@link HashTable}
     * will know whether to decrease its elements counter
     */
    public int remove(int x){
        Bucket b = this;
        Vector<Integer> nums = new Vector<>();
        int comps = 0;
        while (b != null) {
            comps++;
            nums.addAll(b.getData());
            b = b.getNext();
        }
        comps++;
        if(nums.contains(x)){
            nums.removeElementAt(nums.indexOf(x));
            this.next = null;
            this.data.clear();
            for(Integer num:nums){
                this.insert(num);
            }
            return comps;
        }
        return -comps;
    }

    /**
     * Checks whether the current Bucket is full
     * @return True if the Vector has size 10 else False
     */
    public boolean isFull(){return this.data.size() == bucketSize;}

    /**
     * Searches for a specific Key inside the Bucket
     * @param x Key to be searched
     * @return Amount of comparisons Done, regardless of the success of the search
     */
    public int search(int x){
        Bucket b = this;
        int comps = 0;
        while(b != null){
            comps++;
            if(b.getData().contains(x)){
                return comps;
            }
            b = b.getNext();
            comps++;
        }
        return comps;
    }

    /**
     * Inserts a new Key inside the Bucket
     * If Bucket {@link #isFull()} then if the overflow exists
     * call that method. Else create a new overflow and then call its method
     * @param x Key to be insert
     * @return Comparisons done
     */
    public int insert(int x){
        comps++;
        if(!this.isFull()) {
            this.data.add(x);
        }else{
            comps++;
            if(this.next == null){
                this.next = new Bucket();
            }
            this.next.insert(x);
        }
        return comps;
    }

    /**
     * In collaboration with {@link HashTable}'s {@link HashTable#printTable()} prints out
     * the Whole Bucket (w/ overflows)
     * @param j Overflow indexer
     */
    public void printBucket(int j){
        int i = 0;
        Bucket b = this;
        while(b != null){
            System.out.printf("Data[%d, %d] => %s\n", j,i,b.getData().toString());
            b = b.next;
            i++;
        }
    }

    /**
     * Resets internal variable for comparisons for the "recursive" method {@link #insert(int)}
     */
    public void resetComp(){comps = 0;}
}