Attribute VB_Name = "SearchMissingAccounts"

Sub SearchMissingAccounts()

'
' SearchMissingAccounts Макрос
' Интелектуальная собственность ООО ИК СИБИНТЕК
' Управление Архитектуры Информационной Безопастности

' Prepare document. Stage 1:
    ActiveWindow.ActivePane.VerticalPercentScrolled = 0
    Selection.HomeKey Unit:=wdStory
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .Text = "_cdс" ' _cd(с - кирилическая)
        .Replacement.Text = "_cdc"
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
    End With
    Selection.Find.Execute replace:=wdReplaceAll
' ПPrepare document. Stage 2:
    ActiveWindow.ActivePane.VerticalPercentScrolled = 0
    Selection.HomeKey Unit:=wdStory
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .Text = "_сdc" ' _(с - крилическая)dc
        .Replacement.Text = "_cdc"
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
    End With
    Selection.Find.Execute replace:=wdReplaceAll
' Prepare document. Stage 3:
    ActiveWindow.ActivePane.VerticalPercentScrolled = 0
    Selection.HomeKey Unit:=wdStory
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .Text = " _cdc"
        .Replacement.Text = "_cdc"
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
    End With
    Selection.Find.Execute replace:=wdReplaceAll
' Prepare document. Stage 4:
    ActiveWindow.ActivePane.VerticalPercentScrolled = 0
    Selection.HomeKey Unit:=wdStory
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .Text = " _adm"
        .Replacement.Text = "_adm"
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
    End With
    Selection.Find.Execute replace:=wdReplaceAll
' Prepare document. Stage 5:
    ActiveWindow.ActivePane.VerticalPercentScrolled = 0
    Selection.HomeKey Unit:=wdStory
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .Text = " _skp"
        .Replacement.Text = "_skp"
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
    End With
    Selection.Find.Execute replace:=wdReplaceAll
    
    Dim dlgOpen As FileDialog
    Dim iCountUz As Integer
    Dim dUzList() As String
    Dim dRezList() As Boolean
    Dim sStr As String
              
    Set dlgOpen = Application.FileDialog(msoFileDialogOpen)
        With dlgOpen
         .InitialFileName = Environ("USERPROFILE")
         .AllowMultiSelect = False
        End With
        If dlgOpen.Show = 0 Then Exit Sub
    
    fileImport = FreeFile
    Open dlgOpen.SelectedItems.Item(1) For Input As #fileImport
    
    iCountUz = -1
    Do While Not EOF(fileImport)
        Line Input #fileImport, sUzName
        sUzName = Trim(sUzName)
               
        If Len(sUzName) > 0 Then
        
            iCountUz = iCountUz + 1
            ReDim Preserve dUzList(iCountUz)
            dUzList(iCountUz) = sUzName
        End If
    Loop
    Close fileImport
    MsgBox ("Было успешно импортровано " & Str(iCountUz + 1) & " УЗ.")
    
    ReDim Preserve dRezList(iCountUz)
    
    
    oSB = Application.DisplayStatusBar
    Application.DisplayStatusBar = True
    Application.StatusBar = "Пожалуйста подождите список УЗ обрабатывается."
    For i = 0 To iCountUz
        With ActiveDocument.Content.Find
          .Text = dUzList(i)
          .ClearFormatting
          .MatchWholeWord = True
          .MatchCase = False
          dRezList(i) = .Execute
          Application.StatusBar = "Обработано " & Str(i) & " УЗ из " & Str(iCountUz)
        End With
    Next i
    Application.DisplayStatusBar = False
    
    sFileName = dlgOpen.SelectedItems.Item(1)
    sFileName = Left(sFileName, Len(sFileName) - 3)
    sFileName = sFileName & "_result_find_uz.txt"
    
    Set dlgSave = Application.FileDialog(msoFileDialogSaveAs)
      With dlgSave
       .InitialFileName = sFileName

       End With
       If dlgSave.Show = 0 Then Exit Sub
        
    Set fso = CreateObject("scripting.filesystemobject")
    Set file = fso.CreateTextFile(dlgSave.SelectedItems.Item(1), True)
    
    For i = 0 To iCountUz
        If dRezList(i) = False Then
            sStr = dUzList(i)
'            sStr = Format(dUzList(i), "!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
'            sStr = sStr & dRezList(i)
            file.WriteLine sStr
        End If
    Next i
    file.Close
    Dim x As Variant
    x = Shell("notepad.exe" & " " & dlgSave.SelectedItems.Item(1), 1)
End Sub

  
