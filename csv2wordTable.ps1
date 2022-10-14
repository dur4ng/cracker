$csvFile ='result.csv'

$wd = New-Object -comobject word.application
$wd.Visible = $true
$doc = $wd.Documents.Add()
$Selection = $Wd.Selection

#create table from CSV text
$range = $doc.Range()
$range.Text = Get-Content $CSVFile -raw
$table = $range.ConvertToTable([Microsoft.Office.Interop.Word.WdTableFieldSeparator]::wdSeparateByCommas)

# create style and apply to table
#$table.Style = "Grid Table 4 - Accent 5"