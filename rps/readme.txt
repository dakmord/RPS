/************************************************************************/
/*	File:		readme.txt					*/
/*	Created:	27.03.2015					*/
/*	Modified:	27.03.2015, Daniel Schneider, EK-704		*/
/*			xx.xx.xxxx, xxxxxx xxxxxxxx, ..			*/
/*									*/
/*	Description:	Contains information about actual folder	*/
/*			structure.					*/
/************************************************************************/

/*	Folder Informations:						*/

The "rps" folder is containing all important RPS basic files like:
	- GUI
	- SVN communication
	- Matlab functions
	- basic cfg's

-> IMPORTANT:	This folder is used for doing any development related
		to RPS. If something in this folder will be changed,
		every user which is updating the local RPS will 
		download the new files from "rps" directory. These
		downloaded files will replace the local ones.

		If changes to RPS need to be done, please add your
		changes to files in this folder structure.
		The "rps" folder contains just GUI files with a folder
		structure described below.


-> Folders:	- cfg		Config Files
		- etc		Thirdparty tools/files like svn.exe or 
				Matlab functions
		- fcn		Developed Matlab functions for the RPS
		- pics		Needed pictures for GUI or sth. else
		- svn		Matlab functions related to the command
				line svn tool
		