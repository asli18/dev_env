#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from datetime import datetime
import time


def timedelta_to_string(td_seconds):
    h, m = divmod(td_seconds, 3600)
    m, s = divmod(m, 60)
    return '{0}h {1}m'.format(h, m)


def get_datetime_format(s):
    datetime_format = ''
    for _ in range(2):
        if _ == 0:
            datetime_format = '[%a %b %d %H:%M:%S.%f %Y]'
        elif _ == 1:
            datetime_format = '[%Y-%m-%d %H:%M:%S.%f]'

        try:
            datetime.strptime(s, datetime_format)
            break
        except ValueError:
            datetime_format = ''
    return datetime_format


def calc_log_elapsed_time(file_name):
    # err_symbol = ['error', 'ERR', 'Error', 'Fail', 'FAIL', 'fail', 'wrong']

    lines = []
    with open(file_name, 'r') as f:
        lines = f.readlines()

    last_valid_log_max = 4
    last_valid_log_done = None
    last_valid_log = []

    datetime_format = ''
    dt_s = None
    dt_e = None
    loops = None
    fail = False

    for line in reversed(lines):
        if len(line[line.find(']')+1:].strip()) == 0 and len(last_valid_log):
            last_valid_log_done = True

        if last_valid_log_done is None and\
                len(line[line.find(']')+1:].strip()) and\
                len(last_valid_log) < last_valid_log_max:
            last_valid_log.append(line[line.find(']')+1:].strip())

        if line.startswith('[') and datetime_format == '':
            datetime_format = get_datetime_format(line[:line.find(']')+1])

            dt_e = datetime.strptime(line[:line.find(']')+1], datetime_format)

        # if 'UART init ok' in line:
        #    dt_s = datetime.strptime(line[:line.find(']')+1], datetime_format)
        #    break

    for line in reversed(lines):
        if 'test_loop' in line:
            _ = line.split()[-1]
            # loops = int(_[_.find('=')+1:])
            # loops = int(_)
            loops = int(_, base=16)
            break

    for line in lines:
        if len(line[line.find(']')+1:].strip()) != 0:
            dt_s = datetime.strptime(line[:line.find(']')+1], datetime_format)
            break

    day_delta = abs((dt_e - dt_s).days)
    sec_delta = abs((dt_e - dt_s).seconds)

    td_seconds = (day_delta * 3600 * 24) + sec_delta

    print('start time:      {}'.format(dt_s.strftime('%Y-%m-%d %H:%M:%S')))
    print('end time:        {}'.format(dt_e.strftime('%Y-%m-%d %H:%M:%S')))

    print('\n{}'.format('Fail' if fail else 'Pass'))
    print('{}'.format(timedelta_to_string(td_seconds)))

    print('\nLoop = {}\n'.format(loops))

    if fail is False:
        for line in reversed(last_valid_log):
            if len(line):
                print(line)


def main():
    try:
        if len(sys.argv) < 2:
            print('enter file name: ', end='')
            file_name = input()
        else:
            file_name = sys.argv[1]

        calc_log_elapsed_time(file_name)
    except Exception as err:
        print(err)

    print('press C-c to exit...')
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
