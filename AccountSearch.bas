Sub SearchMissingAccounts()
    Dim dlgOpen As FileDialog
    Dim iCountUz As Integer
    Dim dUzList() As String
    Dim dRezList() As Boolean
    Dim sStr As String
    Dim fileImport As Integer
    Dim sUzName As String
    Dim ws As Worksheet
    Dim cell As Range
    Dim found As Boolean
    Dim dlgSave As FileDialog
    Dim fso As Object
    Dim file As Object
    Dim sFileName As String
    Dim i As Integer
    
    ' Open file dialog to select the TXT file
    Set dlgOpen = Application.FileDialog(msoFileDialogOpen)
    With dlgOpen
        .InitialFileName = Environ("USERPROFILE")
        .AllowMultiSelect = False
    End With
    
    If dlgOpen.Show = 0 Then Exit Sub
    
    fileImport = FreeFile
    Open dlgOpen.SelectedItems.Item(1) For Input As #fileImport
    
    ' Read UZ names from the selected TXT file
    iCountUz = -1
    Do While Not EOF(fileImport)
        Line Input #fileImport, sUzName
        sUzName = Trim(sUzName)
               
        If Len(sUzName) > 0 Then
            iCountUz = iCountUz + 1
            ReDim Preserve dUzList(iCountUz)
            dUzList(iCountUz) = LCase(sUzName) ' Convert to lowercase
        End If
    Loop
    Close fileImport
    
    MsgBox "Loaded " & Str(iCountUz + 1) & " UZ names."
    
    ReDim dRezList(iCountUz)
    
    ' Searching for UZ in the Excel sheets
    Application.StatusBar = "Searching for UZ in the workbook..."
    
    For i = 0 To iCountUz
        found = False
        For Each ws In ThisWorkbook.Sheets
            For Each cell In ws.UsedRange
                ' Remove domain prefix, trim spaces and convert to lowercase
                Dim cellValue As String
                cellValue = LCase(Trim(CStr(cell.Value)))
                If InStr(cellValue, "\") > 0 Then
                    cellValue = Split(cellValue, "\")(1)
                End If
                
                ' Check if cleaned-up cell value matches the UZ name
                If cellValue = dUzList(i) Then
                    found = True
                    Exit For
                End If
            Next cell
            If found Then Exit For
        Next ws
        dRezList(i) = found
        Application.StatusBar = "Processing " & Str(i + 1) & " of " & Str(iCountUz + 1)
    Next i
    
    Application.StatusBar = False
    
    ' Save the missing UZ to a TXT file
    sFileName = dlgOpen.SelectedItems.Item(1)
    sFileName = Left(sFileName, Len(sFileName) - 4) & "_result_find_uz.txt"
    
    Set dlgSave = Application.FileDialog(msoFileDialogSaveAs)
    With dlgSave
        .InitialFileName = sFileName
    End With
    
    If dlgSave.Show = 0 Then Exit Sub
    
    Set fso = CreateObject("scripting.filesystemobject")
    Set file = fso.CreateTextFile(dlgSave.SelectedItems.Item(1), True)
    
    For i = 0 To iCountUz
        If Not dRezList(i) Then
            sStr = dUzList(i)
            file.WriteLine sStr
        End If
    Next i
    file.Close
    
    MsgBox "Missing UZ saved to: " & dlgSave.SelectedItems.Item(1)
    
    Dim x As Variant
    x = Shell("notepad.exe " & dlgSave.SelectedItems.Item(1), 1)
End Sub