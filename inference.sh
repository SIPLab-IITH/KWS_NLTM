. path.sh
. cmd.sh


language=$1
keyword_list=$language/test/keywords.txt
wav_dir=$language/test
lang_dir=$language/lang
data_dir=$language/test/data_test
exp_dir=$data_dir/exp
decode_dir=$language/exp_baseline/chain/tdnn1g_sp/decode_dev_split_tdnn
mfcc_conf=conf/mfcc.conf
decode_cmd=run.pl
mfccdir=$data_dir/mfcc_data


tree_dir=$language/exp_baseline/chain${nnet3_affix}/tree_a_sp

# training chunk-options

chunk_width=140,100,160
# we don't need extra left/right context for TDNN systems.
chunk_left_context=0
chunk_right_context=0

frames_per_chunk=$(echo $chunk_width | cut -d, -f1)



rm -rf $data_dir
mkdir -p $data_dir
rm -rf $decode_dir

tmp=$language/tmp
mkdir -p $tmp
ls $wav_dir/*.wav > $tmp/flist
soxi -D $wav_dir/*.wav >$tmp/durations
cat $tmp/flist |rev | cut -d '/' -f1 |rev | cut -d '.' -f1 >$tmp/uttids
paste -d ' ' $tmp/uttids $tmp/durations >$tmp/durs
paste $tmp/uttids $tmp/flist > $data_dir/wav.scp
paste $tmp/uttids $tmp/uttids > $data_dir/utt2spk
paste $tmp/uttids $tmp/uttids > $data_dir/spk2utt
cat $tmp/durs | awk '{print $1 "\t" $1 "\t" 0 "\t" $2 }' > $data_dir/segments


for x in $data_dir ; do 
	steps/make_mfcc.sh --cmd "$train_cmd" --mfcc-config conf/mfcc_hires.conf --nj 1 $x $exp_dir/make_mfcc/$x $mfccdir || exit 1;
 	steps/compute_cmvn_stats.sh $x $exp_dir/make_mfcc/$x $mfccdir || exit 1;
 	utils/fix_data_dir.sh $x || exit 1;
done


steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj 1 \
      $data_dir $language/exp_baseline/nnet3/extractor \
      $language/test/ivectors


steps/nnet3/decode.sh \
      	  --acwt 1.0 --post-decode-acwt 10.0 \
      	  --extra-left-context 0 --extra-right-context 0 \
      	  --extra-left-context-initial 0 \
      	  --extra-right-context-final 0 \
      	  --frames-per-chunk $frames_per_chunk \
      	  --nj 1 --cmd "$decode_cmd"  --num-threads 4 \
      	  --online-ivector-dir $language/test/ivectors \
      	  $tree_dir/graph $data_dir $decode_dir || exit 1
      	  

echo "decoding done"
bash local/kws/run_kws_inference.sh $data_dir $lang_dir $decode_dir

echo "KWS_output"
cat $decode_dir/kws_12/results
cp $decode_dir/kws_12/results /home/ubuntu/Desktop/django_project/media/kws_"$language"_output.txt
