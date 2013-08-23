========================
Altium Scripts
========================

-----------------------------------------------------------
A collection of useful Altium scripts, written in VBScript.
-----------------------------------------------------------

- Author: gbmhunter <gbmhunter@gmail.com> (http://www.cladlab.com)
- First Ever Commit: 2013/08/08
- Last Modified: 2013/08/23
- Version: v10.0.0.1
- Company: CladLabs
- Language: VBScript
- Compiler: Altium Script Engine
- uC Model: n/a
- Computer Architecture: n/a
- Operating System: n/a
- Documentation Format: n/a
- License: GPLv3

Description
===========

Core Files
----------

All are located in *./src/*.

========================================    ==================================================================
Filename                                    Description
========================================    ==================================================================
Config.vbs                                  Contains configuration settings.
Main.vbs                                    This is the main script which when run will load up a form that can run all of the other scripts.
========================================    ==================================================================

Tools
-----

Tools are designed to automate some process in Altium. All are located in *./src/Tools/*.

========================================    ==================================================================
Filename                                    Description
========================================    ==================================================================
ChangeDesignatorFontSize.vbs                Changes the font size (width and height) of all component designators on the PCB.
PlaceNettedVia.vbs                          Allows you to copy a via and then place many copies, preserving the original connected net (Altium does not do this, unless to do a special paste).
PushProjectParametersToSchematics.vbs       Copies all project parameters to the schematic documents, which can be useful for automatically filling in title block information (using special strings).
========================================    ==================================================================

Checks
------------------

Checks are scripts designed to be run before the board is released to the manufacturer. All are located in *./src/Checks/*. 

========================================    ==================================================================
Filename                                    Description
========================================    ==================================================================
CheckCapsShowCapacitanceAndVoltage.vbs		Checks that all capacitors on the schematics show both capacitance and voltage. Uses regex patterns to find visible parameters which follow the correct format (e.g. 2.0uF, 22mF, 10.00F, 6.3V, 12V) of components whose designators start with "C".
CheckLayers.vbs                             Checks that the mechanical layers of the PCB have the correct objects on them.
CheckNameVersionDate.vbs                    Checks that the version and date of the project are included as silkscreen text somewhere on the PCB.
CheckNoSupplierPartNumShown.vbs             Checks that no supplier part numbers are shown on the schematics.
CheckPcbTextHasCorrectOrientation.vbs       Checks that PCB text has the correct orientation (so it is readable), that is text on the top overlay IS NOT mirrored, and text on the bottom layer IS mirrored.
CheckPowerPortOrientation.vbs               Checks that power ports are orientated in the correct way. Ground pins are meant to face downwards and the bar symbol upwards.
CheckProjectCompiles.vbs                    Makes sure that the project compiles successfully.
CheckTentedVias.vbs                         Checks that a certain proportion of the vias are fully tented. If the ratio is less than a threshold, the script assumes you have forgotten to tent vias. Some are allowed to not be tented for test-point purposes.
========================================    ==================================================================

External Dependencies
=====================

None.

Issues
======

See GitHub Issues.

Usage
=====

Add the scripts to your current project, and then run the scripts from Altium by holding Alt and pressing X, S.
	
Changelog
=========

========= ========== ===================================================================================================
Version   Date       Comment
========= ========== ===================================================================================================
v10.0.0.1 2013/08/23 Fixed Changelog ReStructuredText syntax problem which was causing the table to not be displayed in README. Problem was with the first column of the table delimiter missing an equals character after extending to accommodate for v10.0.0.0.
v10.0.0.0 2013/08/23 Added script that makes sure all resistors on the schematic display their resistance (CheckResShowResistance()). Fixed StdOut formatting bugs which occurred when scripts terminated early.
v9.0.0.2  2013/08/22 Fixed programming language from 'Delphi' to 'VBScript' in README.
v9.0.0.1  2013/08/22 Added info to README for missing scripts.
v9.0.0.0  2013/08/22 Added script that makes sure PCB text has the correct orientation (CheckPcbTextHasCorrectOrientation()). Text on the top overlay must not be mirrored, text on the bottom overlay must be mirrored.
v8.0.0.0  2013/08/22 Added script that checks that capacitors on schematic are displaying both capacitance and voltage (CheckCapsShowCapacitanceAndVoltage.vbs). Added 'ERROR:' to the start of error messages in CheckProjectCompiles.vbs.
v7.1.0.0  2013/08/22 Added more PCB layer constants to Config.vbs. Added check for top and bottom dimension layers to CheckLayers.vbs.
v7.0.1.0  2013/08/21 Re-arranged folder structure. Added ./src/Tools folder, put all tool scripts in this. Renamed ./src/PrereleaseChecks folder to just ./src/Checks, and moved MainScript.vbs into ./src folder, and renamed it to just Main.vbs. Updated script project file with new paths. Added folders to README under appropriate sections. Added core files section to README.
v7.0.0.2  2013/08/20 Fixing issue with description tables in README. Replaced all tab characters with spaces.
v7.0.0.1  2013/08/20 Tabulated the script file names and descriptions in the README. Removed unused limitations section. Added information about MainScript.vbs to README. Added info about CheckNameVerisonDate.vbs to README.
v7.0.0.0  2013/08/20 Added PushProjectParametersToSchematics.vbs, which copies all project parameters to the schematic documents, which can be useful for automatically filling in title block information. Updated README accordingly. Added button for this on main script form.
v6.1.0.0  2013/08/20 Renamed CheckDate.vbs to CheckNameVerisonDate.vbs. Made script now check for version number also (in the format v2.3).
v6.0.0.0  2013/08/20 Date checker script for PCB added. Uses regex built into VBScript.
v5.1.0.0  2013/08/20 Added config file, and added a few variables to it. Fixed tented via bug using manual/auto parameter, now uses expansion value. Will not work if expansion overridden manually.
v5.0.0.0  2013/08/20 Added check for number of tented vias. If ratio of tented vias is not greater than 0.9, script assumes you have forgotten to tent them. Added relevant info to README. Changed .pas extensions in README to .vbs, and added missing ones.
v4.0.0.0  2013/08/19 Added check for project compilation (before any other checks are done). Added StdOut() and StdErr() functions for scripts to use, stopped them from directly writing to the memo object. Updated GUI with errors text output.
v3.1.3.0  2013/08/19 Converted ChangeDesignatorFontSize, PlaceNettedVia from Delphi to VB script (now .vbs).
v3.1.2.0  2013/08/19 Converted CheckNoSupplierPartNumShown from Delphi to VB script (now .vbs). Deleted old MainForm.pas.
v3.1.1.0  2013/08/19 Converted CheckPowerPortOrientation from Delphi to VB script (now .vbs).
v3.1.0.0  2013/08/16 Converted layer script to Visual Basic script. Plan is to convert all scripts eventually.
v3.0.0.0  2013/08/16 Added layer check script, which checks that PCB layers have the correct objects on them.
v2.0.0.0  2013/08/15 Added pre-release checks folder, with port symbols and supplier part number checks. Added main form to run these from. Added relevant sections to the README. Added script project to root directory.
v1.1.0.0  2013/08/14 Added PlaceNettedVia.pas. Changed name to AltiumScripts (repo will now hold all scripts). Added basic usage and updated 'External Dependencies' in README. Moves scripts into the src/ directory.
v1.0.0.0  2013/08/08 Initial commit. Script written and tested (it works). 
========= ========== ===================================================================================================