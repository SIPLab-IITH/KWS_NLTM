#!/bin/bash
###### rttm file generation from ctm file

data_dir=$1
kws_dir=$2
align_dir=$3
wav_dir=$4

rm -rf tmp/new_ctm
for i in `cat conf/raw_keywords.txt`
do
grep " $i " $align_dir/ctm >>tmp/new_ctm
done
python3 local/rttm_generation.py $kws_dir

###### kwlist.xml generation from ctm file raw_keywords.txt

rm -rf $kws_dir/kwlist.xml
echo '<kwlist ecf_filename="ecf.xml" language="english" encoding="UTF-8" compareNormalize="" version="Example keywords"> '>>$kws_dir/kwlist.xml
j=1

for i in $(cat conf/raw_keywords.txt) ;do
	ll=`printf '%04d' "$j"`
    echo -e "	<kw kwid=\"WSJ-$ll\">" >>$kws_dir/kwlist.xml
    echo -e "		<kwtext>$i</kwtext>" >>$kws_dir/kwlist.xml
    j=$((j+1))
    echo "	</kw>"  >>$kws_dir/kwlist.xml
done
echo "</kwlist>" >>$kws_dir/kwlist.xml

###### ecf.xml generation from segments


rm -rf $kws_dir/ecf.xml
dur=0.00000
for wavs in `ls $wav_dir/*.wav`
do 
    len=`soxi -D $wavs`
    dur=`awk "BEGIN {print $dur+$len}"`
done


echo "<ecf source_signal_duration=\"$dur\" language=\"\" version=\"Excluded no score regions\">" >> $kws_dir/ecf.xml
for filename in `ls $wav_dir/*.wav `
do

    Duration=`soxi -D $filename`
    file_id=`echo $filename| rev | cut -d '/' -f1| rev | cut -d '.' -f1`
    echo "<excerpt audio_filename=\"$file_id\" channel=\"1\" tbeg=\"0.000\" dur=\"$Duration\" source_type=\"splitcts\"/>" >>$kws_dir/ecf.xml
done
echo "</ecf>" >>$kws_dir/ecf.xml 






