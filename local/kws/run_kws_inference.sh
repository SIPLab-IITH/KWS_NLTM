#!/usr/bin/env bash
# Copyright (c) 2018, Johns Hopkins University (Yenda Trmal <jtrmal@gmail.com>)
# License: Apache 2.0

# Begin configuration section.
flen=0.01
stage=0
cmd=run.pl
data=$1
lang=$2
decode_dir=$3
keywords=$data/../keywords.txt
output=$data/kws/


# End configuration section

. ./utils/parse_options.sh
. ./path.sh

set -e -o pipefail
set -o nounset                              # Treat unset variables as an error

mkdir -p $output
if [ $stage -le 1 ] ; then
  ## generate the auxiliary data files
  ## utt.map
  ## wav.map
  ## trials
  ## frame_length
  ## keywords.int

  ## For simplicity, we do not generate the following files
  ## categories

  ## We will generate the following files later
  ## hitlist
  ## keywords.fsts

  [ ! -f $data/utt2dur ] &&
    utils/data/get_utt2dur.sh $data

  duration=$(cat $data/utt2dur | awk '{sum += $2} END{print sum}' )

  echo $duration > $output/trials
  echo $flen > $output/frame_length

  echo "Number of trials: $(cat $output/trials)"
  echo "Frame lengths: $(cat $output/frame_length)"

  echo "Generating map files"
  cat $data/utt2dur | awk 'BEGIN{i=1}; {print $1, i; i+=1;}' > $output/utt.map
  cat $data/wav.scp | awk 'BEGIN{i=1}; {print $1, i; i+=1;}' > $output/wav.map

  cp $lang/words.txt $output/words.txt
  cp $keywords $output/keywords.txt
  cat $output/keywords.txt | \
    local/kws/keywords_to_indices.pl --map-oov 1  $output/words.txt | \
    sort -u > $output/keywords.int
fi




if [ $stage -le 2 ] ; then
  ## this steps generates the file keywords.fsts

  ## compile the keywords (it's done via tmp work dirs, so that
  ## you can use the keywords filtering and then just run fsts-union
  local/kws/compile_keywords.sh $output $lang  $output/tmp.2 
  cp $output/tmp.2/keywords.fsts $output/keywords.fsts
  # for example
  #    fsts-union scp:<(sort data/$dir/kwset_${set}/tmp*/keywords.scp) \
  #      ark,t:"|gzip -c >data/$dir/kwset_${set}/keywords.fsts.gz"
  ##
fi



if [ $stage -le 3 ]; then
  ## find the hits, normalize and score
  local/kws/search.sh --cmd "$cmd" --min-lmwt 8 --max-lmwt 14  \
    --indices-dir $decode_dir/kws_indices \
    $lang $data $decode_dir
fi

echo "Done"
