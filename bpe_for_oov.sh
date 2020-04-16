#!/bin/bash

# inputs: train.src, train.trg, dev.src, dev.trg, test.src, test.trg, 
#         [num_operations]

NUM_OPERATIONS=10000
if [ $# -eq 7 ]
then
	NUM_OPERATIONS=$7
fi

DIR = data_with_bpe
sudo mkdir $DIR

subword-nmt learn-joint-bpe-and-vocab -i $1 $2 \
	-s NUM_OPERATIONS \
        -o $DIR/codes \
        --write-vocabulary $DIR/$1.vocab $DIR/$2.vocab

subword-nmt apply-bpe -c codes --vocabulary $DIR/$1.vocab -i $1 -o $DIR/train.src
subword-nmt apply-bpe -c codes --vocabulary $DIR/$2.vocab -i $2 -o $DIR/train.trg

subword-nmt apply-bpe -c codes --vocabulary $DIR/$1.vocab -i $3 -o $DIR/dev.src
subword-nmt apply-bpe -c codes --vocabulary $DIR/$2.vocab -i $4 -o $DIR/dev.trg

subword-nmt apply-bpe -c codes --vocabulary $DIR/$1.vocab -i $5 -o $DIR/test.src
subword-nmt apply-bpe -c codes --vocabulary $DIR/$2.vocab -i $6 -o $DIR/test.trg

