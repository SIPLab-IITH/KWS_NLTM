## KWS_NLTM
You need kaldi to run this repository.


1. You first need to install Git. The  current version of Kaldi  can be downloaded by typing into a shell:
```
git clone https://github.com/kaldi-asr/kaldi.git kaldi --origin upstream
cd kaldi
```
Follow the instructions in "INSTALL" file to setup the kaldi: 

2. create a kws directory inside egs folder and clone the KWS_NLTM repository from github
```
mkdir kws
cd kws
git clone https://github.com/SIPLab-IITH/KWS_NLTM.git
cd KWS_NLTM
```
2. create a soft links of utils and steps to  directory inside egs folder and clone the KWS_NLTM repository from github
```
export KALDI_ROOT=/home/user/kaldi/
ln -s $KALDI_ROOT/egs/wsj/s5/steps $KALDI_ROOT/egs/kws/KWS_NLTM/steps
ln -s $KALDI_ROOT/egs/wsj/s5/utils $KALDI_ROOT/egs/kws/KWS_NLTM/utils
```
3. Download the KWS models of 6 languages from the onedrive link and unzip it in KWS_NLTM location

