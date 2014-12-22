===================
AltiumScriptCentral
===================

-----------------------------------------------------------
A collection of useful Altium scripts, written in VBScript.
-----------------------------------------------------------

.. image:: https://cloud.githubusercontent.com/assets/2396869/4988032/025f32f6-69c1-11e4-8062-de62da2fbb97.png
	:height: 500px
	:align: right

- Author: gbmhunter <gbmhunter@gmail.com> (www.mbedded.ninja)
- First Ever Commit: 2013-08-08
- Last Modified: 2014-12-22
- Version: v22.0.0.0
- Company: mbedded.ninja
- Language: VBScript
- Compiler: Altium Script Engine
- uC Model: any
- Computer Architecture: any
- Operating System: any
- Documentation Format: n/a
- License: GPLv3

Description
===========

Core Files
----------

All are located in :code:`src/`.

======================================== ==================================================================
Filename                                 Description
======================================== ==================================================================
Config.vbs                               Contains configuration settings.
Main.dfm                                 Form information for the main script (this is linked with Main.vbs).
Main.vbs                                 This is the main script which when run will load up a form that can run all of the other scripts.
======================================== ==================================================================


Schematic Tools
===============

Add Special Schematic Parameters
--------------------------------

File: src/Tools/AddSpecialSchParam.vbs

Provides you with the option of adding various special parameters to all the schematic documents in the currently active project.

Delete All Schematic Parameters
-------------------------------

File: src/Tools/DeleteAllSchematicParameters.vbs

Deletes all schematic parameters on all schematic sheets belonging to the currently active project. Added after found it was impossible to manually delete some schematic parameters that had been previously added with a script. Also useful for getting rid of all the default parameters Altium adds.

Push Project Parameters To Schematics
-------------------------------------

File: src/Tools/PushProjectParametersToSchematics.vbs

Copies all project parameters to the schematic documents, which can be useful for automatically filling in title block information (using special strings).

PCB Tools
=========

Current Calculator
------------------

File: src/Tools/CurrentCalculator.vbs

Allows the user to calculate the the maximum allowed current of a particular track on a PCB for a given temperature rise. Calculated in accordance with the equations in IPC-2221A Section 6.2 (formerly IPC-D-275).

Based on the calculator found at `http://www.mbedded.ninja/online-calculators/pcb-design/track-width-calculator 
<http://www.mbedded.ninja/online-calculators/pcb-design/track-width-calculator>`_.

Draw Polygon
------------

File: src/Tools/DrawPolygon.vbs

Allows you to easily draw a polygon on a PCB. You can specify the number of sides, the track width, the rotation, and more.

Resize Designators
------------------

File: src/Tools/ResizeDesignators.vbs

Changes the font size (width and height) of all component designators on the PCB.

Rotate Designators
------------------

File: src/Tools/RotateDesignators.vbs

Rotates all PCB component designators so that they are rotated to only 1 of 2 positions.

Via Stamper
-----------

File: src/Tools/ViaStamper.vbs

Allows you to copy a via and then place many copies, preserving the original connected net (Altium does not do this, unless you do a special paste).

Checks
======

Checks are scripts designed to be run before the board is released to the manufacturer. All are located in :code:`src/Checks/`. 

======================================== ==================================================================
Filename                                 Description
======================================== ==================================================================
CheckComponentLinks.vbs                  Loads up the "Edit Component Links" window so that you can make sure there are no missing component links. 
CheckLayers.vbs                          Checks that the mechanical layers of the PCB have the correct objects on them.
CheckNameVersionDate.vbs                 Checks that the version and date of the project are included as silkscreen text somewhere on the PCB.
CheckNoSupplierPartNumShown.vbs          Checks that no supplier part numbers are shown on the schematics.
CheckPcbTextHasCorrectOrientation.vbs    Checks that PCB text has the correct orientation (so it is readable), that is text on the top overlay IS NOT mirrored, and text on the bottom layer IS mirrored.
CheckProjectCompiles.vbs                 Makes sure that the project compiles successfully.
CheckTentedVias.vbs                      Checks that a certain proportion of the vias are fully tented. If the ratio is less than a threshold, the script assumes you have forgotten to tent vias. Some are allowed to not be tented for test-point purposes.
PowerPortChecker.vbs                     Checks that power ports are orientated in the correct way. Ground pins are meant to face downwards and the bar symbol upwards.
======================================== ==================================================================


Component Validators
--------------------

The component validator checks makes sure that all the schematic components have recognised designators and are showing the correct parameters (which is dependant on the component type, as given by the designator). All component validator scripts are located in :code:`src/Checks/ComponentValidators`.

======================================== ==================================================================
Filename                                 Description
======================================== ==================================================================
ComponentValidator.vbs                   This is essentially the "main" file for the component validators. It is called by Main.vbs and in turn calls the individual component validator files, once it recognises a valid designator (the valid designators are contained in Config.vbs).
ValidateCapacitor.vbs                    Makes sure that all the capacitors on the schematic are showing the correct parameters.
ValidateInductor.vbs                     Makes sure that all the inductors on the schematic are showing the correct parameters.
ValidateResistor.vbs                     Makes sure that all the inductors on the schematic are showing the correct parameters.
======================================== ==================================================================

Statistics
----------

PCB statistics can be displayed by clicking the "Display PCB Stats" button from the main script window. All code for this is located in :code:`src/Stats`

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
v22.0.0.0 2014-12-22 Started fixing bugs when schematics sheets were not open, scripts now open them by themselves. Added better error reporting to StdErr, module name is reported for every error. PCB Server is now started automatically. PCB documents are now opened automatically. Via tenting checker now reports total number of vias found, closes #167. Added script that can swap two PCB components, closes #166. Fixed 'Checking bottom dimension layer...Enum = 12Enum=12Enum=12...' bug, closes #165. Fixed the layout of the Pre-release Checks window (size needs adjusting), closes #156. Fixed the error 'ERROR: Could not retrieve 'C:\MCU.SchDoc'. Please compile project. ERROR: No sheet found. ERROR: No sheet found.' if any schematic sheet is not open when pre-release checks are run, closes #155.
v21.1.4.0 2014-11-26 Added 'Num. of Plated Holes' and 'Num. of Unplated Holes' to PCB statistics, closes #120.
v21.1.3.0 2014-11-26 Attempted a Delphi rewrite but gave up after I discovered that the context help isn't actually any better. Put test files in 'old/'.
v21.1.2.0 2014-11-26 Fixed bug where assignment error is thrown with pad variable in the 'Display PCB Stats' script, closes #161. Tidied up the formatting of the 'Display PCB Stats' script, closes #162.
v21.1.1.0 2014-11-26 Fixed bug where 'Delete Schematic Parameters' does not produce any output, closes #158. Fixed bug where 'Number Schematics' does not produce any output, closes #159. Made all button choices on the main script close the main script form, closes #160.
v21.1.0.0 2014-11-25 Created a new form for pre-release checks, and moved the 'stdout' and 'stderr' message boxes to this form, closes #148. Splitted tools section into sub-categories, closes #140. Removed 'via stamper' prompt, closes #152.
v21.0.0.1 2014-11-24 Added 'based on calculator found at...' in README for 'Current Calculator', closes #150. Rearranged README with better script module descriptions, closes #151.
v21.0.0.0 2014-11-24 Added a script which calculates the track/trace current for a given temperature rise, closes #149.
v20.4.1.0 2014-11-15 Removed images from repo, they are now stored in the GitHub issues, closes #138. Moved the integer checker function into it's own file, 'Utils/Utils.vbs'.
v20.4.0.0 2014-11-14 Added ability to specify polygon by length of one edge in the 'DrawPolygon' script, closes #147.
v20.3.0.0 2014-11-12 Converted the 'DrawHexagon' script into a 'DrawPolygon' script, closes #144.
v20.2.0.0 2014-11-12 Added the option for user to specify the radius to vertex or radius to edge in the 'DrawHexagon' script, closes #142.
v20.1.0.0 2014-11-12 Added ability for user to change the layer the hexagon is drawn on in the 'DrawHexagon' script, closes #143.
v20.0.0.0 2014-11-12 Added a 'Draw Hexagon' script, closes #139. Re-arranged scripts by alphabetical order in script project, closes #141.
v19.0.0.0 2014-11-11 Added via stamper script, closes #132. Added space between 'We have PCB access.' and 'PCB access checking complete.' in StdOut, closes #130. Deleted PlaceNettedVia.vbs, closes #133. Fixed bug where CheckTentedVias() crashes if there are no vias on PCB due to divide by 0, closes #134. Fixed image in README that was broken, closes #135.
v18.3.2.0 2014-11-07 Add ability to only change the size of designators which are currently the default Altium size with the 'Resize Designators' script, closes #129. Report how many designators were changed when 'Resize Designators' is run, closes #131.
v18.3.1.0 2014-11-07 Forgot to save script project file in previous commit.
v18.3.0.0 2014-11-07 Add ability to specify designator height and width for the 'Resize Designators' option, closes #128. Renamed 'src/Tools/ChangeDesignatorFontSize.vbs' to 'src/Tools/ResizeDesignators.vbs'. Tidied up table formatting in README.
v18.2.2.0 2014-11-05 Fixed 'Abstract Error' error message when trying to renumber pads, closes #127. Fixed 'Type Mismatch: Renumber Pads' error when trying to renumber pads, closes #126.
v18.2.1.0 2014-11-04 Tidied up code, improved error messages. Now pass PCB board variable into CheckLayers functions rather than using a global, closes #124. We now only run PCB checks if PCB file can be opened, closes #125. Added scroll bars to Status and Errors text windows, closes #91.
v18.2.0.0 2014-11-04 Added title block to Stats.vbs. Added board width and height to the PCB statistics window, closes #117. Added 'Num. of Diff Holes Sizes' statistic to the Stats window, closes #118. Renamed script project file to 'AltiumScriptCentral.PrjScr'. Coloured the StdErr text red, closes # #119.
v18.1.0.0 2014-11-03 Added minimum annular ring statistic to 'Display PCB Stats', closes #114. Added minimum track width statistic to 'Display PCB Stats', closes #115. Added 'Num. Copper Tracks' statistic to 'Display PCB Stats', closes #116.
v18.0.0.0 2014-11-03 Added the ability to measure and display PCB stats that would be useful for providing to the manufacturer, closes #112. Added dummyVar argument to all functions that are not designed to be called manually, so that they don't display in the 'Run Scripts' dialog of Altium, closes #113.
v17.0.1.1 2014-11-03 Renamed repo name to 'AltiumScriptCentral', closes #111.
v17.0.1.0 2013-12-16 Fixed issue with 'Add Special Schematic Parameters' button not working.
v17.0.0.0 2013-10-22 Added 'CheckComponentLinks.vbs' script, which loads up the edit component links window so that you can make sure there are no missing component links. Main form calls this script when you run PCB project checks.
v16.0.0.0 2013-10-21 Added 'AddSpecialSchParams.vbs' script, which gives you the option of adding various special parameters to every schematic in the active project. Good for adding parameters which will then automatically fill in info in the title blocks (schematic template files). Added button to load this script in the tools section of the main form. Added relevant info to README.
v15.0.0.0 2013-10-21 Added 'DeleteAllSchematicParamters.vbs' script, after found it was impossible to manually delete some schematic parameters that had been previously added with a script. Also useful for getting rid of all the default parameters Altium adds. Added button for this to tools section on main form. Added relevant info to README.
v14.0.0.5 2013-10-03 Added height and alignment parameters to image in README.
v14.0.0.4 2013-10-03 Updated broken image link in README.
v14.0.0.3 2013-10-03 Updated broken image link in README.
v14.0.0.2 2013-10-03 Updated broken image link in README.
v14.0.0.1 2013-10-03 Added screenshot of Altium Script Central in action to /images/. Added image to README.
v14.0.0.0 2013-09-25 Added rotate designators script. Added button to main script form to rotate designators.
v13.1.8.0 2013-09-23 Changed README title to 'Altium-Script-Central'.
v13.1.7.0 2013-09-23 Corrected and updated file lists in the README.
v13.1.6.0 2013-09-23 Added 'm' (milli-ohms) to accepted resistance units in the resistor validator script.
v13.1.5.0 2013-09-17 Added keepouts (which encompasses a variety of objects which can be selected to act as a keepout) to the list of allowed objects on the top and bottom mechanical body PCB layers.
v13.1.4.0 2013-09-11 Text orientation checker now reports back that exact text that is not correctly orientated and the layer it is on.
v13.1.3.0 2013-09-11 Made parameter push script and number schematics script compile project before pushing so that all schematic documents are found. Sped up both pushing project parameters and numbering schematics by commenting calls to SchServer.RobotManager.SendMessage(). Improved the error message if a schematic sheet couldn't be retrieved. Added GraphicallyInvalidate call to certain scripts to force redraw.
v13.1.2.0 2013-09-10 Added 'XC' (crystal) to list of valid component designators.
v13.1.1.0 2013-09-09 Added all unused layers to the layer variable set in Config.vbs.
v13.1.0.0 2013-09-09 Added unused PCB layer function in CheckLayers.vbs. Reports errors if any objects are found on layers which are meant to be unused (as defined in Config.vbs).
v13.0.0.0 2013-09-09 Added script that numbers schematics (NumberSchematics.vbs). Script add the schematic sheet number and total sheet count to each schematic, which can be automatically displayed in the title block. ConfigInit() is now called on main form load, not from ButRunChecks().
v12.1.1.0 2013-09-09 Fixed component validator bug which was returning false errors (nothing reported to StdErr). Fixed 'Push Project Parameters To Schematics' button which wasn't working.
v12.1.0.0 2013-09-06 Now prints designator text 'xxx' with 'Designator xxx does not follow valid designator syntax' error. ComponentValidator.vbs now supports the designator 'E' (antennas), 'W' (cable/wire), 'PV' (solar panel) and 'BT' (battery). Made IgnoreCase equal False for regex objects. Fixed bug where no component violation errors where reported even though some resistors didn't show resistance.
v12.0.3.0 2013-09-06 Fixed 'Not a PCB or footprint loaded' bug on main script run without PCB file open. Added parenthesis around user strings reported in StdOut and StdErr. Added test points (TP) as a valid component designator for ComponentValidator.vbs. Added anchors for resistance and capacitance regex.
v12.0.2.0 2013-09-06 Renamed main script form to 'Script Central'. Added 'Tools' label to main script form, and made run checks button larger than the tool buttons.
v12.0.1.0 2013-09-05 Fixed bug with RenumberPads, no longer crashes on exit. Added button on main form to call resize designator script.
v12.0.0.0 2013-09-04 Added RenumberPads script, with link from the main form. Currently crashes on RenumberPads exit.
v11.1.0.0 2013-09-04 Each StdErr message is now printed on it's own line. Made final script error message go to StdOut, detailed ones goes to StdErr. Added recognition for fuse (F), fuse holder (XF) and jack (J) designators. Updated .gitignore to ignore '__Previews' folders created by Altium.
v11.0.2.0 2013-09-03 Added support for dates that use the syntax yyyy-mm-dd in CheckNameVersionDate.vbs.
v11.0.1.0 2013-09-03 Added spaces between component validator error messages. Corrected component validator error messages that reported wrong parameter. Renamed to PowerPortChecker.vbs. PowerPortChecker now reports sheet name and port name for any violating ports.
v11.0.0.0 2013-09-03 Added inductor validator. Fixed incorrect return statements in validator functions. Fixed bug where script would crash if regex did not find a designator match.
v10.2.1.0 2013-09-03 Moved designator identifiers into config file. Renamed resistor and capacitor validators, and they are now called from ComponentValidator.vbs.
v10.2.0.0 2013-09-02 Collected component validating scripts and put in new folder 'src/Checks/ComponentValidators'. Added parent script for component validation, called ComponentValidator.vbs. Added a number of valid component designators.
v10.1.1.0 2013-09-02 Capacitor check script now reports back violating capacitors. Added start-of-string anchors to resistor and capacitor designator finding regex to fix bug where designator XC1 was being matched as a capacitor.
v10.1.0.1 2013-08-24 Added info about CheckResShowResistance.vbs to README.
v10.1.0.0 2013-08-23 Supplier part number visible violations now report component designator and part number, so you can find the violation and fix it.
v10.0.1.0 2013-08-23 Added .gitignore with path to ignore History/ folder (generated by Altium when saving script project).
v10.0.0.1 2013-08-23 Fixed Changelog ReStructuredText syntax problem which was causing the table to not be displayed in README. Problem was with the first column of the table delimiter missing an equals character after extending to accommodate for v10.0.0.0.
v10.0.0.0 2013-08-23 Added script that makes sure all resistors on the schematic display their resistance (CheckResShowResistance()). Fixed StdOut formatting bugs which occurred when scripts terminated early.
v9.0.0.2  2013-08-22 Fixed programming language from 'Delphi' to 'VBScript' in README.
v9.0.0.1  2013-08-22 Added info to README for missing scripts.
v9.0.0.0  2013-08-22 Added script that makes sure PCB text has the correct orientation (CheckPcbTextHasCorrectOrientation()). Text on the top overlay must not be mirrored, text on the bottom overlay must be mirrored.
v8.0.0.0  2013-08-22 Added script that checks that capacitors on schematic are displaying both capacitance and voltage (CheckCapsShowCapacitanceAndVoltage.vbs). Added 'ERROR:' to the start of error messages in CheckProjectCompiles.vbs.
v7.1.0.0  2013-08-22 Added more PCB layer constants to Config.vbs. Added check for top and bottom dimension layers to CheckLayers.vbs.
v7.0.1.0  2013-08-21 Re-arranged folder structure. Added ./src/Tools folder, put all tool scripts in this. Renamed ./src/PrereleaseChecks folder to just ./src/Checks, and moved MainScript.vbs into ./src folder, and renamed it to just Main.vbs. Updated script project file with new paths. Added folders to README under appropriate sections. Added core files section to README.
v7.0.0.2  2013-08-20 Fixing issue with description tables in README. Replaced all tab characters with spaces.
v7.0.0.1  2013-08-20 Tabulated the script file names and descriptions in the README. Removed unused limitations section. Added information about MainScript.vbs to README. Added info about CheckNameVerisonDate.vbs to README.
v7.0.0.0  2013-08-20 Added PushProjectParametersToSchematics.vbs, which copies all project parameters to the schematic documents, which can be useful for automatically filling in title block information. Updated README accordingly. Added button for this on main script form.
v6.1.0.0  2013-08-20 Renamed CheckDate.vbs to CheckNameVerisonDate.vbs. Made script now check for version number also (in the format v2.3).
v6.0.0.0  2013-08-20 Date checker script for PCB added. Uses regex built into VBScript.
v5.1.0.0  2013-08-20 Added config file, and added a few variables to it. Fixed tented via bug using manual/auto parameter, now uses expansion value. Will not work if expansion overridden manually.
v5.0.0.0  2013-08-20 Added check for number of tented vias. If ratio of tented vias is not greater than 0.9, script assumes you have forgotten to tent them. Added relevant info to README. Changed .pas extensions in README to .vbs, and added missing ones.
v4.0.0.0  2013-08-19 Added check for project compilation (before any other checks are done). Added StdOut() and StdErr() functions for scripts to use, stopped them from directly writing to the memo object. Updated GUI with errors text output.
v3.1.3.0  2013-08-19 Converted ChangeDesignatorFontSize, PlaceNettedVia from Delphi to VB script (now .vbs).
v3.1.2.0  2013-08-19 Converted CheckNoSupplierPartNumShown from Delphi to VB script (now .vbs). Deleted old MainForm.pas.
v3.1.1.0  2013-08-19 Converted CheckPowerPortOrientation from Delphi to VB script (now .vbs).
v3.1.0.0  2013-08-16 Converted layer script to Visual Basic script. Plan is to convert all scripts eventually.
v3.0.0.0  2013-08-16 Added layer check script, which checks that PCB layers have the correct objects on them.
v2.0.0.0  2013-08-15 Added pre-release checks folder, with port symbols and supplier part number checks. Added main form to run these from. Added relevant sections to the README. Added script project to root directory.
v1.1.0.0  2013-08-14 Added PlaceNettedVia.pas. Changed name to AltiumScripts (repo will now hold all scripts). Added basic usage and updated 'External Dependencies' in README. Moves scripts into the src/ directory.
v1.0.0.0  2013-08-08 Initial commit. Script written and tested (it works). 
========= ========== ===================================================================================================