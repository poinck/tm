#!/usr/bin/python3

import os
import sys
import time
import datetime
import argparse
import configparser


DEBUG = False
RESET = False

# sensors
TS_INSIDE = "tests/inside" # /sys/bus/w1/devices/10-000802bce280/w1_slave
TS_OUTSIDE = "tests/outside" # /sys/bus/w1/devices/10-000802c2f07e/w1_slave

# files
TMLOG = "tests/tm.csv"
TMDAILY_PREFIX = "tests/tm_"
TMSUM = "tests/tm_sum.csv"
TM1 = "tests/tm_1.csv"


def get_arguments():
    global DEBUG
    global RESET
    global TS_INSIDE
    global TS_OUTSIDE
    global TMLOG
    global TM1
    global TMDAILY_PREFIX
    global TMSUM

    # parse commandline arguments
    parser = argparse.ArgumentParser(description="tmd - temperature measurement deamon")
    parser.add_argument('-v', '--verbose', help='enable debugging', action='count')
    parser.add_argument('-i', '--inside', help='one wire sensor file for inside temperature')
    parser.add_argument('-o', '--outside', help='one wire sensor file for outside temperature')
    parser.add_argument('-a', '--allcsv', help='path to tm.csv')
    parser.add_argument('-c', '--currentcsv', help='path to tm_1.csv')
    parser.add_argument('-d', '--dailycsv', help='prefix path to tm_<date>.csv')
    parser.add_argument('-s', '--sumcsv', help='path to tm_sum.csv')
    parser.add_argument('-r', '--reset', help='rewrite/reset daily temperature files and exit (DANGER)', action='count')
    args = vars(parser.parse_args())

    #print(args)

    if args["verbose"] is not None:
        if args["verbose"] > 0:
            DEBUG = True
    if args["reset"] is not None:
        if args["reset"] > 0:
            RESET = True
    if args["inside"] is not None:
        TS_INSIDE = args["inside"]
    if args["outside"] is not None:
        TS_OUTSIDE = args["outside"]
    if args["allcsv"] is not None:
        TMLOG = args["allcsv"]
    if args["currentcsv"] is not None:
        TM1 = args["currentcsv"]
    if args["dailycsv"] is not None:
        TMDAILY_PREFIX = args["dailycsv"]
    if args["sumcsv"] is not None:
        TMSUM = args["sumcsv"]


def read_t(ts):
    bad_t = "85000"

    ttt = None

    f = open(ts, "r")
    t = f.read()
    if DEBUG:
        print(t)
    if "YES" in t:
        if DEBUG:
            print("t is valid")
        tt = t.split("t=")
        tt = tt[1].split()
        if DEBUG:
            print(tt)
        if bad_t not in tt:
            if int(tt[0]) > -85000:
                ttt = tt
    f.close()

    return ttt


to = 0
ti = 0

def read_w1():
    global to
    global ti

    if DEBUG:
        print("read sensors:", TS_INSIDE, TS_OUTSIDE)

    # read inside temperature
    ti_t = read_t(TS_INSIDE)
    if DEBUG:
        print(ti_t)

    # read outside temperature
    to_t = read_t(TS_OUTSIDE)
    if DEBUG:
        print(to_t)

    if ti_t != None and to_t != None:
        if DEBUG:
            print("both sensors have valid values")
        ti = ti_t[0]
        to = to_t[0]


todays_t = []


def rewrite_tm():
    global todays_t

    ts = []
    sums = []
    lastday = ""

    fsum = open(TMSUM, "w")
    fsum.write("datum,innen_min,aussen_min,innen_max,aussen_max,innen_avg,aussen_avg\n")
    fsum.close()

    with open(TMLOG, "r") as f:
        for l in f:
            if "datum,innen,aussen\n" not in l:
                day = l.split(" ")[0]
                if lastday != "":
                    if day != lastday:
                        fdaily = open(TMDAILY_PREFIX + lastday + ".csv", "w")
                        fdaily.write("datum,innen,aussen\n")
                        fdaily.writelines(ts)
                        fdaily.close()

                        tm_sum = calculate_sum()
                        fsum = open(TMSUM, "a")
                        fsum.write(tm_sum + "\n")
                        fsum.close()

                        ts = []
                        todays_t = []
                        if DEBUG:
                            print("new file", TMDAILY_PREFIX + lastday + ".csv written")
                        lastday = day
                    else:
                        ts.append(l)
                        ll = l.split(",")
                        todays_t.append({"tag": lastday, "datum": ll[0], "innen": ll[1], "aussen": ll[2]})
                else:
                    lastday = day

    f.close()

    fdaily = open(TMDAILY_PREFIX + lastday + ".csv", "w")
    fdaily.write("datum,innen,aussen\n")
    fdaily.writelines(ts)
    fdaily.close()
    if DEBUG:
        print("new file", TMDAILY_PREFIX + lastday + ".csv written")
    tm_sum = calculate_sum()
    fsum = open(TMSUM, "a")
    fsum.write(tm_sum + "\n")
    fsum.close()


def write_tm():
    global todays_t

    today = datetime.datetime.today()
    timeformat = "%Y-%m-%d %H:%M:%S"
    n = today.strftime(timeformat)
    d_timeformat = "%Y-%m-%d"
    d = today.strftime(d_timeformat)
    if DEBUG:
        print("write to", TMLOG)
        print(n)

    # allcsv
    f = open(TMLOG, "a")
    f.write(n + "," + ti + "," + to + "\n")
    f.close()

    # currentcsv
    f1 = open(TM1, "w")
    f1.write(n + "," + ti + "," + to + "\n")
    f1.close()

    todays_t.append({"tag": d, "datum": n, "innen": ti, "aussen": to})


def write_tm_daily():
    global to
    global ti
    global todays_t

    today = datetime.datetime.today()
    timeformat = "%Y-%m-%d %H:%M:%S"
    n = today.strftime(timeformat)
    d_timeformat = "%Y-%m-%d"
    d = today.strftime(d_timeformat)

    empty_or_new = False
    try:
        f = open(TMDAILY_PREFIX + d + ".csv", "r")
        header = f.readline()
        if DEBUG:
            print("header:", header)
        if header != "datum,innen,aussen\n":
            empty_or_new = True
        f.close()
    except:
        empty_or_new = True
        if DEBUG:
            print("it seems, I need a new file")

    if empty_or_new:
        f = open(TMDAILY_PREFIX + d + ".csv", "w")
        f.write("datum,innen,aussen\n")
        f.close()

    # daylycsv
    f = open(TMDAILY_PREFIX + d + ".csv", "a")
    f.write(n + "," + ti + "," + to + "\n")
    f.close()

def clear_todays_t():
    global todays_t

    today = datetime.datetime.today()
    d_timeformat = "%Y-%m-%d"
    d = today.strftime(d_timeformat)

    if todays_t[0]["tag"] != d:
        # new day
        if DEBUG:
            print("clear todays_t")
        todays_t = []


def calculate_sum():
    tm_sum = None

    ti_min = int(todays_t[0]["innen"])
    ti_max = int(todays_t[0]["innen"])
    ti_avg = 0
    to_min = int(todays_t[0]["aussen"])
    to_max = int(todays_t[0]["aussen"])
    to_avg = 0
    i = 0
    for t in todays_t:
        tti = int(t["innen"])
        tto = int(t["aussen"])
        if tti < ti_min:
            ti_min = tti
        if tto < to_min:
            to_min = tto
        if tti > ti_max:
            ti_max = tti
        if tto > to_max:
            to_max = tto
        ti_avg += tti
        to_avg += tto
        i = i + 1
    ti_avg = int(ti_avg / i)
    to_avg = int(to_avg / i)

    tm_sum = todays_t[-1]["datum"] + "," + str(ti_min) + "," + str(to_min) + "," \
    + str(ti_max) + "," + str(to_max) + "," + str(ti_avg) + "," \
    + str(to_avg)

    return tm_sum


def write_tm_sum():
    today = datetime.datetime.today()
    timeformat = "%Y-%m-%d %H:%M:%S"
    n = today.strftime(timeformat)
    d_timeformat = "%Y-%m-%d"
    d = today.strftime(d_timeformat)

    f = open(TMSUM, "r")
    sums = f.readlines()
    f.close()
    lastsum = sums[-1]
    lastday = lastsum.split(" ")[0]

    if DEBUG:
        print("lastsum:", lastsum, "lastday:", lastday)

    tm_sum = calculate_sum()
    if tm_sum is not None:
        if DEBUG:
            print("tm_sum:", tm_sum)

        if lastday != d:
            # new day, new line
            if DEBUG:
                print("new day")
            sums.append(tm_sum)
        else:
            sums[-1] = tm_sum

        f = open(TMSUM, "w")
        f.writelines(sums)
        f.write("\n")
        f.close()


def read_tm_currentday():
    global todays_t

    today = datetime.datetime.today()
    d_timeformat = "%Y-%m-%d"
    d = today.strftime(d_timeformat)

    ts = []
    try:
        f = open(TMDAILY_PREFIX + d + ".csv", "r")
        ts = f.readlines()
        f.close()
    except:
        if DEBUG:
            print("problem with current day, is it monday?")

    for t in ts:
        if "datum,innen,aussen\n" not in t:
            tt = t.split(",")
            todays_t.append({"tag": d, "datum": tt[0], "innen": tt[1], "aussen": tt[2]})


def main():
    get_arguments()

    if DEBUG:
        print("debug enabled")
    if RESET:
        if DEBUG:
            print('will reset temperature files')
        rewrite_tm()
        sys.exit(0)

    read_tm_currentday()

    while True:
        read_w1()
        if DEBUG:
            print("inside =", ti, " outside =", to)

        write_tm()
        if DEBUG:
            #print(todays_t[-1])
            print("todays_t:", todays_t)

        write_tm_daily()

        write_tm_sum()

        clear_todays_t()

        time.sleep(60)


main()

