'
' @file               ExitActiveCommand.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2015-01-16
' @last-modified      2015-01-16
' @brief              Main entry point for AltiumScriptCentral.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "ExitActiveCommand.vbs"

Sub ExitActiveCommand(DummyVar)
    PCBServer.PostProcess
End Sub
