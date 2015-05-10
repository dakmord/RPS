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

The "blocks" folder contains all custom created simulink blocks for the
RPS. If you intend to add or modify any blocks, libraries, ... .

-> Files:	- rpsrootlib.slx	Basic Simulink Library file which
					shall contain sublibraries and
					all RPS blocks.

-> Folders:	- mex			Here will be located every *.mex
					file of custom simulink blocks.

		- sfcn			This folder will contain all 
					custom generated Matlab S-Functions
					with all needed src files.
		
		- src			Please try to develop your 
					custom blocks with all needed
					files in this folder. Please
					feel free to create subfolders
					for every block
					e.g.: ../blocks/src/<yourBlock>/..