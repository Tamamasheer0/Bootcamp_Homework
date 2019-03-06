'/  [Excel VBA Scripting] The VBA of Wallstreet
'/  Created By: Ryan Tamashiro
'/**********************************************************************************
'/  **READ ME**
'/
'/  (Moderate) Assignment Instructions:
'/      - Create a script that will loop through all the stock and take the following
'/        info:
'/              - Yearly Change (Open to Close)
'/              - Percent Change (Open to Close)
'/              - Total Volume of the Stock
'/              - Ticker Symbol
'/
'/      - Conditional formatting:
'/              - Positive changes >> Green
'/              - Negative chages >> Red
'/
'/  (Hard) Assignment Instructions:
'/      - Include all moderate challenges.
'/      - Locate stock with the greatest %increase, greatest %decrease, greatest
'/        total volume.
'/
'/  Other Considerations:
'/      - Script runs on all worksheet at the click of a single button.
'/      - Should run on alphabetical_testing.xlsx in less than 3-5 minutes.
'/      - Make sure script runs the same on each worksheet.
'/**********************************************************************************
Option Explicit

Private Enum ToggleSetting:
    Enable = -1
    Disable = 0
End Enum

'/**********************************************************************************
'/                  [Main/Run Procedure]                                           *
'/**********************************************************************************
Sub Run_The_VBA_of_Wallstreet_Hard():
'/  Created On: 03/04/2019                  Last Modified: 03/04/2019
'/  Description:
'/----------------------------------------------------------------------------------
Dim wsYear      As Worksheet

    Debug.Print "Start Time: "; Now()
    Call Excel_Application_Settings(Toggle:=Enable)
    
    For Each wsYear In ThisWorkbook.Worksheets
        Debug.Print "Current Worksheet: "; wsYear.Name
        Call Run_Stock_Calculations(wsData:=wsYear)
        Call Format_And_Summarize_Data(wsData:=wsYear)
    Next wsYear

    Call Excel_Application_Settings(Toggle:=Disable)
    Debug.Print "End Time: "; Now()
End Sub

'/**********************************************************************************
'/                  [Reset Button]                                                 *
'/**********************************************************************************
Sub Reset_Test_Worksheet():
Dim wsYear  As Worksheet
Dim Reset   As Range
Dim LastRow As Long
    
    Call Excel_Application_Settings(Toggle:=Enable)
    For Each wsYear In ThisWorkbook.Worksheets
        With wsYear
            LastRow = .Cells(Rows.Count, "I").End(xlUp).Row
            Set [Reset] = .Range(.Cells(1, "I"), .Cells(LastRow, "Q"))
                [Reset].ClearContents
                [Reset].ClearFormats
        End With
    Next wsYear
    Call Excel_Application_Settings(Toggle:=Disable)
End Sub

'/**********************************************************************************


Sub Format_And_Summarize_Data(wsData As Worksheet):
'/  Created On: 03/05/2019                  Last Modified: 03/05/2019
'/  Description: Performs the Following Actions on Data Output
'/               - Highlights Positive(Green) & Negative(Red) Values
'/               - Finds Ticker w/ Greatest Percent Increase
'/               - Finds Ticker w/ Greatest Percent Decrease
'/               - Finds Ticker w/ Greatest Total Volume
'/               - Outputs Findings in Summary Box
'/----------------------------------------------------------------------------------
Dim StockWSSummary      As Range
Dim SummaryData         As Range
Dim TickerSummary       As Range
Dim TickerIncrease      As String
Dim TickerDecrease      As String
Dim TickerVolume        As String
Dim HighestPctIncrease  As Double
Dim HighestPctDecrease  As Double
Dim HighestVolume       As Double
Dim LastRow             As Long

    LastRow = wsData.Cells(Rows.Count, "J").End(xlUp).Row
    Set [SummaryData] = wsData.Range(wsData.Cells(2, "I"), _
                                     wsData.Cells(LastRow, "L"))
    
    'Set Initial Highest Increase/Decrease/Volume
    With [SummaryData]
        TickerIncrease = .Cells(1, 1)
        HighestPctIncrease = .Cells(1, 3)
        
        TickerDecrease = .Cells(1, 1)
        HighestPctDecrease = .Cells(1, 3)
        
        TickerVolume = .Cells(1, 1)
        HighestVolume = .Cells(1, 4)
    End With
    
    For Each [TickerSummary] In [SummaryData].Rows
        With [TickerSummary]
            'Check For Lowest/Highest Increases & Decreases
            If (.Cells(1, 3) > HighestPctIncrease) Then
                TickerIncrease = .Cells(1, 1)
                HighestPctIncrease = .Cells(1, 3)
            ElseIf (.Cells(1, 3) < HighestPctDecrease) Then
                TickerDecrease = .Cells(1, 1)
                HighestPctDecrease = .Cells(1, 3)
            End If
        
            'Check For Highest Volume Activity
            If (.Cells(1, 4) > HighestVolume) Then
                TickerVolume = .Cells(1, 1)
                HighestVolume = .Cells(1, 4)
            End If
            
            'Format Cell Color Based on Positive/Negative Change
            If (.Cells(1, 2) > 0) Then
                .Cells(1, 2).Interior.Color = vbGreen
                .Cells(1, 2).Font.Bold = True
            
            ElseIf ([TickerSummary].Cells(1, 2) < 0) Then
                .Cells(1, 2).Interior.Color = vbRed
            End If
        End With
    Next [TickerSummary]
    
    'Print Summary Statistics
    Set [StockWSSummary] = wsData.Range(wsData.Cells(1, "O"), wsData.Cells(4, "Q"))
    With [StockWSSummary]
        .Cells(2, 1) = "Greatest % Increase"
        .Cells(3, 1) = "Greatest % Decrease"
        .Cells(4, 1) = "Greatest Total Volume"
        .Cells(1, 2) = "Ticker"
        .Cells(2, 2) = TickerIncrease
        .Cells(3, 2) = TickerDecrease
        .Cells(4, 2) = TickerVolume
        .Cells(1, 3) = "Value"
        .Cells(2, 3) = Format(HighestPctIncrease, "##.##%")
        .Cells(3, 3) = Format(HighestPctDecrease, "##.##%")
        .Cells(4, 3) = Format(HighestVolume, "#,###,###,###")
        
        .HorizontalAlignment = xlCenter
        .Rows(1).Font.Bold = True
        .Columns(1).HorizontalAlignment = xlLeft
        .EntireColumn.AutoFit
    End With
    
End Sub

Sub Run_Stock_Calculations(wsData As Worksheet)
'/  Created On: 03/04/2019                  Last Modified: 03/04/2019
'/  Description: Peforms the following calculations for each stock ticker
'/                 - Yearly Change
'/                 - Percent Change
'/                 - Total Stock Volume
'/----------------------------------------------------------------------------------
Dim DataRange       As Range
Dim StockData       As Variant
Dim CurrTicker      As String
Dim NextTicker      As String
Dim TickerVolume    As Double
Dim StartRow        As Long
Dim EndRow          As Long
Dim LastRow         As Long
Dim LastCol         As Long
Dim NextSumRow      As Long
Dim i               As Long
    
    With wsData
        .Cells(1, "I") = "<ticker_sum>"
        .Cells(1, "J") = "<dollar_change>"
        .Cells(1, "K") = "<percent_change>"
        .Cells(1, "L") = "<total_volume>"
        
        LastRow = (.Cells(Rows.Count, "A").End(xlUp).Row) + 1
        LastCol = .Cells(1, Columns.Count).End(xlToLeft).Column
        Set [DataRange] = .Range(.Cells(2, "A"), _
                                 .Cells(LastRow, LastCol))

        ReDim StockData(1 To LastRow, 1 To LastCol)
              StockData = [DataRange]
    
        StartRow = 1
        TickerVolume = StockData(1, 7)
        CurrTicker = StockData(1, 1)
    
        For i = 2 To UBound(StockData)
            NextTicker = StockData(i, 1)
        
            If CurrTicker = NextTicker Then
                TickerVolume = TickerVolume + StockData(i, 7)
            
            ElseIf CurrTicker <> NextTicker Then
                EndRow = i - 1
                NextSumRow = (.Cells(Rows.Count, "I").End(xlUp).Row) + 1
                
                On Error Resume Next
                .Cells(NextSumRow, "I") = CurrTicker
                .Cells(NextSumRow, "J") = StockData(EndRow, 6) - StockData(StartRow, 3)
                .Cells(NextSumRow, "K") = (StockData(EndRow, 6) - StockData(StartRow, 3)) _
                                          / StockData(StartRow, 3)
                .Cells(NextSumRow, "L") = TickerVolume
                On Error GoTo 0
                
                StartRow = i
                EndRow = 0
                CurrTicker = NextTicker
                TickerVolume = StockData(i, 7)
            End If
        Next i
        
        .Cells.Columns.AutoFit
    End With
 End Sub

Private Sub Excel_Application_Settings(Toggle As ToggleSetting)
    If Toggle = Enable Then
        With Application
            .ScreenUpdating = False
            .EnableEvents = False
            .DisplayAlerts = False
            .Calculation = xlCalculationManual
        End With
    ElseIf Toggle = Disable Then
        With Application
            .ScreenUpdating = True
            .EnableEvents = True
            .DisplayAlerts = True
            .Calculation = xlCalculationAutomatic
        End With
    End If
End Sub



