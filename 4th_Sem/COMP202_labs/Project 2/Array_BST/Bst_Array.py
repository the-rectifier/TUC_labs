from timeit import default_timer as timer

KEY = 0
LEFT = 1
RIGHT = 2
COLUMNS = 3


# noinspection PyTypeChecker,DuplicatedCode
class Bst_Array:
    """Class for creating and managing a Binary Tree using an array
    """    
    def __init__(self, n):
        """Tree constructor creates a 2D table with dimensions Nx3 and inits is at None
        After that it used the right Column as a "stack" depicting the row of the next value

        Args:
            n (Integer): Rows aka # of elements of the table
        """        
        self.ROWS = n
        self.array = [[None for _ in range(COLUMNS)] for _ in range(self.ROWS)]
        self.root_idx = None
        for i in range(self.ROWS-1):
            self.array[i][RIGHT] = i+1
        # print(len(self.pos))
        self.array[n-1][RIGHT] = None
        self.next_pos = 0
        self.comps = []
        self.comp = 0

    def get_next_pos(self):
        """Gets the next available posistion

        Returns:
            Integer: Next position
        """        
        return self.next_pos

    def print_stack(self):
        """Debug print of the stack
        """        
        for i in range(self.ROWS):
            print(f"{i} -> {self.array[i][RIGHT]}")

    # noinspection PyStringFormat
    def print_array(self):
        """Debug print of the whole tree
        """        
        for i in range(0, self.ROWS):
            print(i, " -> ", self.array[i][KEY], self.array[i][LEFT], self.array[i][RIGHT])

    def insert(self, key):
        """Method for inserting a new key in the Tree same logic applys for any BST however the index is given to us by the RIGHT most column

        Args:
            key (Integer): "Nodes" Key

        Returns:
            Integer, Float: returns the ammount of comparisons done and the elapsed time 
        """        
        compares = 0
        start_time = timer()
        if self.root_idx is None:
            self.root_idx = 0
            self.array[self.root_idx][KEY] = key
            self.next_pos = self.array[self.root_idx][RIGHT]
            self.array[self.root_idx][RIGHT] = None
            self.array[self.root_idx][LEFT] = None
        else:
            entry = self.root_idx
            while True:
                if self.next_pos is None:
                    print("Array is full. Exiting")
                    break
                if key > self.array[entry][KEY]:
                    compares += 1
                    if self.array[entry][RIGHT] is None:
                        # print(f"Creating New child RIGHT of {entry} @ {self.pos[0]}")
                        new_pos = self.next_pos
                        # print(new_pos)
                        self.array[entry][RIGHT] = new_pos
                        self.array[new_pos][KEY] = key
                        self.next_pos = self.array[new_pos][RIGHT]
                        self.array[new_pos][RIGHT] = None
                        self.array[new_pos][LEFT] = None
                        break
                    else:
                        # print(f"Moving to index {self.array[entry][RIGHT]}")
                        entry = self.array[entry][RIGHT]
                elif key <= self.array[entry][KEY]:
                    compares += 1
                    if self.array[entry][LEFT] is None:
                        # print(f"Creating New child LEFT of {entry} @ {self.pos[0]}")
                        new_pos = self.next_pos
                        # print(new_pos)
                        self.array[entry][LEFT] = new_pos
                        self.array[new_pos][KEY] = key
                        self.next_pos = self.array[new_pos][RIGHT]
                        self.array[new_pos][RIGHT] = None
                        self.array[new_pos][LEFT] = None
                        break
                    else:
                        # print(f"Moving to index {self.array[entry][LEFT]}")
                        entry = self.array[entry][LEFT]
        end_time = timer()
        return compares, end_time - start_time

    def populate(self):
        """Depending on the size of the Tree open the proper File and populate the Tree with N elements

        Returns:
            List, List: Returns a list with all the comparisons done for each insertion and a list with all the time it took for each
        """        
        # returns 2 arrays.
        # one with ammount for compares for inserting the ith num
        # the other is the time taken for that ith num
        nums = []
        comps = []
        times = []
        with open("test_" + str(self.ROWS), 'rb') as f:
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

        # print(f"Took {end_time - start_time} seconds to process {self.N} elements")

    def search(self, key):
        """Search for a speacific key and returns the ammount of comparisons done and the time spent

        Args:
            key (Integer): Key to be searched

        Returns:
            Integer, Float: Comparisons done and time spent
        """        
        count = 0
        entry = self.root_idx
        time_start = timer()
        while True:
            count += 1
            if entry is None:
                # print(f"Not found {key}")
                time_diff = timer() - time_start
                return count, time_diff
            if key > self.array[entry][KEY]:
                entry = self.array[entry][RIGHT]
            elif key < self.array[entry][KEY]:
                entry = self.array[entry][LEFT]
            elif key == self.array[entry][KEY]:
                time_diff = timer() - time_start
                return count, time_diff

    def print_io(self):
        """Method to init an inorder print
        """        
        if self.root_idx is None:
            print("Empty Tree")
            return
        else:
            entry = 0
            self._print_io(entry)
            # print()

    def _print_io(self, entry):
        """Recurse and print the entire tree inorder

        Args:
            entry (Integer): Starting index of the Tree
        """        
        if entry is None:
            return
        self._print_io(self.array[entry][LEFT])
        print(self.array[entry][KEY])
        self._print_io(self.array[entry][RIGHT])

    def print_range(self, min_r, max_r):
        """Same as before but print only in a given range

        Args:
            min_r (Integer): lower bound
            max_r (Integer): upper bound
        """        
        if self.root_idx is None:
            print("Empty Tree")
            return
        else:
            entry = 0
            self._print_range(entry, min_r, max_r)

    def _print_range(self, entry, min_r, max_r):
        """Recurse and print it

        Args:
            entry (Integer): Starting Index
            min_r (Integer): lower bound
            max_r (Integer): upper bound
        """        
        if entry is None:
            return

        if self.array[entry][KEY] < min_r:
            self._print_range(self.array[entry][RIGHT], min_r, max_r)
        if min_r <= self.array[entry][KEY] <= max_r:
            print(self.array[entry][KEY])
        if self.array[entry][KEY] > max_r:
            self._print_range(self.array[entry][LEFT], min_r, max_r)

    def search_range(self, num, k):
        """Same as the print range but with search

        Args:
            num (Integer): Key to be searched
            k (Integer): Range definition
        """        
        self.comp = 0
        self.comps = []
        if self.root_idx is None:
            print("Empty Tree")
            return
        else:
            entry = 0
            self._search_range(entry, num, num+k)

    def _search_range(self, entry, min_r, max_r):
        """Recurse and for each key that resides in that specific range append the comparisons up untill that to a list

        Args:
            entry (Integer): Starting Index
            min_r (Integer): lower bound
            max_r (Integer): upper bound
        """        
        if entry is None:
            self.comps.append(self.comp)
            return
        self.comp += 1
        if self.array[entry][KEY] < max_r:
            self._search_range(self.array[entry][RIGHT], min_r, max_r)
        if min_r <= self.array[entry][KEY] <= max_r:
            self.comps.append(self.comp)
        if self.array[entry][KEY] > min_r:
            self._search_range(self.array[entry][LEFT], min_r, max_r)
