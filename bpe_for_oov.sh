#!/bin/bash

# inputs: train.src, train.trg, [dev.src, dev.trg,] test.src, test.trg, 
#         [num_operations]

# number of operations
NUM_OPERATIONS=10000
if [ $# -eq 7 ]  # dev set data and operation num provided
then
	NUM_OPERATIONS=$7
fi

if [ $# -eq 5 ]  # dev set data not provided, operation num provided
then
	NUM_OPERATIONS=$5
fi

# create a dir
TIME=`date "+%Y-%m-%d_%H:%M:%S"`
DIR="data_with_bpe_"$TIME
sudo mkdir $DIR
sudo chmod 777 $DIR

# bpe
CODES=$DIR/codes
TRAIN_SRC_VOCAB=$DIR/train.src.vocab
TRAIN_TRG_VOCAB=$DIR/train.trg.vocab

ORIGINAL_TRAIN_SRC=$1
ORIGINAL_TRAIN_TRG=$2
ORIGINAL_DEV_SRC=$3
ORIGINAL_DEV_TRG=$4
ORIGINAL_TEST_SRC=$5
ORIGINAL_TEST_TRG=$6
if [ $# -eq 4 -o $# -eq 5 ]  # dev set data 
then
	ORIGINAL_TEST_SRC=$3
	ORIGINAL_TEST_TRG=$4
fi

TRAIN_SRC=$DIR/train.src
TRAIN_TRG=$DIR/train.trg
DEV_SRC=$DIR/dev.src
DEV_TRG=$DIR/dev.trg
TEST_SRC=$DIR/test.src
TEST_TRG=$DIR/test.trg

subword-nmt learn-joint-bpe-and-vocab -i $ORIGINAL_TRAIN_SRC $ORIGINAL_TRAIN_TRG \
	-s $NUM_OPERATIONS \
        -o $CODES \
        --write-vocabulary $TRAIN_SRC_VOCAB $TRAIN_TRG_VOCAB

subword-nmt apply-bpe -c $CODES --vocabulary $TRAIN_SRC_VOCAB -i $ORIGINAL_TRAIN_SRC -o $TRAIN_SRC
subword-nmt apply-bpe -c $CODES --vocabulary $TRAIN_TRG_VOCAB -i $ORIGINAL_TRAIN_TRG -o $TRAIN_TRG

if [ $# -eq 6 -o $# -eq 7 ]  # dev set data provided
then
	subword-nmt apply-bpe -c $CODES --vocabulary $TRAIN_SRC_VOCAB -i $ORIGINAL_DEV_SRC -o $DEV_SRC
	subword-nmt apply-bpe -c $CODES --vocabulary $TRAIN_TRG_VOCAB -i $ORIGINAL_DEV_TRG -o $DEV_TRG
fi

subword-nmt apply-bpe -c $CODES --vocabulary $TRAIN_SRC_VOCAB -i $ORIGINAL_TEST_SRC -o $TEST_SRC
subword-nmt apply-bpe -c $CODES --vocabulary $TRAIN_TRG_VOCAB -i $ORIGINAL_TEST_TRG -o $TEST_TRG

