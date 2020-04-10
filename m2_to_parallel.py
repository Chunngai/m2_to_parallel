#!/usr/bin/env python
# coding: utf-8

import sys
import re
import argparse
import os


def split_answer_by_annotator(in_file):
    annotator_id = '0'
    m2_content = ""

    with open(in_file) as input_file:
        for line in input_file:
            line = line.strip()
            if line.startswith('S'):
                S = line
                m2_content += f"{S}\n"
            elif line.startswith('A'):
                A = line
                if line.split('|||')[-1] == annotator_id:
                    m2_content += f"{A}\n"
                else:
                    annotator_id = line.split('|||')[-1]
                    m2_content += '\n'
                    m2_content += f"{S}\n"
                    m2_content += f"{A}\n"
            else:
                m2_content += '\n'

    return m2_content


def get_output_file_path(in_file, parallel_file_name):
    if parallel_file_name is None:
        return \
            os.path.join(os.path.dirname(in_file), '.'.join(os.path.basename(in_file).split('.', )[:-1]) + ".src"), \
            os.path.join(os.path.dirname(in_file), '.'.join(os.path.basename(in_file).split('.', )[:-1]) + ".trg")
    else:
        return f"{parallel_file_name}.src", f"{parallel_file_name}.trg"


def m2_to_parallel(in_file, parallel_file_name):
    out_src_file, out_trg_file = get_output_file_path(in_file, parallel_file_name)

    m2_content = split_answer_by_annotator(in_file)

    words = []
    corrected = []
    sid = eid = 0
    prev_sid = prev_eid = -1
    pos = 0

    with open(out_src_file, 'w') as output_src_file, open(out_trg_file, 'w') as output_trg_file:
        for line in m2_content.split('\n')[:-1]:
            line = line.strip()

            if line.startswith('S'):
                line = line[2:]
                words = line.split()
                corrected = ['<S>'] + words[:]
                output_src_file.write(line + '\n')
            elif line.startswith('A'):
                line = line[2:]
                info = line.split("|||")
                sid, eid = info[0].split()
                sid = int(sid) + 1
                eid = int(eid) + 1
                error_type = info[1]
                if error_type == "Um":
                    continue
                for idx in range(sid, eid):
                    corrected[idx] = ""
                if sid == eid:
                    if sid == 0:
                        continue  # Originally index was -1, indicating no op
                    if sid != prev_sid or eid != prev_eid:
                        pos = len(corrected[sid - 1].split())
                    cur_words = corrected[sid - 1].split()
                    cur_words.insert(pos, info[2])
                    pos += len(info[2].split())
                    corrected[sid - 1] = " ".join(cur_words)
                else:
                    corrected[sid] = info[2]
                    pos = 0
                prev_sid = sid
                prev_eid = eid
            else:
                target_sentence = ' '.join([word for word in corrected if word != ""])
                assert target_sentence.startswith('<S>'), '(' + target_sentence + ')'
                target_sentence = target_sentence[4:]
                output_trg_file.write(target_sentence + '\n')
                prev_sid = -1
                prev_eid = -1
                pos = 0


if __name__ == '__main__':
    # m2_to_csv("fce.train.gold.bea19.m2", "fce.train.gold.bea19.txt")
    # m2_to_csv("test.m2", "test.txt")

    parser = argparse.ArgumentParser(description="a tool for convert m2 files to parallel data")

    parser.add_argument("--src", "-s", action="store", required=True,
                        help="the src m2 file")
    parser.add_argument("--file-name", "-n", action="store", help="the name of the parallel files (without ext)")

    args = parser.parse_args()

    m2_to_parallel(args.src, args.file_name)