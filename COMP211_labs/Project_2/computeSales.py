#!/usr/bin/python
import os
import sys
#import time
all_afms = {}

def sortem(x,y):
    x,y = (list(t) for t in zip(*sorted(zip(x,y))))
    return x,y

def pushem(afm, items, prices):
    global all_afms
    list_items = all_afms.get(afm).get("items")
    for item in items:
        if item in list_items:
            index = list_items.index(item)
            all_afms.get(afm).get("total_item")[index] += prices[items.index(item)]
            all_afms.get(afm).get("total_item")[index] = round(all_afms.get(afm).get("total_item")[index],2)
        else:
            all_afms.get(afm).get("total_item").append(prices[items.index(item)])
            all_afms.get(afm).get("items").append(item)


def GetAfmItemSum(afm):
    out = all_afms.get(afm)
    if out == None:
        menu()
    print_items = out.get("items")
    print_totals = out.get("total_item")
    try:
        print_items,print_totals = sortem(print_items,print_totals)
        for i in range(0, len(print_items)):
            print(print_items[i], print_totals[i])
    except ValueError as e:
        pass
    menu()
   
def GetItemSum(item):
    price = []
    afms = []
    flag = True
    for i in all_afms:
        if item in all_afms.get(i).get("items"):
            list1 = all_afms.get(i).get("items")
            index = all_afms.get(i).get("items").index(item)
            price.append(all_afms.get(i).get("total_item")[index])
            afms.append(i)
            flag = False
    if flag:
        menu()
    afms,price = sortem(afms,price)
    for i in range(0,len(afms)):
        print(afms[i], price[i])
    menu()

def readfile():
    filename = str(input("Enter Filename to read: "))
    if (os.path.exists(filename) == False):
        menu()
    process(filename)

def process(filename):
    global all_afms
    f = open(filename, "r", encoding="UTF-8")
    bad_rec = False
    honey_pot = 0
    items = []
    items_price = []
    line = f.readline()
    #pot = 0
    #pot2 = 0
    #start_time = time.time()
    while line != '':
        if line[0] == '-':
            bad_rec = False
            line = f.readline()
        elif line[:3] == "ΑΦΜ" and not bad_rec:
            chunk = line.split(" ")
            if len(chunk) != 2:
                #line = f.readline()
                bad_rec = True
                honey_pot = 0
                items = []
                items_price = []
                continue
            afm = chunk[1].strip("\n")
            if len(afm) != 10 or not afm.isdigit():
                #line = f.readline()
                bad_rec = True
                honey_pot = 0
                items = []
                items_price = []
                continue
            if all_afms.get(afm) == None:
                all_afms.update({afm:{"items": [], "total_item": []}})
            line = f.readline()
        elif line[:7] == "ΣΥΝΟΛΟ:" and not bad_rec:
            try:
                grand_total = round(float(line.split()[1].strip("\n")),2)
            except ValueError as e:
                #line = f.readline()
                bad_rec = True
                honey_pot = 0
                items = []
                items_price = []
                continue
            line = f.readline()
            if line[0] != '-':
                #line = f.readline()
                bad_rec = True
                honey_pot = 0
                items = []
                items_price = []
                continue
            if(honey_pot != grand_total):
                #line = f.readline()
                bad_rec = True
                honey_pot = 0
                items = []
                items_price = []
                continue
            #for item in items:
            #    if item == "ΠΟΙΚΙΛΙΑ" and afm == "1992576512":
            #        pot += items_price[items.index(item)]
            
            #items,items_price = sortem(items,items_price)
            pushem(afm,items,items_price)
            honey_pot = 0
            items = []
            items_price = []
        elif not bad_rec:
            chunk = line.split()
            if len(chunk) != 4:
                #line = f.readline()
                bad_rec = True
                honey_pot = 0
                items = []
                items_price = []
                continue
            try:
                item = chunk[0].strip(":").upper()
                quant = int(chunk[1])
                ppu = round(float(chunk[2]),2)
                item_total = round(float(chunk[3].strip("\n")),2)
            except ValueError as e:
                #line = f.readline()
                bad_rec = True
                honey_pot = 0
                items = []
                items_price = []
                continue
            x = round(quant*ppu,2)
            if x != item_total:
                #print(x)
                #print(item_total)
                #line = f.readline()
                bad_rec = True
                honey_pot = 0
                items = []
                items_price = []
                continue
            honey_pot += x
            if item in items:
                index = items.index(item)
                items_price[index] += x
                items_price[index] = round(items_price[index],2)
            else:
                items.append(item)
                items_price.append(item_total)
                #items,items_price = sortem(items,items_price)
            #print(*items)
            #print(*items_price)
            #if item == "ΠΟΙΚΙΛΙΑ" and afm == "1992576512":
            #    pot2 += x

            line = f.readline()
            honey_pot = round(honey_pot,2)
        else:
            line = f.readline()
            bad_rec = True
            honey_pot = 0
            items = []
            items_price = []
    #print(round(pot2,2))
    #print("--- READ IN %s seconds ---" % (time.time() - start_time))
    menu()

def getAfm():
    afm = str(input("Enter Afm: "))
    GetAfmItemSum(afm)

def getItem():
    item = str(input("Enter Item: ")).upper()
    GetItemSum(item)

def menu():
    opts = {1:readfile, 2:getItem, 3:getAfm}
    #for item in all_afms:
    #    print("Key : {} , Value : {}".format(item,all_afms[item]))
    print("1.) Read New Input File")
    print("2.) Print Statistics For Specific Product")
    print("3.) Print Statistics For Specific AFM")
    print("4.) Exit")
    x = input("[->] Make selection: ")
    if x.isnumeric():
        if int(x) > 4:
            menu()
        elif int(x) == 4:
            sys.exit()
        else:
            opts[int(x)]()
    else:
        menu()

if __name__ == "__main__":
    menu()
