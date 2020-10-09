from string import punctuation

class Index_creator:
    """
    Class containing the method and parameters for creating the indexing file
    """
    def __init__(self, min1,max1,page):
        """Object's Constructor
        
        Args:
            min1 (Int): Minimum word size
            max1 (Int): Maximum word size
            page (Int): Sector Size
        """                       
        self.__min_size = min1
        self.__max_size = max1
        self.__page_size = page

    @property
    def min_size(self):
        """min_size Getter
        
        Returns:
            Int: Minimum word size
        """        
        return self.__min_size

    @min_size.setter
    def min_size(self, val):
        """min_size Setter (useless)
        
        Args:
            val (Int): Minimum word size
        """        
        self.__min_size = val

    @property
    def max_size(self):
        """max_size Getter

        Args:

        Returns:
          Int: Maximum Word Size

        """
        return self.__max_size

    @max_size.setter
    def max_size(self, val):
        """max_size Setter (useless)
        
        Args:
            val (Int): Maximum Word Size
        """        
        self.__max_size = val

    @property
    def page_size(self):
        """page_size Getter
        
        Returns:
            Int: Page Size(sector) in bytes
        """        
        return self.__page_size

    @page_size.setter
    def page_size(self, val):
        """page_size Setter (useless)
        
        Args:
            val (Int): Page Size(sector) in bytes
        """        
        self.__page_size = val

    def create_idx_file(self, file, node):
        """Method for creating an indexing file containing every possible word with length in between the parameters
        specified within the object. It Traveses the linked list taking every word that meets the req and adds it to
        a list along with its line number It then sorts the list alphabetically Finaly it writes chunks of page_size
        bytes w/ sector padding as null-bytes

           Note: Python's Int is a fully flegdeg object sized at 28 bytes so we need to grab only the first 4 bytes
           WITH endianess
        
        Args:
            file (String): Original File's Name
            node (Node): Head Node of the Linked list
        
        Returns:
            Int: Number of sectors created
        """
        bad_chars = punctuation
        chunk = bytearray()
        l = []
        count = 1
        chunk_count = 0
        # maximum `lines` to be written before sector overflow
        max_counts = self.__page_size // (self.__max_size + 4)
        # sector padding 
        padding = '\0' * (self.__page_size % self.__max_size)
        print("Page Data: ")
        print(f"Lines -> {max_counts}")
        print(f"Line length -> {self.__max_size + 4}")
        print(f"Padding size -> {len(padding)}")
        print(f"Total -> {max_counts * (self.__max_size + 4) + len(padding)}")
        while node is not None:
            words = node.data.split()
            for word in words:
                word = ''.join(c for c in word if c not in bad_chars)
                if self.__min_size <= len(word) <= self.__max_size:
                    l.append([word, count])
                elif len(word) > self.__max_size:
                    l.append([word[0:self.__max_size], count])
            node = node.next
            count += 1
        """
        words = node.data.split()
        count += 1
        for word in words:
            if self.__min_size <= len(word) <= self.__max_size:
                l.append([word.lower(), count])
        """
        count = 0
        l.sort(key=lambda x : x[0])
        f = open(file+".ndx", 'wb')
        for line in l:
            # word's padding to reach max_size in null-bytes
            word = line[0] + '\0' * (self.__max_size - len(line[0]))
            line_num = line[1].to_bytes(4, 'little')
            if (len(word) + len(line_num)) != 24:
                print("BAD LENGTH")
            if count != max_counts:
                # print(word.encode(), line_num)
                chunk.extend(word.encode('ascii'))
                chunk.extend(line_num)
                count += 1
                # we havent saturaded the sector keep extending the array
            else:
                # write the sector and also its padding then re-extend the array so we do not lose the read line
                chunk_count += 1
                f.write(chunk)
                f.write(padding.encode('ascii'))
                # sum1 += len(chunk) + len(padding)
                # print(sum1)
                count = 1
                chunk = bytearray()
                chunk.extend(word.encode('ascii'))
                chunk.extend(line_num)
        if len(chunk) > 0:
            # if sector has data in it after exiting then we have to write one final time
            # with new padding
            page_padding = '\0' * (self.__page_size - len(chunk))
            f.write(chunk)
            f.write(page_padding.encode('ascii'))
            chunk_count += 1
        f.close()
        return chunk_count


