
############ Create GUI and populate Dropdown menu
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = "Please Select a School"
$main_form.Width = 400
$main_form.Height = 150

$Combobox = New-Object System.Windows.Forms.Combobox
$Combobox.Width = 300
$schoolName = "Apollo", "Cortez", "Greenway", "Independence", "Moonvalley", "OLA", "Sunnyslope", "Test", "Thunderbird", "Washington"
$Combobox.Location = New-Object System.Drawing.Point(40,20)

Foreach ($School in $schoolName){
    $Combobox.Items.Add($school)
}

$button_Continue = New-Object System.Windows.Forms.Button
$button_Continue.Location = New-Object System.Drawing.Size(125,65)
$button_Continue.Size = New-Object System.Drawing.Size(120,23)
$button_Continue.Text = "Ok"

$main_form.Controls.Add($Combobox)
$main_form.Controls.Add($button_Continue)
$main_form.ShowDialog()

$button_Continue.Add_Click({
    $main_form.close()
})

################ Create path file idlink.txt

$Global:school_Select = $Combobox.SelectedItem

$readPath = "T:\Bookstore\PIMS\2021-22PIMS\" + $Global:school_Select +"\Images"
$writePath = "T:\Bookstore\PIMS\2021-22PIMS\" + $Global:school_Select +"\Images\idlink.txt"
get-childitem -Path $readPath | `
    Select-Object BaseName,Name | ConvertTo-Csv -Delimiter ',' -NoTypeInformation | `
    ForEach-Object { $_ -replace """" ,""} | `
    set-content $writePath -force

################ Create .zip file in School Image directory

$zipFile = @{
    Path = "T:\Bookstore\PIMS\2021-22PIMS\" + $Global:school_Select +"\Images\*"
    CompressionLevel = "Fastest"
    DestinationPath = "T:\Bookstore\PIMS\2021-22PIMS\" + $Global:school_Select +"\Images\" + $Global:school_Select + "" + '_Import' +""
}
Compress-Archive @zipFile -Force

######## Generate Dialog on completion. Still need to figure out how to make this contextual. 

$ButtonType = [System.Windows.Forms.MessageBoxButtons]::OK
$MessageIcon = [System.Windows.Forms.MessageBoxIcon]::Information
$MessageBody = "File created at T:\Bookstore\PIMS\2021-22PIMS\" + $Global:school_Select +"\Images"
$MessageTitle = "File Created Successfully"
[System.Windows.Forms.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

exit