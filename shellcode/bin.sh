#!/bin/bash

INPUT=
OUTPUT=
TYPE=

while getopts ":i:o:t:" OPTIONS
do
            case $OPTIONS in
            i)     INPUT=$OPTARG;;
            o)     OUTPUT=$OPTARG;;
            t)     TYPE=$OPTARG;;
            ?)     printf "Invalid option: -$OPTARG\n" $0
                          exit 2;;
           esac
done

INPUT=${INPUT:=NULL}
OUTPUT=${OUTPUT:=NULL}
TYPE=${TYPE:=NULL}

##################
#  ~~~ Menu ~~~  #
##################

if [ $INPUT = NULL ] || [ $OUTPUT = NULL ] || [ $TYPE = NULL ]; then

echo "--------------------------------------------------------------------"
echo "|                          Bin v1.0 ~ b33f                         |"
echo "|                  -Convert you shellcode to *.bin-                |"
echo "--------------------------------------------------------------------"
echo "| USAGE: ./bin.sh -i [Input File] -o [Output File] -t [B/Z]        |"
echo "|                                                                  |"
echo "| REQUIRED                                                         |"
echo "|         -i  Input (text) file containing the shellcode.          |"
echo "|         -o  Output filename without extention (eg: shell).       |"
echo "|         -t  Type can be B (regular bin file) or Z (zipped.       |"
echo "|             bin file).                                           |"
echo "|                                                                  |"
echo "| DETAILS                                                          |"
echo "|         The input text file should just contain the shellcode.   |"
echo "|         If you are using msfpayload (possibly/probably in        |"
echo "|         combinatione with msfencode) set the output type to      |"
echo "|         c or perl. If you have some shellcode in an exploit      |"
echo "|         just copy it to a text file...                           |"
echo "--------------------------------------------------------------------"

######################
#  ~~~ Type = B ~~~  #
######################
elif [ $TYPE = B ]; then

echo "[>] Parsing Input File"
cat $INPUT |grep '"' |tr -d " " |tr -d "\n" |sed 's/[\"x.;(){}]//g' >> /tmp/$OUTPUT.txt
echo "[>] Pipe output to xxd"
xxd -r -p /tmp/$OUTPUT.txt $OUTPUT.bin
echo "[>] Clean up"
rm /tmp/$OUTPUT.txt
echo "[>] Done!!"

######################
#  ~~~ Type = Z ~~~  #
######################
elif [ $TYPE = Z ]; then

echo "[>] Parsing Input File"
cat $INPUT |grep '"' |tr -d " " |tr -d "\n" |sed 's/[\"x.;(){}]//g' >> /tmp/$OUTPUT.txt
echo "[>] Pipe output to xxd"
xxd -r -p /tmp/$OUTPUT.txt /tmp/$OUTPUT.bin
echo "[>] Zipping the *.bin file"
zip $OUTPUT.zip /tmp/$OUTPUT.bin &>/dev/null
echo "[>] Clean up"
rm /tmp/$OUTPUT.bin
rm /tmp/$OUTPUT.txt
echo "[>] Done!!"

fi
