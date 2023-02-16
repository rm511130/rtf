# rtf.sh
- `rtf.sh` is a [PCLI](https://github.com/jchultarsky101/pcli) based Physna reprocess script to be used when thumbnails are not being displayed on the Physna Enterprise GUI
- The `rtf.sh` command accepts three parameters so it can target the correct tenant, folder and decide whether to skip assemblies to focus just on parts.
- Reprocessing assemblies can lead to `missing-parts` issues hence the reason for the optional `<skip-assemblies>` parameter.
- RTF = Reprocess Thumbnails Fix

## Notes
- The path of the PCLI tool is hardcoded in the [script](https://github.com/rm511130/rtf/blob/main/rtf.sh) and needs to be edited to reflect the location of your [PCLI](https://github.com/jchultarsky101/pcli) executable.
- Once `rtf.sh` has been downloaded into a Linux Shell environment you will need to execute `$ chmod +x rtf.sh` to make `rtf.sh` an executable script.

## Syntax of the command

`$ ./rtf.sh <tenant-id> <folder-id> <skip-assemblies>`

- `<tenant-id>` and `<folder-id>` are mandatory. 
- `<skip-assemblies>` is an optinal parameter which, if used, needs to be `skip` (in lowercase)

## Examples:

`$ ./rtf.sh sandbox1 102 skip` 

The example above will execute the script on sandbox1.physna.com against folder ID 102 and it will skip assemblies
          
 `$ ./rtf.sh omicron 52` 
  
The example above will execute the script on omicron.physna.com against foder ID 52 and it will include parts and assemblies  
  
`$ ./rtf.sh` 
          
This third example returns a message with the expected syntax because the command is missing mandatory parameters


## Example of "Broken Thumbnails" that `rtf.sh` can correct

![](./images/broken-thumbails.jpg)
