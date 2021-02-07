$searchPaths = @("C:\xxx\", "C:\xxx\") #! backslash at the end; number of folders doesn't matter

function searchFolder()
{
    $invoked = $false
    foreach($path in $searchPaths)
    {
        if(Test-Path -Path $($path + $searchBox.text))
        {
            Invoke-Item -Path $($path + $searchBox.text) 
            $invoked = $true
        }
        else
        {
            #search in subFolders
            $resultPath = Get-ChildItem -Path $path -Recurse | Where-Object -Property name -EQ $searchBox.text | Select-Object -Property FullName
            if($resultPath)
            {
                Invoke-Item -Path $resultPath.FullName
                $invoked = $true
            }
        }
    }
    
    if(!$invoked)
    {
        $errorMsg.Text = "Dieser Pfad existiert nicht!"
    }
    else
    {
        $errorMsg.Text = ""
    }
}

$searchButtonClick = 
{
    searchFolder
}

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$objForm = New-Object System.Windows.Forms.Form
$objForm.Width = 300
$objForm.Height = 300

$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Location = New-Object System.Drawing.Size(50,20)
$searchBox.Size = New-Object System.Drawing.Size(200,20)
$searchBox.Add_KeyDown({
                            if($_.KeyCode -eq "Enter")
                            {
                                searchFolder
                            }
                       })
$objForm.Controls.Add($searchBox)

$searchButton = New-Object System.Windows.Forms.Button
# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
$searchButton.Location = New-Object System.Drawing.Size(100,50)
$searchButton.Size = New-Object System.Drawing.Size(100,23)
$searchButton.Text = "Suchen"
$searchButton.Name = "Suchen"
#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
$searchButton.Add_Click($searchButtonClick)
$objForm.Controls.Add($searchButton)

$errorMsg = New-Object System.Windows.Forms.label
$errorMsg.Location = New-Object System.Drawing.Size(75,90)
$errorMsg.Size = New-Object System.Drawing.Size(150,15)
$errorMsg.BackColor = "Transparent"
$errorMsg.ForeColor = "red"
$errorMsg.Text = ""
$objForm.Controls.Add($errorMsg)

[void] $objForm.ShowDialog()
