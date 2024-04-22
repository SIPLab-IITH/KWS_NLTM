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
3. Make sure that you export correct KALDI_ROOT path. Create a soft links of utils and steps to  directory inside the KWS_NLTM. 
```
export KALDI_ROOT=/home/user/kaldi/
ln -s $KALDI_ROOT/egs/wsj/s5/steps $KALDI_ROOT/egs/kws/KWS_NLTM/steps
ln -s $KALDI_ROOT/egs/wsj/s5/utils $KALDI_ROOT/egs/kws/KWS_NLTM/utils
```
4. Download the KWS models of 6 languages from the onedrive link ((https://iith-my.sharepoint.com/:f:/g/personal/ee22mtech02001_iith_ac_in/Es413r7D2ZdJpZ4qXokq4wIBTBFNsve7H9LmKAsZQqNCUA?e=UcZeBf)
) and unzip it in KWS_NLTM location

5. Suppose, To perform KWS for telugu language, Place wavefiles in the telugu/test folder. Create keywords.txt file inside telugu/test folder. The contents of keywords.txt should be
```
KWS-0001 అధికారులు
KWS-0002 ముఖ్యమంత్రి
KWS-0003 పోలీసులు
```
6. run inference.sh script to perform KWS
   ```
   bash inference.sh
   ```
