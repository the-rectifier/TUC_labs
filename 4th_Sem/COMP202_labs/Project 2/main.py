#! /usr/bin/python

"""Main program for creating the data and proccessing it
Sets up a few constants k0, k1 and 3 lists of random numbers used for the searches onwards
"""
from Array_BST.Bst_Array import Bst_Array
from Bst.Bst import Bst
from multiprocessing import Process, Queue, Pool
from timeit import default_timer as timer
import math
import time
import random
import os
import sys

rand_nums = [random.randint(-500_000, 500_000) for _ in range(100)]
rand_k0 = [random.randint(-500_000, 500_000) for _ in range(100)]
rand_k1 = [random.randint(-500_000, 500_000) for _ in range(100)]
time_start = timer()
# init constants
k_0 = 100
k_1 = 1000
flag = False

try:
    """Tries to import the required packages if failed asks the user to intall them and if yes then restars
    """
    # noinspection PyUnresolvedReferences
    import matplotlib.pyplot as plt
    # noinspection PyUnresolvedReferences
    from pandas import DataFrame

    flag = True
except ImportError as e:
    print(e)
    print("Unable to satisfy requirements, automatic graphs and exce sheet will not be generated")
    print("Would you like to install requirements now? y/n")
    if input() == 'y':
        os.system("pip install -r requirements.txt")
        os.execv(__file__, sys.argv)
    else:
        flag = False
        print("Requirements satisfied")
        pass


def array_bst(n, q=None):
    """creates an Array Based BST, populates it with test_ + n file and derrives the data required

    Args:
        n (Integer): Elements
        q (Queue, optional): Queue to communicate between multiple processes. Defaults to None.

    Returns:
        Dictionary: Returns a dictonary with the proper data
    """    
    search_times = []
    search_compares = []
    search_k0_compares = []
    search_k1_compares = []

    # create and populate
    arr = Bst_Array(n)
    compares, times = arr.populate()

    # sum up compares and times
    avg_compares = round(sum(compares) / n, 2)
    full_time = round(sum(times) * 1000, 2)

    # 100 random searches
    for num in rand_nums:
        search_compare_nth, search_time_nth = arr.search(num)
        search_times.append(search_time_nth)
        search_compares.append(search_compare_nth)

    # 100 random seaches (in range)
    for num in rand_k0:
        arr.search_range(num, k_0)
        search_k0_compares = arr.comps
    for num in rand_k1:
        arr.search_range(num, k_1)
        search_k1_compares = arr.comps

    avg_k0_compares = round(sum(search_k0_compares) / 100, 2)
    avg_k1_compares = round(sum(search_k1_compares) / 100, 2)
    avg_compares_search = round(sum(search_compares) / 100, 2)
    full_time_search = round(sum(search_times) * 1_000, 2)

    dic = {
        "avg_compares": avg_compares,
        "full_time": full_time,
        "avg_compares_search": avg_compares_search,
        "full_time_search": full_time_search,
        "avg_compares_k0": avg_k0_compares,
        "avg_compares_k1": avg_k1_compares}

    if q is not None:
        # Print the outpur and put the dictonary in the queue
        print(f"--------Array Based BST--------\n"
              f"Number of elements: {n}\n"
              f"Average Comparisons per insertion: {avg_compares}\n"
              f"Full Inserting Time: {full_time} ms\n"
              f"Average Comparisons for 100 random searches: {avg_compares_search}\n"
              f"Full 100 Random searches time: {full_time_search} ms\n"
              f"Average comparisons for K=100: {avg_k0_compares}\n"
              f"Average comparisons for K=1000: {avg_k1_compares}")
        q.put(dic)

    return dic


def tree(n, q=None):
    """Creates a Dynamicly Allocated BST and runs required tests to derrive the data

    Args:
        n (Integer): Elements 
        q (Queue, optional): Queue to communicate between parent process. Defaults to None.

    Returns:
        Dictionary: Dictionary with stats
    """    
    search_times = []
    search_compares = []
    search_k0_compares = []
    search_k1_compares = []

    # create and populate
    bst = Bst()
    compares, times = bst.populate(n)

    # sum up compares and times
    avg_compares = round(sum(compares) / n, 2)
    full_time = round(sum(times) * 1000, 2)

    # 100 random searches
    for num in rand_nums:
        search_compare_nth, search_time_nth = bst.search(num)
        search_times.append(search_time_nth)
        search_compares.append(search_compare_nth)

    # 100 random seaches (in range)
    for num in rand_k0:
        bst.search_range(num, k_0)
        search_k0_compares = bst.comps
        bst.comps = []
    for num in rand_k1:
        bst.search_range(num, k_1)
        search_k1_compares = bst.comps
        bst.comps = []

    avg_k0_compares = round(sum(search_k0_compares) / 100, 2)
    avg_k1_compares = round(sum(search_k1_compares) / 100, 2)
    avg_compares_search = round(sum(search_compares) / 100, 2)
    full_time_search = round(sum(search_times) * 1_000, 2)

    dic = {
        "avg_compares": avg_compares,
        "full_time": full_time,
        "avg_compares_search": avg_compares_search,
        "full_time_search": full_time_search,
        "avg_compares_k0": avg_k0_compares,
        "avg_compares_k1": avg_k1_compares}

    if q is not None:
        print(f"--------Dynamically Allocated BST--------\n"
              f"Number of elements: {n}\n"
              f"Average Comparisons per insertion: {avg_compares}\n"
              f"Full Inserting Time: {full_time} ms\n"
              f"Average Comparisons for 100 random searches: {avg_compares_search}\n"
              f"Full 100 Random searches time: {full_time_search} ms\n"
              f"Average comparisons for K=100: {avg_k0_compares}\n"
              f"Average comparisons for K=1000: {avg_k1_compares}")
        q.put(dic)

    return dic


def sorted_array(n, q=None):
    """Creates an array, populates it and then sorts it. also run required tests and derrive data

    Args:
        n (Integer): Elements
        q (Queue, optional): Queue for multiprocessing communication. Defaults to None.

    Returns:
        Dictionary: Derrived data
    """    
    array = []
    search_times = []
    search_compares = []
    search_compares_k0 = []
    search_compares_k1 = []
    with open("test_" + str(n), 'rb') as r:
        while True:
            bytes_read = r.read(4)
            if not bytes_read:
                break
            num = int.from_bytes(bytes_read, 'little', signed=True)
            array.append(num)

    array.sort()
    hi = len(array) - 1
    lo = 0

    # 100 random searches
    for num in rand_nums:
        search_compare_nth, search_time_nth = bin_search(num, array, hi, lo)
        search_times.append(search_time_nth)
        search_compares.append(search_compare_nth)

    for num in rand_k0:
        search_compares_k0.append(bin_search_range(array, hi, lo, num, num + k_0))
    for num in rand_k1:
        search_compares_k1.append(bin_search_range(array, hi, lo, num, num + k_1))

    avg_compares_search = round(sum(search_compares) / 100, 2)
    full_time_search = round(sum(search_times) * 1_000, 2)
    avg_k0_compares = round(sum(search_compares_k0) / 100, 2)
    avg_k1_compares = round(sum(search_compares_k1) / 100, 2)

    dic = {
        "avg_compares_search": avg_compares_search,
        "full_time_search": full_time_search,
        "avg_compares_k0": avg_k0_compares,
        "avg_compares_k1": avg_k1_compares
    }

    if q is not None:
        print(f"--------Sorted Array--------\n"
              f"Number of elements: {n}\n"
              f"Average Comparisons for 100 random searches: {avg_compares_search}\n"
              f"Full 100 Random searches time: {full_time_search} ms\n"
              f"Average comparisons for K=100: {avg_k0_compares}\n"
              f"Average comparisons for K=1000: {avg_k1_compares}")
        q.put(dic)

    return dic


def bin_search(n, array, hi, lo):
    """Binary search to locate a specific key in a sorted 1D array

    Args:
        n (Integer): Key to search
        array (List): Array with elements
        hi (Integer): Array's Length
        lo (Integer): Array's lower bound typically 0

    Returns:
        Integer, FLoat: Ammount of comparisons done and time spent
    """    
    count = 0
    start_time = timer()
    while True:
        mid = math.ceil((hi + lo) / 2)
        # print(mid)
        if lo >= hi:
            # print("Not found")
            time_diff = timer() - start_time
            return count, time_diff
        count += 1
        if array[mid] == n:
            time_diff = timer() - start_time
            return count, time_diff
        elif n > array[mid]:
            lo = mid + 1
        elif n < array[mid]:
            hi = mid - 1


def bin_search_range(array, hi, lo, min_r, max_r):
    """Same idea as the typicall binary search but this time as soon as we hit a number inside the specified
    range linearly check every element before and after if they meet the range requirements

    Args:
        array (List): Array of elements
        hi (Integer): Arrays's length
        lo (Integer): Array's lowest index typically 0
        min_r (Integer): lower bound
        max_r (Integer): upper bound

    Returns:
        Integer: Ammount of comparisons done
    """    
    count = 0
    while True:
        mid = math.ceil((hi + lo) / 2)
        if lo >= hi:
            return count
        count += 1
        if min_r <= array[mid] <= max_r:
            mid1 = mid
            while True:
                # going backwards
                if mid == 0 or array[mid] < min_r:
                    break
                if min_r <= array[mid]:
                    count += 1
                    mid -= 1
                else:
                    break
            while True:
                if mid1 == len(array) or array[mid] > max_r:
                    break
                if max_r >= array[mid1]:
                    count += 1
                    mid1 += 1
                else:
                    break
            return count
        elif array[mid] < min_r:
            lo = mid + 1
        elif array[mid] > max_r:
            hi = mid - 1


def full_array(nums):
    """Create the data for all test files
    Synchonously map the files into 3 processes and call the specific function
    and return their dictonaries containing the data

    Args:
        nums (List): Array of tests files

    Returns:
        List: A list returned by the pool with all the dictonaries contaning the data
    """    
    pool = Pool(processes=3)
    data_array = pool.map(array_bst, nums)
    # print(data_array)
    return data_array


def full_bst(nums):
    """exaclty the same idea as the above mentioned     

    Args:
        nums (List): Array of testfiles

    Returns:
        List: List of dictionaries
    """    
    pool = Pool(processes=3)
    data_bst = pool.map(tree, nums)
    # print(data_bst)
    return data_bst


def full_sorted_array(nums):
    """exaclty the same idea as the above mentioned     

    Args:
        nums (List): Array of testfiles

    Returns:
        List: List of dictionaries
    """
    pool = Pool(processes=3)
    data_sorted = pool.map(sorted_array, nums)
    # print(data_sorted)
    return data_sorted


if __name__ == "__main__":
    """Entry point of application 
    1.) Asynchronously run 3 processes with the largest test file and gather data for eatch data structure
    2.) Write the data into specified folder and if specified by user create Excel Sheet
    3.) Call the Full_ function for each data structure to create full data packages
    4,) Process the data from each data structure and write them to the specified file
    5.) If specified by the user plot the newly created data into graphs
    """

    full_flag = False
    if input("Would you like to generate New Graph data? (run for all files) y/n\n "
             "(Please allow up to a minute or more for processing all the files)\n") == 'y':
        full_flag = True
    else:
        print("Aprox: runtime 19 ~ 20 secs.")

    files = [10, 50, 100, 1000, 1_500, 5_000, 10_000, 15_000, 100_000, 500_000, 750_000, 1_000_000]
    array_q = Queue()
    tree_q = Queue()
    sorted_q = Queue()

    # do the 2 bsts and create the table
    p1 = Process(target=tree, args=(1_000_000, tree_q))
    p2 = Process(target=array_bst, args=(1_000_000, array_q))
    p3 = Process(target=sorted_array, args=(1_000_000, sorted_q))
    p3.start()
    p2.start()
    p1.start()
    p1.join()
    p2.join()
    p3.join()

    array_data = array_q.get()
    tree_data = tree_q.get()
    sorted_data = sorted_q.get()

    array_q.close()
    tree_q.close()
    sorted_q.close()

    c0 = ["Array Based BST", "Dynamically Allocated BST", "Sorted Array"]
    c1 = [array_data.get("avg_compares"), tree_data.get("avg_compares"), "N/A"]
    c2 = [array_data.get("full_time"), tree_data.get("full_time"), "N/A"]
    c3 = [array_data.get("avg_compares_search"), tree_data.get("avg_compares_search"),
          sorted_data.get("avg_compares_search")]
    c4 = [array_data.get("full_time_search"), tree_data.get("full_time_search"),
          sorted_data.get("full_time_search")]
    c5 = [array_data.get("avg_compares_k0"), tree_data.get("avg_compares_k0"), sorted_data.get("avg_compares_k0")]
    c6 = [array_data.get("avg_compares_k1"), tree_data.get("avg_compares_k1"), sorted_data.get("avg_compares_k1")]

    with open("RESULTS/table_10_6.data", 'w') as f:
        f.write(f"Array Based BST:\n"
                f'\tAVG Comparisons per insertion: {array_data.get("avg_compares")}\n'
                f'\tFull Insertion Time: {array_data.get("full_time")}\n'
                f'\tAVG Comparisons per Search: {array_data.get("avg_compares_seach")}\n'
                f'\tFull Search Time: {array_data.get("full_time_seach")}\n'
                f'\tAVG Comparisons per Ranged Search K=100: {array_data.get("avg_compares_k0")}\n'
                f'\tAVG Comparisons per Ranged Search K=1000: {array_data.get("avg_compares_k1")}\n'
                f'---------------------------------------------------------------\n'
                f"Dynamically Allocated BST:\n"
                f'\tAVG Comparisons per insertion: {tree_data.get("avg_compares")}\n'
                f'\tFull Insertion Time: {tree_data.get("full_time")}\n'
                f'\tAVG Comparisons per Search: {tree_data.get("avg_compares_seach")}\n'
                f'\tFull Search Time: {tree_data.get("full_time_seach")}\n'
                f'\tAVG Comparisons per Ranged Search K=100: {tree_data.get("avg_compares_k0")}\n'
                f'\tAVG Comparisons per Ranged Search K=1000: {tree_data.get("avg_compares_k1")}\n'
                f'---------------------------------------------------------------\n'
                f"Sorted Array:\n"
                f'\tAVG Comparisons per insertion: N/A\n'
                f'\tFull Insertion Time: N/A\n'
                f'\tAVG Comparisons per Search: {sorted_data.get("avg_compares_seach")}\n'
                f'\tFull Search Time: {sorted_data.get("full_time_seach")}\n'
                f'\tAVG Comparisons per Ranged Search K=100: {sorted_data.get("avg_compares_k0")}\n'
                f'\tAVG Comparisons per Ranged Search K=1000: {sorted_data.get("avg_compares_k1")}\n')
        print("\nCheck RESULTS/table_10_6.data for statistics regarding 10^6 elements")

    if flag:
        df = DataFrame({"METHOD": c0, "AVG COMPARISONS PER INS": c1, "FULL TIME FOR N INS (ms)": c2,
                        "AVG COMPARISONS PER RNDM SEARCH": c3, "FULL TIME FOR SEARCH (ms)": c4,
                        "AVG COMPARISONS RANGE 100": c5, "AVG COMPARISONS RANGE 1000": c6})
        df.to_excel("RESULTS/res.xlsx", sheet_name='sheet1', index=False)
        print("Check RESULTS folder for excel sheet!")

    end_time = timer()

    if full_flag:
        time.sleep(1)
        print("\nGathering data for the graphs...")
        print("Running the procedure for all files available...")

        compares_array = []
        compares_tree = []

        full_times_array = []
        full_times_tree = []

        compares_search_array = []
        compares_search_tree = []
        compares_search_sorted = []

        times_search_array = []
        times_search_tree = []
        times_search_sorted = []

        compares_k0_array = []
        compares_k0_tree = []
        compares_k0_sorted = []

        compares_k1_array = []
        compares_k1_tree = []
        compares_k1_sorted = []

        sorted_data = full_sorted_array(files)
        array_data = full_array(files)
        tree_data = full_bst(files)

        for i in range(len(files)):
            compares_array.append(array_data[i].get("avg_compares"))
            compares_tree.append(tree_data[i].get("avg_compares"))

            full_times_array.append(array_data[i].get("full_time"))
            full_times_tree.append(tree_data[i].get("full_time"))

            compares_search_array.append(array_data[i].get("avg_compares_search"))
            compares_search_tree.append(tree_data[i].get("avg_compares_search"))
            compares_search_sorted.append(sorted_data[i].get("avg_compares_search"))

            times_search_array.append(array_data[i].get("full_time_search"))
            times_search_tree.append(tree_data[i].get("full_time_search"))
            times_search_sorted.append(sorted_data[i].get("full_time_search"))

            compares_k0_array.append(array_data[i].get("avg_compares_k0"))
            compares_k0_tree.append(tree_data[i].get("avg_compares_k0"))
            compares_k0_sorted.append(sorted_data[i].get("avg_compares_k0"))

            compares_k1_array.append(array_data[i].get("avg_compares_k1"))
            compares_k1_tree.append(tree_data[i].get("avg_compares_k1"))
            compares_k1_sorted.append(sorted_data[i].get("avg_compares_k1"))

        with open("RESULTS/Graph_data.data", 'w') as f:
            f.write("For each file respectively: \n\n")
            for idx, file in enumerate(files):
                f.write(f"For {file} elements: \n")
                f.write("Array Based BST: \n"
                        f'\tAvg Comparisons per Insertions: {compares_array[idx]}\n'
                        f'\tFull Insertion Time: {full_times_array[idx]}\n'
                        f'\tAvg Comparisons per Search: {compares_search_array[idx]}\n'
                        f'\tFull Search Time: {times_search_array[idx]}\n'
                        f'\tAvg Comparisons per Ranged Search K=100 {compares_k0_array[idx]}\n'
                        f'\tAvg Comparisons per Ranged Search K=1000 {compares_k1_array[idx]}\n')
                f.write("------------------------------------------------------------\n")
                f.write("Dynamically Allocated BST: \n"
                        f'\tAvg Comparisons per Insertions: {compares_tree[idx]}\n'
                        f'\tFull Insertion Time: {full_times_tree[idx]}\n'
                        f'\tAvg Comparisons per Search: {compares_search_tree[idx]}\n'
                        f'\tFull Search Time: {times_search_tree[idx]}\n'
                        f'\tAvg Comparisons per Ranged Search K=100 {compares_k0_tree[idx]}\n'
                        f'\tAvg Comparisons per Ranged Search K=1000 {compares_k1_tree[idx]}\n')
                f.write("------------------------------------------------------------\n")
                f.write("Sorted Array: \n"
                        f'\tAvg Comparisons per Insertions: N/A\n'
                        f'\tFull Insertion Time: N/A\n'
                        f'\tAvg Comparisons per Search: {compares_search_sorted[idx]}\n'
                        f'\tFull Search Time: {times_search_sorted[idx]}\n'
                        f'\tAvg Comparisons per Ranged Search K=100 {compares_k0_sorted[idx]}\n'
                        f'\tAvg Comparisons per Ranged Search K=1000 {compares_k1_sorted[idx]}\n')
                f.write("*******************************************************************\n")
            print("Check RESULTS/Graph_data.data for the whole data")

        end_time = timer()
        if flag:
            # plot comparisons graph
            plt.plot(files, compares_array, 'blue', label="Array Based")
            plt.plot(files, compares_tree, 'red', label="D. Allocated")
            plt.title("Average Comparisons Per Insertion")
            plt.xlabel("Number of Elements")
            plt.legend()
            plt.savefig("RESULTS/AVG_CMP_INS.png")
            plt.show()

            # plot time graph
            plt.plot(files, full_times_array, 'blue', label="Array Based")
            plt.plot(files, full_times_tree, 'red', label="D. Allocated")
            plt.title("Full Insertion Time")
            plt.xlabel("Number of Elements")
            plt.legend()
            plt.savefig("RESULTS/FULL_TIME_INS.png")
            plt.show()

            # plot search comparisons graph
            plt.plot(files, compares_search_array, 'blue', label="Array Based")
            plt.plot(files, compares_search_tree, 'red', label="D. Allocated")
            plt.plot(files, compares_search_sorted, 'green', label="Sorted Array")
            plt.title("Avg Comparisons per Search")
            plt.xlabel("Number of Elements")
            plt.legend()
            plt.savefig("RESULTS/AVG_CMP_SEARCH.png")
            plt.show()

            # plot search time graph
            plt.plot(files, times_search_array, 'blue', label="Array Based")
            plt.plot(files, times_search_tree, 'red', label="D. Allocated")
            plt.plot(files, times_search_sorted, 'green', label="Sorted Array")
            plt.title("Full Searching Time ")
            plt.xlabel("Number of Elements")
            plt.legend()
            plt.savefig("RESULTS/FULL_TIME_SEARCH.png")
            plt.show()

            # plot avg comparisons k0
            plt.plot(files, compares_k0_array, 'blue', label="Array Based")
            plt.plot(files, compares_k0_tree, 'red', label="D. Allocated")
            plt.plot(files, compares_k0_sorted, 'green', label="Sorted Array")
            plt.title("Avg Comparisons for Ranged Search (K=100)")
            plt.xlabel("Number of Elements")
            plt.legend()
            plt.savefig("RESULTS/AVG_CMP_K0.png")
            plt.show()

            # plot avg comparisons k1
            plt.plot(files, compares_k1_array, 'blue', label="Array Based")
            plt.plot(files, compares_k1_tree, 'red', label="D. Allocated")
            plt.plot(files, compares_k1_sorted, 'green', label="Sorted Array")
            plt.title("Avg Comparisons for Ranged Search (K=1000)")
            plt.xlabel("Number of Elements")
            plt.legend()
            plt.savefig("RESULTS/AVG_CMP_K1.png")
            plt.show()

    print(f"DONE - {round(end_time - time_start,2)} sec")
