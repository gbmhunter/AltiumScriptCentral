'
' @file               UserData.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2015-04-23
' @last-modified      2015-04-23
' @brief              Routines to help us save and retrieve data.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Function SaveUserData(moduleName, key, stringToSave)

    'ShowMessage("Saving data")

    'ResetParameters
    'AddStringParameter "Dialog", "FileOpenSave"
    'AddStringParameter "Mode", "1"
    'AddStringParameter "Prompt", "Select a document then click OK"
    ''AddStringParameter "FileType1", "Comma Separated Values (*.csv)\|*.csv')"
   ' RunProcess "Client:RunCommonDialog"

    Dim path
    path = GetUsersHomeFolder(null) + "\" + DEFAULT_FILE_NAME_FOR_USER_DATA + ".ini"
    'ShowMessage("Path = " + path)

    ' Creating INI file. INI files are great for saving
    ' config data
    ' ShowMessage("Creating INI file...")
    Dim iniFile
    iniFile = TIniFile.Create(path)
    'iniFile.WriteBool "test1", "test2", true
    iniFile.WriteString moduleName, key, stringToSave

    ' File will be closed automatically!!!

    'RunProcess("Client:RunCommonDialog")

    'Dim saveDialog
    'saveDialog = TSaveDialog.Create(Application)
    'RunProcess(".Title = ")
    'saveDialog.Title = "Save file"

    'ShowMessage("Calling .Execute")
    'Dim flag
    'flag = SaveDialog.Execute
    'If flag Is 0 Then
    '    Exit Function
    'End If

    'Dim fileName
    'fileName = SaveDialog.FileName

End Function

Function GetUserData(moduleName, key)

    'ShowMessage("GetString called.")

    Dim path
    path = GetUsersHomeFolder(null) + "\" + DEFAULT_FILE_NAME_FOR_USER_DATA + ".ini"
    Dim iniFile
    iniFile = TIniFile.Create(path)
    'iniFile.WriteBool "test1", "test2", true
    Dim stringToRetrieve
    'ShowMessage("Reading key = '" + key + "' from module = '" + moduleName + "'.")
    stringToRetrieve = iniFile.ReadString(moduleName, key, "")

    'ShowMessage("Read string = '" + stringToRetrieve + "'.")
    GetUserData = stringToRetrieve

End Function


