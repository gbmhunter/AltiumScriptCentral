========================
Altium Scripts
========================

----------------------------------------------------------
A collection of useful Altium scripts.
----------------------------------------------------------

- Author: gbmhunter <gbmhunter@gmail.com> (http://www.cladlab.com)
- First Ever Commit: 2013/08/08
- Last Modified: 2013/08/16
- Version: v3.0.0.0
- Company: CladLabs
- Language: Delphi
- Compiler: Altium Script Engine
- uC Model: n/a
- Computer Architecture: n/a
- Operating System: n/a
- Documentation Format: n/a
- License: GPLv3

Description
===========

ChangeDesignatorFontSize.pas
----------------------------
A Altium script, written in Delphi, that changes the font size (width and height) of all component designators on the PCB.

PlaceNettedVia.pas
------------------
Allows you to copy a via and then place many copies, preserving the original connected net (Altium does not do this, unless to do a special paste).

Pre-Release Checks
------------------

Pre-release checks are designed to be run before the board is released to the manufacturer.

CheckLayers
-----------

Checks that the mechanical layers of the PCB have the correct objects on them.

CheckNoSupplierPartNumShown
---------------------------

Checks that no supplier part numbers are shown on the schematics.

CheckPowerPortOrientation
-------------------------

Checks that power ports are orientated in the correct way. Ground pins are meant to face downwards and the bar symbol upwards.

External Dependencies
=====================

None.

Issues
======

See GitHub Issues.

Limitations
===========

Coming soon...

Usage
=====

Add the scripts to your current project, and then run the scripts from Altium by holding Alt and pressing X, S.
	
Changelog
=========

======== ========== ===================================================================================================
Version  Date       Comment
======== ========== ===================================================================================================
v3.0.0.0 2013/08/16 Added layer check script, which checks that PCB layers have the correct objects on them.
v2.0.0.0 2013/08/15 Added pre-release checks folder, with port symbols and supplier part number checks. Added main form to run these from. Added relevant sections to the README. Added script project to root directory.
v1.1.0.0 2013/08/14 Added PlaceNettedVia.pas. Changed name to AltiumScripts (repo will now hold all scripts). Added basic usage and updated 'External Dependencies' in README. Moves scripts into the src/ directory.
v1.0.0.0 2013/08/08 Initial commit. Script written and tested (it works). 
======== ========== ===================================================================================================