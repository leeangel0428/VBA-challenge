Sub StockFunzoBananzo():
'To save time and effort, I created one big bad loop that goes through all of the sheets in the workbook
    Dim ws As Worksheet
    For Each ws In ThisWorkbook.Worksheets
' Next I did the easiest task (imo) which is adding headers to the summary tables
            'First summary table
        ws.Range("I1").value = "Ticker"
        ws.Range("J1").value = "Yearly Change"
        ws.Range("K1").value = "Percent Change"
        ws.Range("L1").value = "Total Stock Volume"
            ' Second summary table
        ws.Range("O2").value = "Greatest % Increase"
        ws.Range("O3").value = "Greatest % Decrease"
        ws.Range("O4").value = "Greatest Total Volume"
        ws.Range("P1").value = "Ticker"
        ws.Range("Q1").value = "Value"
            ' To make all the columns true to size and look aesthetically pleasing, I autofit them
        ws.Columns("I:L").AutoFit
        ws.Columns("O:Q").AutoFit
    
    
    ' Then I get into the more complicated stuff which imo is defining all other variables and setting values as I see fit
    Dim ticker As String
    Dim sumrow As Integer
    sumrow = 2
    Dim lastrow As Long ' To get the last row without scrolling all the way down for each sheet
    lastrow = ws.Cells(Rows.Count, 1).End(xlUp).row
    Dim open_price, close_price As Double
    open_price = ws.Cells(2, "C").value
    close_price = 0
    Dim yearly_change, percent_change As Double ' What we need to calculate per instructions
    Dim total_volume As LongLong ' What we need to calculate per instructions
    total_volume = 0
        ' I indented these to remind myself they are Summary Table 2 Variables but it's not a necessary step
        Dim max_increase, max_decrease As Double ' What we need to calculate per instructions
        max_increase = 0
        max_decrease = 0
        Dim max_increase_ticker, max_decrease_ticker As String
        Dim max_volume As LongLong ' What we need to calculate per instructions
        max_volume = 0
        Dim max_volume_ticker As String
        
    ' Once done, I created another loop inside the big bad worksheet loop that will get me everything I need
    For i = 2 To lastrow
        total_volume = total_volume + ws.Cells(i, "G")
        If ws.Cells(i, "A").value <> ws.Cells(i + 1, "A").value Then
            ws.Cells(sumrow, "I").value = ws.Cells(i, "A")
            ws.Cells(sumrow, "J").value = ws.Cells(i, "F") - open_price
            ws.Cells(sumrow, "K").value = (ws.Cells(i, "F") - open_price) / open_price
            ' In order to better differentiate positive and negative changes, I color coordinated
                ' Positive values as Green
            If ws.Range("J" & sumrow).value > 0 Then
                ws.Range("J" & sumrow).Interior.ColorIndex = 4
                ' And Negative values as Red
            Else
                ws.Range("J" & sumrow).Interior.ColorIndex = 3
            End If
            ' In order to make sure my values showed up as a percent and not just a number, I changed the format
            ws.Cells(sumrow, "K").NumberFormat = "0.00%"
            ws.Cells(sumrow, "L").value = total_volume
            
            'In order to calculate for Summary Table 2, I set the percent change
            percent_change = (ws.Cells(i, "F") - open_price) / open_price
            
            ' This ensures everything is printed in it's respective row
            sumrow = sumrow + 1
            ' This makes sure that we get the opening price for each unique ticker
            open_price = ws.Cells(i + 1, "C")
            ' Set ticker for same reason
            ticker = ws.Cells(i, "A")
            If percent_change > max_increase Then
                max_increase = percent_change
                max_increase_ticker = ticker
            ElseIf percent_change < max_decrease Then
                max_decrease = percent_change
                max_decrease_ticker = ticker
            End If
            
            If total_volume > max_volume Then
            max_volume = total_volume
            max_volume_ticker = ticker
            End If
            total_volume = 0
            ' Other than ending all ifs and setting up nexts, last thing I did was print where I want everything to go in Summary Table 2
            ws.Cells(2, "P").value = max_increase_ticker
            ws.Cells(2, "Q").value = max_increase
            ws.Cells(2, "Q").NumberFormat = "0.00%"
            ws.Cells(3, "P").value = max_decrease_ticker
            ws.Cells(3, "Q").value = max_decrease
            ws.Cells(3, "Q").NumberFormat = "0.00%"
            ws.Cells(4, "P").value = max_volume_ticker
            ws.Cells(4, "Q").value = max_volume
            
        End If
    Next i
Next ws
                
End Sub
