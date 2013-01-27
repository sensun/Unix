#!/bin/bash

#############################################################################################################################################################
#                                                                                                                                                           #
# Name          : CSV_Formatter.sh                                                                                                                          #
#                                                                                                                                                           #
# Purpose       : It formats the CSV file by removing commas in a each and every column values which starts with Double quotes and ends with double quotes  #
#                                                                                                                                                           #
#                                                                                                                                                           #
# Usage         : ./CSV_Formatter.sh <filename>               Eg: ./CSV_Formatter.sh TestFile.csv                                                           #
#                                                                                                                                                           #
#                                                                                                                                                           #
# Change Log    :       Date            Name            Description                                                                                         #
#                       ----            ----            -----------                                                                                         #
#                       20111001        Senthil         Creation                                                                                            #
#############################################################################################################################################################

#-----------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                     INPUT VALIDATION                                                                      #
#-----------------------------------------------------------------------------------------------------------------------------------------------------------#

if [ $# -ne 1 ] 
then
  echo "Usage : ./CSV_Formatter.sh TESTFile.csv"
	exit 1
fi

SRCFile=$1
FORMATTEDFile=${SRCFile}.formatted


#-----------------------------------------------------------------------------------------------------------------------------------------------------------#
# PROGRAM STARTS HERE                                                                                                                                       #
#-----------------------------------------------------------------------------------------------------------------------------------------------------------#

#awk -F"," 'BEGIN{DBLQUOTIndicator="N";OFS=","}{for(i=1;i<=NF;i++){if(DBLQUOTIndicator=="N" && $i ~ /^"/){gsub(/"/,"",$i);printf $i;DBLQUOTIndicator="Y";i=i+1;}else if(DBLQUOTIndicator=="N" && ($i !~ /^"/ || $i !~ /"$/)){if(i==NF){printf $i}else{printf $i","}};if(DBLQUOTIndicator=="Y" && $i !~ /"/){printf $i}else if(DBLQUOTIndicator=="Y" && $i ~ /"$/){gsub(/"/,",",$i);printf $i; DBLQUOTIndicator="N";}if(i==NF){DBLQUOTIndicator="N";printf "\n"}}}' BOB.csv

awk -v DBLSTART="^\"" -v DBLEND="\"$" -F"," 'BEGIN{DBLQUOTIndicator="N";OFS=","}
{
	for(i=1;i<=NF;i++)
	{
		if(DBLQUOTIndicator=="N" && $i ~ DBLSTART)
		{
			gsub(/"/,"",$i);
			printf $i;
			DBLQUOTIndicator="Y";
			i=i+1;
		}
		else if(DBLQUOTIndicator=="N" && ($i !~ DBLSTART || $i !~ DBLEND))
		{
			if(i==NF)
			{
				printf $i
			}
			else
			{
				printf $i","
			}
		};
		if(DBLQUOTIndicator=="Y" && $i !~ /"/)
		{
			printf $i
		}
		else if(DBLQUOTIndicator=="Y" && $i ~ DBLEND)
		{
			gsub(/"/,",",$i);
			printf $i; 
			DBLQUOTIndicator="N";
		}
		if(i==NF)
		{
			DBLQUOTIndicator="N";
			printf "\n"
		}
	}
}' ${SRCFile} > ${FORMATTEDFile}

sed -i 's/
//g' ${FORMATTEDFile}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------#
# END OF PROGRAM                                                                                                                                            #
#-----------------------------------------------------------------------------------------------------------------------------------------------------------#

