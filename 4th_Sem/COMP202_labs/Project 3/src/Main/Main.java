package Main;

import BST.BinarySearchTree;
import HashTable.HashTable;

import java.io.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.List;
import java.util.Random;
import java.util.Vector;

/**
 * Main.Main class
 * @author Odysseas Stavrou (ostavrou@isc.tuc.gr)
 */
public class Main {
    private static HashTable HT; // static HashTable
    private static int frame; // frame variable used for limiting the numbers inserted each time
    private static final int nums = 10_000;
    private static final int samples = 50;


    /**
     * Main.Main method, inserts numbers into the vector and kick-stats the whole program
     * @param args file to be read
     */
    public static void main(String[] args){
        if(args.length != 1){
            System.out.println("Usage: java Main.Main.class [filename]");
            System.exit(-1);
        }
        String fileName = args[0];
        Vector<Integer> numbers = new Vector<>();
        readNums(fileName, numbers);
        doStuff(numbers);
    }

    /**
     * Responsible for calling:
     * {@link #stats(Vector, double, double, int, Vector, Vector, Vector, Vector)} x2 to create the required data
     * {@link #doBST(Vector, Vector, Vector, Vector)} to gather the BST data
     * {@link #exportML(Vector, Vector, Vector, Vector, Vector, Vector, Vector, Vector, Vector)} to export the MatLab script
     * {@link #printRes(Vector, Vector, Vector, Vector, Vector, Vector, Vector, Vector, Vector)} to print out the results
     * @param numbers Vector with All the numbers to be inserted
     */
    public static void doStuff(Vector<Integer> numbers){
        double splitCont;
        double mergeCont = 0.5;
        Vector<Integer> comparisons = new Vector<>();
        Vector<Double> avgCompsInsert05 = new Vector<>();
        Vector<Double> avgCompsInsert08 = new Vector<>();
        Vector<Double> avgCompsDelete05 = new Vector<>();
        Vector<Double> avgCompsDelete08 = new Vector<>();
        Vector<Double> avgCompsSearch05 = new Vector<>();
        Vector<Double> avgCompsSearch08 = new Vector<>();

        Vector<Double> avgCompsInsertBST = new Vector<>();
        Vector<Double> avgCompsSearchBST = new Vector<>();
        Vector<Double> avgCompsDelBST = new Vector<>();

        splitCont = 0.5;
        stats(numbers, splitCont, mergeCont, samples, comparisons, avgCompsInsert05, avgCompsDelete05, avgCompsSearch05);
        splitCont = 0.8;
        stats(numbers, splitCont, mergeCont, samples, comparisons, avgCompsInsert08, avgCompsDelete08, avgCompsSearch08);

        // doBST(numbers, avgCompsInsertBST, avgCompsSearchBST, avgCompsDelBST);
        exportML(avgCompsInsert05, avgCompsInsert08, avgCompsSearch05, avgCompsSearch08, avgCompsDelete05, avgCompsDelete08,
                avgCompsInsertBST, avgCompsSearchBST, avgCompsDelBST);
        printRes(avgCompsInsert05, avgCompsInsert08, avgCompsSearch05, avgCompsSearch08, avgCompsDelete05, avgCompsDelete08,
                avgCompsInsertBST, avgCompsSearchBST, avgCompsDelBST);

//        Uncomment the following to print results
//        In any case the above function exports them into a matlab script
//        System.out.printf("AVG COMPARISONS / INSERTION BST (per 100 Elements) -> %s\n", avgCompsInsertBST);
//        System.out.printf("AVG COMPARISONS / SEARCH BST (per 100 Elements) -> %s\n", avgCompsSearchBST);
//        System.out.printf("AVG COMPARISONS / DELETION BST (per 100 Elements) -> %s\n", avgCompsDelBST);
//        System.out.printf("AVG COMPARISONS / INSERTION LF 50 %% (per 100 Elements) -> %s\n", avgCompsInsert05);
//        System.out.printf("AVG COMPARISONS / SEARCH LF 50 %% (per 100 Elements) -> %s\n", avgCompsSearch05);
//        System.out.printf("AVG COMPARISONS / DELETION LF 50 %% BST (per 100 Elements) -> %s\n", avgCompsDelete05);
//        System.out.printf("AVG COMPARISONS / INSERTION LF 80 %% (per 100 Elements) -> %s\n", avgCompsInsert08);
//        System.out.printf("AVG COMPARISONS / SEARCH LF 80 %% (per 100 Elements) -> %s\n", avgCompsSearch08);
//        System.out.printf("AVG COMPARISONS / DELETION LF 80 %% BST (per 100 Elements) -> %s\n", avgCompsDelete08);
//        System.out.println("Please check graphs.m for matlab graphs");
    }

    /**
     * Automatically generated from IntelliJ IDEA to simplify existing method
     * Created required data and results regarding the HashTable performance
     * Called twice by the method {@link #doStuff(Vector)} (one for each value of the split condition)
     * @param numbers Vector containing the numbers to be inserted
     * @param splitCont Split condition (>50% / >80%)
     * @param mergeCont Merge condition (<50%)
     * @param samples How many samples to check with (50)
     * @param comparisons Simple Vector to house all comparisons for each operation (Insertion / Search / Deletion)
     * @param avgCompsInsert Vector containing the averages for insertions
     * @param avgCompsDelete Vector containing the averages for searching
     * @param avgCompsSearch Vector containing the averages for deletions
     */
    public static void stats(Vector<Integer> numbers, double splitCont, double mergeCont, int samples, Vector<Integer> comparisons,
                             Vector<Double> avgCompsInsert, Vector<Double> avgCompsDelete, Vector<Double> avgCompsSearch) {
        HT = new HashTable(splitCont, mergeCont);
        for (int i = 100; i <= nums; i += 100) {
            insert(numbers, comparisons, i);
            frame = i;
            avgCompsInsert.add((double) getSum(comparisons) / 100);
            comparisons.clear();

            List<Integer> subNums = numbers.subList(0,i);

            search(subNums, comparisons, samples);
            avgCompsSearch.add((double) getSum(comparisons) / samples);
            comparisons.clear();

            delete(subNums, comparisons, samples);
            avgCompsDelete.add((double) getSum(comparisons) / samples);
            comparisons.clear();
        }
        frame = 0;
    }

    /**
     * Method for producing the required results regarding the BST performance
     * @param numbers Vector Containing the numbers to be inserted
     * @param avgIns Vector containing the averages for BST insertions
     * @param avgSearch Vector containing the averages for BST searches
     * @param avgDel Vector containing the averages for BST deletions
     */
    public static void doBST(Vector<Integer> numbers, Vector<Double> avgIns,
                      Vector<Double> avgSearch, Vector<Double> avgDel){
        Vector<Integer> comparisons = new Vector<>();
        BinarySearchTree bst = new BinarySearchTree();

        for (int i = 100; i <= nums; i += 100) {
            for(int j=frame;j<i;j++){
                comparisons.add(bst.insert(numbers.get(j)));
            }
            frame = i;
            avgIns.add((double) getSum(comparisons) / 100);
            comparisons.clear();

            List<Integer> subNums = numbers.subList(0,i);
            Vector<Integer> randNums = getRandom(subNums, samples);
            for(Integer num: randNums){
                comparisons.add(bst.find(num));
            }
            avgSearch.add((double) getSum(comparisons) / samples);
            comparisons.clear();

            randNums = getRandom(subNums, samples);
            for(Integer num: randNums){
                comparisons.add(bst.delete(num));
            }
            avgDel.add((double) getSum(comparisons) / samples);
            comparisons.clear();
        }
    }

    /**
     * Inserts each time 100 more numbers from the numbers Vector and places the comparisons done in the provided vector
     * @param numbers Vector containing the numbers to be inserted
     * @param comps Vector for placing the comparisons
     * @param n How many numbers to input IN TOTAL!
     */
    public static void insert(Vector<Integer> numbers, Vector<Integer> comps, int n){
        for(int i=frame;i<n;i++){
            // System.out.printf("Inserting: %d -> Comps: %d\n", num, HT.insert(num));
            comps.add(HT.insert(numbers.get(i)));
        }
    }

    /**
     * Reads the filename and fills up a vector with read numbers
     * @param fileName filename to be read
     * @param numbers   vector to place in the numbers
     */
    public static void readNums(String fileName, Vector<Integer> numbers){
        byte[] intReadBytes = new byte[4];
        try {
            BufferedInputStream inputStream = new BufferedInputStream(new FileInputStream(fileName));
            for(int i=0;i<nums;i++){
                if(inputStream.read(intReadBytes)== -1){
                    System.out.println("Read 0 Bytes!");
                }
                int x = ByteBuffer.wrap(intReadBytes).order(ByteOrder.BIG_ENDIAN).getInt();
                numbers.add(x);
            }
            inputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Create a new Vector consisting of randD numbers
     * randomly taken from the provided list
     * @param nums List of Integers
     * @param randN How many numbers to append
     * @return A Vector with the random Numbers
     */
    public static Vector<Integer> getRandom(List<Integer> nums, int randN) {
        Vector<Integer> randomNums = new Vector<>();
        Random rnd = new Random();
        for(int i=0;i<randN;i++){
            randomNums.add(nums.get(rnd.nextInt(nums.size())));
        }
        return randomNums;
    }

    /**
     * Searches for n numbers in the provided list and appends all comparisons
     * in the Vector for each numbers searched
     * @param nums Passed over to {@link #getRandom(List, int)}
     * @param comps Vector to place all comparisons into
     * @param n How many searches to perform
     */
    public static void search(List<Integer> nums, Vector<Integer> comps, int n){
        Vector<Integer> randNumbers = getRandom(nums, n);
        for(int num: randNumbers){
            comps.add(HT.search(num));
        }
    }

    /**
     * Same methodology as {@link #search(List, Vector, int)} however this method deletes
     * @param nums Passed over to {@link #getRandom(List, int)}
     * @param comps Vector to place all comparisons into
     * @param n How many deletions to perform
     */
    public static void delete(List<Integer> nums, Vector<Integer> comps, int n){
        Vector<Integer> randNumbers = getRandom(nums, n);
        for(int num: randNumbers){
            comps.add(HT.remove(num));
        }
    }


    /**
     * Exports the provided Vectors into a simple MatLab script for creating graphs
     * @param avgI05 Vector containing the averages for insertions w/ split condition @ 50%
     * @param avgI08 Vector containing the averages for insertions w/ split condition @ 80%
     * @param avgS05 Vector containing the averages for searching w/ split condition @ 50%
     * @param avgS08 Vector containing the averages for searching w/ split condition @ 80%
     * @param avgD05 Vector containing the averages for deletions w/ split condition @ 50%
     * @param avgD08 Vector containing the averages for deletions w/ split condition @ 80%
     */
    public static void exportML(Vector<Double> avgI05, Vector<Double> avgI08, Vector<Double> avgS05,
                                Vector<Double> avgS08, Vector<Double> avgD05, Vector<Double> avgD08,
                                Vector<Double> avgBstI, Vector<Double> avgBstS, Vector<Double> avgBstD){

        try{
            FileWriter writer = new FileWriter("graphs_1.m", false);
            BufferedWriter bufferedWriter = new BufferedWriter(writer);
            bufferedWriter.write("clear all;\n" +
                    "close;\n\n" +
                    "n = 100:100:10000;\n\n" +
                    "comps_insert_0_5 = " + avgI05.toString() + ";\n" +
                    "comps_insert_0_8 = " + avgI08.toString() + ";\n" +
                    "comps_search_0_5 = " + avgS05.toString() + ";\n" +
                    "comps_search_0_8 = " + avgS08.toString() + ";\n" +
                    "comps_del_0_5 = " + avgD05.toString() + ";\n" +
                    "comps_del_0_8 = " + avgD08.toString() + ";\n" +
                    // "comps_insert_BST = " + avgBstI.toString() + ";\n" +
                    // "comps_search_BST = " + avgBstS.toString() + ";\n" +
                    // "comps_delete_BST = " + avgBstD.toString() + ";\n\n" +
                    // "hold on;\n" +
                    // "plot(n, comps_insert_BST, 'blue');\n" +
                    // "plot(n, comps_search_BST, 'red');\n" +
                    // "plot(n, comps_delete_BST, 'green');\n" +
                    // "title(\"Binary Search Tree\");\n" +
                    // "xlabel('# of elements');\n" +
                    // "ylabel('Avg Comparisons');\n"+
                    // "legend('Insertion', 'Search','Deletion');\n\n" +
                    "figure();\n" +
                    "hold on;\n" +
                    "plot(n, comps_insert_0_5, 'blue');\n" +
                    "plot(n, comps_search_0_5, 'red');\n" +
                    "plot(n, comps_del_0_5, 'green');\n" +
                    "ylim([0 7]);\n" +
                    "title(\"Linear Hashing Split @ >50% LF and Merge @ <50% LF\");\n" +
                    "xlabel('# of elements');\n" +
                    "ylabel('Avg Comparisons');\n" +
                    "legend('Insertion', 'Search','Deletion');\n\n" +
                    "figure();\n" +
                    "hold on;\n" +
                    "plot(n, comps_insert_0_8, 'blue');\n" +
                    "plot(n, comps_search_0_8, 'red');\n" +
                    "plot(n, comps_del_0_8, 'green');\n" +
                    "ylim([0 7]);\n" +
                    "title(\"Linear Hashing Split @ >80% LF and Merge @ <50% LF\");\n" +
                    "xlabel('# of elements');\n" +
                    "ylabel('Avg Comparisons');\n" +
                    "legend('Insertion', 'Search','Deletion');\n");
            bufferedWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Prints a table with all information gathered
     * @param avgI05 Vector containing the averages for insertions w/ split condition @ 50%
     * @param avgI08 Vector containing the averages for insertions w/ split condition @ 80%
     * @param avgS05 Vector containing the averages for searching w/ split condition @ 50%
     * @param avgS08 Vector containing the averages for searching w/ split condition @ 80%
     * @param avgD05 Vector containing the averages for deletions w/ split condition @ 50%
     * @param avgD08 Vector containing the averages for deletions w/ split condition @ 80%
     * @param avgBstI Vector containing the averages for BST insertions
     * @param avgBstS Vector containing the averages for BST searches
     * @param avgBstD Vector containing the averages for BST deletions
     */
    public static void printRes(Vector<Double> avgI05, Vector<Double> avgI08, Vector<Double> avgS05,
                         Vector<Double> avgS08, Vector<Double> avgD05, Vector<Double> avgD08, Vector<Double> avgBstI,
                                Vector<Double> avgBstS, Vector<Double> avgBstD){

        System.out.println("--------------------------------------------------------------------------------------------" +
                "------------------------------------------------------------------------------");
        System.out.printf("%16s %16s %16s %16s %16s %16s %16s %16s %16s %16s", "Input Size(N)", "LH u>50%", "LH u>50%",
                "LH u>50%", "LH u>80%","LH u>80%", "LH u>80%", "BST", "BST", "BST\n");
        System.out.printf("%16s %16s %16s %16s %16s %16s %16s %16s %16s %16s", "", "avg#", "avg#", "avg#", "avg#", "avg#"
                , "avg#", "avg#", "avg#", "avg#\n");
        System.out.printf("%16s %16s %16s %16s %16s %16s %16s %16s %16s %16s", "", "comparisons", "comparisons", "comparisons"
                , "comparisons", "comparisons", "comparisons", "comparisons", "comparisons", "comparisons\n");
        System.out.printf("%16s %16s %16s %16s %16s %16s %16s %16s %16s %16s", "", "per insertion", "per insertion", "per insertion"
                , "per insertion", "per insertion", "per insertion", "per insertion", "per insertion", "per insertion\n");
        System.out.println("--------------------------------------------------------------------------------------------" +
                "------------------------------------------------------------------------------");
        for(int i=0;i<100;i++){
            System.out.printf("%16d %16.2f %16.2f %16.2f %16.2f %16.2f %16.2f %16.2f %16.2f %16.2f\n",
                    (i+1)*100, avgI05.get(i), avgS05.get(i), avgD05.get(i), avgI08.get(i), avgS08.get(i), avgD08.get(i),
                    avgBstI.get(i), avgBstS.get(i), avgBstD.get(i));
        }

    }

    /**
     * Sums up provided vector of Integers and returns the sum
     * @param vector Vector containing Integers
     * @return Sum of vector
     */
    public static int getSum(Vector<Integer> vector){
        int sum = 0;
        for(Integer num: vector){
            sum += num;
        }
        return sum;
    }
}
