#!/usr/bin/python3
import sys
from Classes.Linked_List import Linked_List
from Classes.Index_creator import Index_creator
import os
import math

MIN_SIZE = 3
MAX_SIZE = 20
PAGE_SIZE = 128
LINE_SIZE = 80

def write_file(fn, head): 
    """Method for Writing everything from the Linked List starting from the HEAD
    
    Args:
        fn (String): Filename 
        head (Node): List's Head
    """    
    node = head
    with open(fn, 'w') as f:
        while node is not None:
            f.write(node.data)
            if node.data == '\n':
                node = node.next
                continue
            f.write('\n')
            node = node.next

def sanitize_chunk(chunk, word_size):
    """Method for sanitizing the chunk read from the indexing file. 
    it takes the chunk (sector) and splits it into word_size pieces.
    then seperates the word and line number, throwing away the padding
    
    Args:
        chunk (bytes): Sector
        word_size (Int): Variable maximum word size
    
    Returns:
        List: List containing a list of word - line pair [[w, l], [w, l], ... [w, l]]
    """    
    sanitized_contx = []
    contx = [chunk[i:i + word_size + 4] for i in range(0, len(chunk), word_size + 4)]
    try:
        for cont in contx:
            if cont == b'':
                break
            page_word = cont[0:word_size].decode('ascii').strip('\0')
            word_line = cont[word_size:-1]
            tup = [page_word, int.from_bytes(word_line, 'little')]
            sanitized_contx.append(tup)
    except UnicodeDecodeError as e:
        print(e)
    return sanitized_contx

def get_page(f,offset):
    """Method for seeking to specific location in file and reading/sanitizing a page
    (Invokes the sanitize_chunk() method)
    
    Args:
        f (FD): File Descriptor of opened file
        offset (Int): Offset in file in pages
    
    Returns:
        List: See sanitize_chunk() info
    """    
    f.seek(PAGE_SIZE * offset)
    page = f.read(PAGE_SIZE)
    return sanitize_chunk(page, MAX_SIZE)

def prep_search(file, word):
    """Method for opening file and using Binary Search find a word that's contained 
    in said indexing file
    
    Args:
        file (String): Indexing file
        word (String): Word to be searched
    
    Returns:
        List: A list containing every line that contains said word
    """    
    f = open(file, 'rb')
    flag = True
    l = []
    pages = os.path.getsize(file)//PAGE_SIZE
    start = 0
    pitm = 0
    end = pages
    page_count = 1
    while flag:
        pitm = math.ceil((start + end-1)/2)
        if start >= end:
            print("Word not Found")
            break
        page = get_page(f,pitm)
        page_count += 1
        first = page[0][0]
        last = page[len(page)-1][0]
        flag = check_page(f,word, pitm, l)
        if not flag:
            break
        if word < first:
            end = pitm-1
        elif word > last:
            start = pitm+1
        elif flag:
            print("Word not Found")
            break
    page = pitm - 1
    while not flag:
        # go left until no words are found
        flag = check_page(f, word, page, l)
        page_count += 1
        page -= 1
    flag = False
    page = pitm + 1
    while not flag:
        # go right until no words are found
        flag = check_page(f,word, page, l)
        page_count += 1
        page += 1
    l.sort()
    return page_count, l

def check_page(f,word, offset, l):
    """Invoked by prep_search() it invokes get_page()
    It traveses through the list provided from get_page() and check if the said word appears AT LEAST once
    If thats the case it appends it to the list `l` and returns with False
    
    Args:
        f (FD): FD
        word (String): Word to be searched
        offset (Int): File offset in Pages
        l (List): List to append mathing words
    
    Returns:
        Bool: Flag that if word has NOT been found
    """    
    page = get_page(f,offset)
    flag = True
    for el in page:
        if el[0] == word:
            l.append(el[1])
            flag = False
    return flag

def populate(list, filename):
    """Populates a Linked list with text from a file. Takes into account the maximum line length
        Splits the line into LINE_SIZE chunks 
    
    Args:
        list (Linked_List): Linked List 
        filename (String): Filename
    
    Returns:
        Linked_List: The populated List (python automatically passes pointers. So effectively thats a pointer
                    and not the whole size of the list)
    """
    with open(filename) as f:
        line = f.readline()
        while line != '':
            if len(line) > LINE_SIZE:
                list.append(str(line[0:LINE_SIZE]))
            else:
                list.append(str(line.strip('\n')))
            line = f.readline()
    return list

def main(file=False):
    """Provides the interface for the user. In any case of argument given or not the programm checks if the file exists
    The direct replacement for case/switch in python is either a dictionary of if/else. Since i wanted to avoid having
    one function for each dictionary key i opted for if/else
    The only available command when the list is empty is `a` and that makes
    the new node HEAD
    
    Args:
        file (bool, optional): Tells the programm if user has specified a file name. Defaults to False.
    """    
    filename = ""
    list = Linked_List()
    if file:
        filename = sys.argv[1]
        if os.path.exists(filename):
            populate(list, filename)
        else:
            print("File Does not Exist!")
            sys.exit()
    elif not file:
        filename = str(input("Enter File name: "))
        if os.path.exists(filename):
            populate(list, filename)

    # grab lists head and set curr node as HEAD
    head = list.head
    node = head
    while True:
        head = list.head
        print("-> ", end='')
        cmd = input()
        if cmd == '^' and head is not None:
            # set curr node as head
            node = list.head
            print("OK.")
        elif cmd == '$' and head is not None:
            # set curr node as tail
            node = list.tail
            print("OK.")
        elif cmd == '-' and head is not None:
            # go up one node if available
            if node.prev is not None:
                node = node.prev
                print("OK.")
            else:
                print("Current Node is Head")
        elif cmd == '+' and head is not None:
            # go down one node if available
            if node.next is not None:
                node = node.next
                print("OK.")
            else:
                print("Current Node is Tail")
        elif cmd == 'a' :
            # insert something after curr node
            data = input("Please Enter some Data: ")
            node = list.insert_after(node, data)
            print("OK.")
        elif cmd == 't' and head is not None:
            # insert something before curr node
            data = input("Please Enter some Data: ")
            node = list.insert_before(node, data)
            print("OK.")
        elif cmd == 'd' and head is not None:
            # remove curr node and go UP
            node = list.remove_node(node)
            print("OK.")
        elif cmd == 'l' and head is not None:
            # print all nodes
            list.print_list()
        elif cmd == 'n' and head is not None:
            # toggle numbering in printing
            list.toggle()
            print("OK.")
        elif cmd == 'p' and head is not None:
            # print current node
            list.print_line(node)
        elif cmd == 'q':
            # JUST quit
            sys.exit()
        elif cmd == 'w' and head is not None:
            # JUST write
            write_file(filename, head)
            print("OK.")
        elif cmd == 'x' and head is not None:
            # write and Then exit
            write_file(filename, head)
            print("OK.")
            sys.exit()
        elif cmd == '=' and head is not None:
            # get current line number
            list.get_line(node)
        elif cmd == '#' and head is not None:
            list.get_stats()
            # get stats
        elif cmd == 'c' and head is not None:
            # create indexing file
            idx = Index_creator(MIN_SIZE, MAX_SIZE, PAGE_SIZE)
            pages = idx.create_idx_file(filename, head)
            print(f"Created -> {pages} pages of 128-bytes Each")
        elif cmd == 'v' and head is not None:
            # display the indexing file
            # since we wrote chunks of PAGE_SIZE bytes we need to read them back as such
            # sanitize the chunk so we are left with [w, l] pair
            f = open(filename + ".ndx", 'rb')
            print("-----------------------------")
            try:
                while True:
                    page = f.read(PAGE_SIZE)
                    if page == b'':
                        # if page read is 0 bytes we've reached EOF
                        break
                    else:
                        contx = sanitize_chunk(page, MAX_SIZE)
                        for el in contx:
                            if el[0] != '':
                                print(f"|{el[0]}{(MAX_SIZE-len(el[0])) * ' '} | {str(el[1]).zfill(2)} |")
                print("-----------------------------")
            except UnicodeDecodeError as e:
                print(e)
            f.close()
        elif cmd == 's' and head is not None:
            # serial search through the indexing file for specific word
            # same logic used wile displaying the indexing file
            page_count = 1
            word = input("Search for: ")
            l = []
            f = open(filename + ".ndx", "rb")
            while True:
                page = f.read(PAGE_SIZE)
                page_count += 1
                if page == b'':
                    # EOF
                    break
                # lines = [page[i:i + MAX_SIZE + 4] for i in range(0, len(page), MAX_SIZE+4)]
                # we have sanitize_chunk() now. using that
                contx = sanitize_chunk(page, MAX_SIZE)
                for line in contx:
                    if line == b'':
                        # last entry in page
                        break
                    else:
                        # line_str = line[0:20].decode('ascii').strip('\0')
                        # line_num = int.from_bytes(line[20:-1], 'little')
                        line_str = line[0]
                        line_num = line[1]
                        if line_str == word:
                            l.append(line_num)
            f.close()
            l.sort()
            print(f'Word "{word}" is found on lines {[line for line in l]} for a total of {len(l)} times')
            print(f"Disk accessed {page_count} times")
        elif cmd == 'b' and head is not None:
            # binary search through the indexing file for specific word
            word = input("Search for: ")
            page_count, l = prep_search(filename + ".ndx", word)
            print(f'Word "{word}" is found on lines {[line for line in l]} for a total of {len(l)} times')
            print(f"Page Accessed {page_count} times")
        elif head is None:
            print("Try adding some stuff first!")
        else:
            print("bad command")


if __name__ == "__main__":
    """Entry point. Sets up arguments and global variables. Alternative one can edit manually the global variables 
    """
    if len(sys.argv) > 2:
        print("Usage ./main.py filename")
        sys.exit()
    try:
        print(f"Minimum Word Indexing Size is {MIN_SIZE}")
        print(f"Maximum Word Indexing Size is {MAX_SIZE}")
        print(f"Sector Size is {PAGE_SIZE}")
        print(f"Maximum Line Size is {LINE_SIZE}")
        ch = input("Would you like to change them? [y/N]: ")
        if ch == 'y':
            try:
                MIN_SIZE = int(input("Minimum Word Indexing Size is: "))
                MAX_SIZE = int(input("Maximum Word Indexing Size is: "))
                PAGE_SIZE = int(input("Sector Size is: "))
                LINE_SIZE = int(input("Line Size is: "))
            except ValueError:
                print("Enter Integers ONLY!!")
                sys.exit()
        if len(sys.argv) == 1:
            main()
        main(file=True)
    except KeyboardInterrupt:
        print("Keyboard Interrupt")
        sys.exit()
