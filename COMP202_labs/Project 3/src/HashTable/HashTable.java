package HashTable;

import java.util.Collections;
import java.util.Vector;

/**
 * The HashTable has 100 indexes at first each with a Bucket Holding 10 Keys
 * For every split a Bucket is added to the end
 * For every merge a Bucket is removed
 * WILL NOT fall bellow 100 indexes.
 * @author Odysseas Stavrou (ostavrou@isc.tuc.gr)
 */
public class HashTable {
    private final double splitCont;
    private final double mergeCont;
    private static final int sizeOfBucket = 10;
    private int N = 100;
    private int p;
    //private int sumOfBuckets;
    private final Vector<Bucket> index;
    private int elements;

    /**
     * HashTable Constructor
     * It initializes the HashTable by creating 1 bucket in each Vector index
     * @param sc Split Condition
     * @param mc Merge Condition
     */
    public HashTable(double sc, double mc){
        this.index = new Vector<>();
        // this.sumOfBuckets = this.N;
        this.elements = 0;
        this.p = 0;
        this.init();
        this.mergeCont = mc;
        this.splitCont = sc;
    }

    /**
     * Hashes the provided key with the proper hash function
     * and calls the Bucket in the associated index to remove the Key
     * Also calls {@link #merge()} if necessary to remove bloated pages
     * Merging is only applicable if the indexes are > 100
     * @param x Key to be removed
     * @return Comparisons done
     */
    public int remove(int x){
        int idx = hash1(x);
        int comps;
        if(idx >= p) {
            this.index.get(idx).resetComp();
            comps = this.index.get(idx).remove(x);
            this.index.get(idx).resetComp();
        }else{
            this.index.get(hash2(x)).resetComp();
            comps = this.index.get(hash2(x)).remove(x);
            this.index.get(hash2(x)).resetComp();
        }
        if(comps>0)
            this.elements--;
        else
            comps = -comps;
        if(checkUsage() < mergeCont && this.index.size() > 100){
            this.merge();
        }
        return comps;
    }

    /**
     * Responsible for Merging 2 pages that were split in order to save space
     * There are 2 cases:
     * Table is doubled or not
     * The only way the Vector is double in size is to be the size of N
     * (which as mentioned in {@link #remove(int)} is always >100
     * N changes only in {@link #split()} and it gets doubled
     * In that case we halve the N (because a bucket is getting chopped off)
     * And we set the p pointer to the last location before doubling
     * The other case is in between where the p pointer is just moved backwards once
     * For merging ALL data from the last page is getting pulled
     * The last page is destroyed and the pulled Data is getting inserted again
     * Using the HASH1 function so they end up in the p Bucket
     */
    public void merge(){
        // System.out.printf("%b %d %d %d\n", this.phase1, this.N, this.index.size(), this.p);
        if(this.index.size() == this.N){
            this.N = this.N / 2;
            this.p = N - 1;
        }else {
            this.p--;
        }
        Vector<Integer> allNums = new Vector<>();
        Bucket b = this.index.lastElement();
        while(b != null){
            allNums.addAll(b.getData());
            b = b.getNext();
        }
        this.index.removeElementAt(this.index.size()-1);
        for(Integer num:allNums){
            int idx = hash1(num);
            this.index.get(idx).insert(num);
        }
    }

    /**
     * With the help of {@link Bucket#printBucket(int)} prints out a complete Image of the HashTable
     * inlcuding overflows
     */
    public void printTable(){
        for(int i=0;i<index.size();i++){
            Bucket b = index.get(i);
            b.printBucket(i);
        }
    }

    /**
     * Hashed the key with the proper Hash function and then calls
     * The Bucket in that index to insert the key
     * Also checks before inserting the new Load Factor
     * If a split is needed then it happens before the insertion
     * @param x Key to be inserted
     * @return Comparisons done
     */
    public int insert(int x){
        int idx;
        int comps;
        this.elements ++;
        // System.out.println(checkUsage());
        if(checkUsage() >= splitCont){
            this.split();
        }
        idx = hash1(x);
        if(idx >= p) {
            this.index.get(idx).resetComp();
            comps = this.index.get(idx).insert(x);
            this.index.get(idx).resetComp();
        }
        else{
            this.index.get(hash2(x)).resetComp();
            comps = this.index.get(hash2(x)).insert(x);
            this.index.get(hash2(x)).resetComp();
        }
        return comps;
    }

    /**
     * Method for splitting the current Bucket Located at p
     * Firstly it {@link #extend()} the Table and then it pulls ALL keys from the Bucket
     * To be Split
     * It then re-Inits the Bucket in that location and reinserts the keys using the
     * HASH2 function
     * If the table doubles in size then we reset the p pointer to zero and set the N to double
     */
    public void split(){
        this.extend();
        //int i = -1;
        Vector<Integer> allNums = new Vector<>();
        Bucket b = this.index.get(p);

        while(b != null){
            allNums.addAll(b.getData());
            //i++;
            b = b.getNext();
        }
        //this.sumOfBuckets -= i;

        Collections.sort(allNums);
        this.index.setElementAt(new Bucket(), p);

        for(Integer num: allNums){
            this.index.get(hash2(num)).insert(num);
        }
        this.p++;
        // System.out.println(this.p);
        if(this.index.size()==2*N){
            this.N = 2*this.N;
            this.p = 0;
        }
    }

    /**
     * Searches for a key using the proper hash function
     * @param x Key to be searched
     * @return Comparisons done
     */
    public int search(int x){
        int idx = hash1(x);
        if(idx < p){
            idx = hash2(x);
        }
        this.index.get(idx).resetComp();
        int comps =  this.index.get(idx).search(x);
        this.index.get(idx).resetComp();
        return comps;
    }

    /**
     * Calculates the Load Factor of the HashTable
     * @return Load Factor in decimal <1
     */
    public double checkUsage(){
        return (double)(this.elements)/(this.index.size()*sizeOfBucket);
    }

    /**
     * Hash Function 1
     * @param x Key to be hashed
     * @return Index
     */
    public int hash1(int x){
        int r = x % N;
        return r < 0 ? (r + N) : r;
    }

    /**
     * Unlike {@link #hash1(int)}  this function hashes with double N
     * Used in {@link #split()}
     * @param x Key to be hashed
     * @return Index
     */
    public int hash2(int x){
        int r = x % (N*2);
        return r < 0 ? r + (2*N) : r;
    }

    /**
     * Creates a new Bucket at every index of the HashTable
     */
    private void init(){
        for(int i=0;i<N;i++){
            this.index.add(new Bucket());
        }
    }

    /**
     * Appends a new Bucket to the end of HashTable
     */
    private void extend(){
        this.index.add(new Bucket());
        //this.stepBucket();
    }

    /**
     * toString method returning essential stats from the HashTable
     * @return P pointer value, Vector Size and total elements
     */
    @Override
    public String toString() {
        return "HashTable.HashTable{" +
                "p=" + p +
                // ", sumOfBuckets=" + sumOfBuckets +
                ", index_size =" + index.size() +
                ", elements=" + elements +
                '}';
    }
}