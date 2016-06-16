===================
AltiumScriptCentral
===================

-----------------------------------------------------------
A collection of useful Altium scripts, written in VBScript.
-----------------------------------------------------------

.. image:: https://cloud.githubusercontent.com/assets/2396869/5656925/3679bc36-9749-11e4-93a7-aa8271eb1221.png
	:height: 500px
	:align: right

- Author: gbmhunter <gbmhunter@gmail.com> (www.mbedded.ninja)
- First Ever Commit: 2013-08-08
- Last Modified: 2016-05-09
- Version: v25.1.0
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

Welcome to AltiumScriptCentral! A collection of useful scripts to enhance the capabilities of Altium Designer, a popular EDA software program.

When run, modules save user defaults in the file :code:`%UserProfile%/AltiumScriptCentral_UserData.ini` so that they automatically appear in the fields next time the module is run again.

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


Project Tools
=============

Checks
------

Checks are scripts designed to be run before the board is released to the manufacturer. All are located in :code:`src/Checks/`. 

======================================== ==================================================================
Filename                                 Description
======================================== ==================================================================
CheckComponentLinks.vbs                  Loads up the "Edit Component Links" window so that you can make sure there are no missing component links. 
CheckEmbeddedImages.vbs                  Makes sure that all schematic images are embedded, so that they will display on other people's computers (or whenever the original image file moves).
CheckLayers.vbs                          Checks that the mechanical layers of the PCB have the correct objects on them.
CheckNameVersionDate.vbs                 Checks that the version and date of the project are included as silkscreen text somewhere on the PCB.
CheckNoSupplierPartNumShown.vbs          Checks that no supplier part numbers are shown on the schematics.
CheckPcbCompDesignatorRotation.vbs       Checks that there are no component designators on the PCB which are rotated 180 degrees with respect to one other.
CheckPcbCompPrimitivesLocked.vbs         Checks to make sure all PCB component primitives are locked. 
CheckPcbTextHasCorrectOrientation.vbs    Checks that PCB text has the correct orientation (so it is readable), that is text on the top overlay IS NOT mirrored, and text on the bottom layer IS mirrored.
CheckProjectCompiles.vbs                 Makes sure that the project compiles successfully.
CheckTentedVias.vbs                      Checks that a certain proportion of the vias are fully tented. If the ratio is less than a threshold, the script assumes you have forgotten to tent vias. Some are allowed to not be tented for test-point purposes.
PowerPortChecker.vbs                     Checks that power ports are orientated in the correct way. Ground pins are meant to face downwards and the bar symbol upwards.
======================================== ==================================================================

The following component validators are run as part of the pre-release checks.

The component validator checks makes sure that all the schematic components have recognised designators and are showing the correct parameters (which is dependent on the component type, as given by the designator). All component validator scripts are located in :code:`src/Checks/ComponentValidators`.

======================================== ==================================================================
Filename                                 Description
======================================== ==================================================================
ComponentValidator.vbs                   This is essentially the "main" file for the component validators. It is called by Main.vbs and in turn calls the individual component validator files, once it recognises a valid designator (the valid designators are contained in Config.vbs).
ValidateCapacitor.vbs                    Makes sure that all the capacitors on the schematic are showing the correct parameters.
ValidateInductor.vbs                     Makes sure that all the inductors on the schematic are showing the correct parameters.
ValidateResistor.vbs                     Makes sure that all the inductors on the schematic are showing the correct parameters.
======================================== ==================================================================

The following designators are allowed:

========== ======================
Designator Name                
========== ======================
BT         Battery
C          Capacitor
D          Diode
E          Antenna
F          Fuse
FB         Ferrite bead
J          Jack
L          Inductor
M          Motor
MP         Mechanical part
P          Connector (plug)
PV         Solar panel
Q          Transistor
R          Resistor
RV         Varistor
SW         Switch
T          Transformer
TP         Test point
U          IC
VR         Variable resistor
W          Cable
XC         Crystal/oscillator
XF         Fuse holder
=================================

Exit Active Command
-------------------

File: :code:`src/Tools/ExitActiveCommand.vbs`

Allows you to save a project if you ever get stuck with the error message "Command is currently active" when trying to save. Just run this script once and you should be able to save again (and not lose your work!). Error is normally the result of a buggy script or a script which crashed before it could call :code:`PCBServer.PostProcess`.

.. image:: https://cloud.githubusercontent.com/assets/2396869/5852796/4172ab46-a281-11e4-9ce7-e3186fffa5b9.png
	:height: 500px
	:align: right

Schematic Tools
===============

Add Special Schematic Parameters
--------------------------------

File: :code:`src/Tools/AddSpecialSchParam.vbs`

Provides you with the option of adding various special parameters to all the schematic documents in the currently active project.

Delete Schematic Parameters
-------------------------------

File: :code:`src/Tools/DeleteSchematicParameters.vbs`

Deletes a user-selectable range of schematic parameters from schematic sheets belonging to the currently active project. I wrote this after I found it was impossible to manually delete some schematic parameters that had been previously added with a script. Also useful for getting rid of all the default parameters Altium adds.

.. image:: https://cloud.githubusercontent.com/assets/2396869/5885439/be78ef1e-a3d1-11e4-9c83-b85761e3bf58.png
	:height: 500px
	:align: right

Push Project Parameters To Schematics
-------------------------------------

File: :code:`src/Tools/PushProjectParametersToSchematics.vbs`

Copies all project parameters to the schematic documents, which can be useful for automatically filling in title block information (using special strings).

NOTE: This tool has been made somewhat redundant with the update to Altium Designer 13, which makes schematic sheets automatically inherit project parameters if there is no local sheet parameter with the same name.

Schematic Component Parameter Stamper
-------------------------------------

File: :code:`src/Schematics/SchCompParamStamper.vbs`

Copies the parameter visibility settings from a source schematic component to a destination schematic component. Useful for people who like to show many of the component's parameters on the schematic for information purposes, and don't want to go and manually unhide all of the parameters for duplicate components.

Swap Designators
----------------

File: :code:`src/Schematics/SwapSchematicDesignators.vbs`

Allows the user to quickly swap pairs of schematic component designators (e.g. switch the text U9 with U11). This is useful when adjusting the layout of the PCB, and you want to swap two components with the same footprint, without actually having to switch them around on the PCB.

PCB Tools
=========

Current Calculator
------------------

File: :code:`src/Tools/CurrentCalculator.vbs`

Allows the user to calculate the the maximum allowed current of a particular track or via on a PCB for a given temperature rise. Calculated in accordance with the equations in IPC-2221A Section 6.2 (formerly IPC-D-275).

Note: For via current calculations, the value used for the k constant is the worst-case value (the same for an internal track).

Based on the calculator found at `http://www.mbedded.ninja/online-calculators/pcb-design/track-width-calculator 
<http://www.mbedded.ninja/online-calculators/pcb-design/track-width-calculator>`_.

Draw Polygon
------------

File: :code:`src/Tools/DrawPolygon.vbs`

Allows you to easily draw a polygon on a PCB. You can specify the number of sides, the size (using either the vertex radius, the edge radius, or the edge length as a metric), the track width, the rotation, and more.

.. image:: https://cloud.githubusercontent.com/assets/2396869/5852673/712546a2-a27f-11e4-9a8f-b2991c9b666b.png
	:height: 500px
	:align: right

Resize Designators
------------------

File: :code:`src/Tools/ResizeDesignators.vbs`

Changes the font size (width and height) of all component designators on the PCB.

Rotate Designators
------------------

File: :code:`src/Tools/RotateDesignators.vbs`

Rotates all PCB component designators so that they are rotated to only 1 of 2 positions.

Statistics
----------

File: :code:`src/Stats/Stats.vbs`

PCB statistics can be displayed by clicking the "Display PCB Stats" button from the main script window. This displays useful PCB information such as: number of vias (normal, blind, buried and total), num. pads with plated holes, num. pads with unplated holes, total num. holes, smallest and largest hole sizes, number of different hole sizes, smallest annular ring, minimum track width, number of copper layers, board width, board height, and board area. 

.. image:: https://cloud.githubusercontent.com/assets/2396869/5850288/6e920948-a257-11e4-856d-1e342a88229e.png
	:height: 500px
	:align: right


This information can be useful to both the PCB designer and the PCB manufacturer.

All code for this is located in :code:`src/Stats`.

Via Stamper
-----------

File: :code:`src/Tools/ViaStamper.vbs`

Allows you to copy a via and then place many copies, preserving the original connected net (Altium does not do this, unless you do a special paste).


Issues
======

See GitHub Issues.

Usage
 
1. Add the AltiumScriptCentral project (:code:`AltiumScriptCentral.PrjScr`) to your current Altium workspace.
2. Open the "DXP->Run Script" window by holding Alt, and then pressing X, S.
3. Run AltiumScriptCentral by selecting "AltiumScriptCentral.PrjScr->Main.vbs->RunAltiumScriptCentral" from the "Select script to run" window.

Unfortunately, Altium does not show the project files in the 'Projects' pane of Altium Designer in the same hierarchy as in the repository. This can be confusing when you are trying to find a particular script. I have ordered them alphabetically to help with this.
	
Changelog
=========

See :code:`changelog.md`.