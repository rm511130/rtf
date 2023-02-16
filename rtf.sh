# Reprocess-Thumbnail-Fix Physna script:  rtf.sh
#
# rtf.sh executes PCLI reprocess commands for every UUID that has a thumbnail of size=0
# The reprocessing is limited to a given tenant-id, folder-id and can optionally skip assemblies
#
# by
# rmeira@physna.com
# 02-15-2023
#
# Syntax:   $ ./rtf.sh <tenant-id> <folder-id> <skip-assemblies>
# 
# Examples: $ ./rtf.sh solize 102 skip
#           $ ./rtf.sh delta 53 
#
# Explanation: - The first example will execute the script on solize.physna.com
#              against folder ID 102 but it will skip any assemblies
#              - The second example will execute the script on delta.physna.com
#              against foder ID 52 and it will include parts and assemblies
#

if [ ! -z "$1" -a ! -z "$2" ]
then	
    if [ "$3" = "skip" ]
    then	
        echo "Reprocess-Thumbnail-Fix on $1.physna.com  folderId = $2 and skip-assemblies = $3"
    else
        echo "Reprocess-Thumbnail-Fix on $1.physna.com  folderId = $2 and skip-assemblies = no"
    fi
else
	echo "Syntax:  $ ./rtf.sh <tenantId> <folderId> <skip-assemblies>"
	exit 0;
fi

/mnt/c/Users/Ralph/pcli.exe -t "$1" invalidate

/mnt/c/Users/Ralph/pcli.exe -t "$1" -p -f csv models --folder "$2" | awk 'FS="," { if (NR>1) print $1; }' | while read tuuid; do 
echo -n "$tuuid "

if [ -z "$tuuid" ]
then
      echo "END"
else
     /mnt/c/Users/Ralph/pcli.exe -t "$1" model --uuid "$tuuid" > /mnt/c/Users/Ralph/pmodel.json

     tname=$(cat /mnt/c/Users/Ralph/pmodel.json | jq .name)

     if [ -z "$tname" ]
     then
        echo "tname was empty"
     else
        tfileType=$(cat /mnt/c/Users/Ralph/pmodel.json | jq .fileType)
        tisassembly=$(cat /mnt/c/Users/Ralph/pmodel.json | jq .isAssembly)
	turl=$(cat /mnt/c/Users/Ralph/pmodel.json | jq .thumbnail | awk '{ print substr($0,2,length($0)-2); }')
	if [ "$tisassembly" = "false" ]
	then
	    tisassembly="part"
	else
            tisassembly="assembly"
	fi

	echo -n "$tname $tfileType $tisassembly "

        j=$(curl -I "$turl" 2>&1 | grep x-goog-stored-content-length: | awk '{ print $2; }' ); 

        if [ "$tisassembly" = "assembly" -a "$3" = "skip" ]
	then 
	     echo "Skipping Assembly";
        else	     
	     echo $j | awk -v tuuid=$tuuid -v tid=$1 '{ if ($0=='0') 
	                                                { tcmd="/mnt/c/Users/Ralph/pcli.exe -t " tid " reprocess --uuid " tuuid; 
						       	  printf("\n%s",tcmd);   
							  st=system(tcmd);  
							  if (st!=0) printf("System PCLI call returned %s\n",st);
					                } 
				                          else printf("Thumbnail is OK\n"); 
					               }';
        fi					       

     fi
fi
done

