############################ SETTINGS START ############################
#IMPORT CHROME WEB-DRIVER MODUL
If (-not (Import-Module $HOME\Documents\WindowsPowerShell\Driver\WebDriver.dll -ErrorAction Stop)) {
  Write-Host "Importing WebDriver module for the current user..."
}

#URL LIST
$SaturnUrl = "https://www.saturn.de/de/product/_sony-ps5-assassins-creed-valhalla-2715828.html"
$MediaMarktUrl = "https://www.mediamarkt.de/de/product/_sony-playstation%C2%AE5-2661938.html"                                 #same xPath like Saturn-Webpage
#$ConradUrl = "https://www.conrad.de/de/aktionen/product-promotions/sony-ps5.html" #//*[@id="text-d375490a45"]/h2

#ARRAY
$UrlArrays = @("$SaturnUrl", "$MediaMarktUrl")
$ArrayValue = 0

############################# SETTINGS END #############################

while ($ArrayValue -lt 2) {

#START CHROME WEB-DRIVER
$ChromeWindow = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$ChromeWindow.Navigate().GoToURL($UrlArrays[$ArrayValue])
$wbPg = $ChromeWindow.FindElementByXPath(‘//*[@id="root"]/div[2]/div[3]/div[1]/div/div[4]/div/div/div[3]/div/span’)

#SEND PUSH-MESSAGE TO PHONE
$WirePushApp = "https://wirepusher.com/send?id=[PLACE YOUR ID HERE] PS5 Verfügbar!&message=PS5 verfügbar bei diesem Händler: &type=Default&message_id=10 &action=" + $UrlArrays[$ArrayValue] + ""                          #ID without brackets / delete them before use

#CAN BE ORDERED [FALSE]
If($wbPg.Text -match "Dieser Artikel ist aktuell nicht verfügbar." -or $wbPg.Text -match "Dieser Artikel ist bald wieder für Sie verfügbar"){                          #edit these parts if your not browsing to a german Version of these websites or your browser-language is not german
    Write-Host -ForegroundColor Red "Aktuell keine PS5"
    Write-Host -ForegroundColor Yellow "Versuche es später nochmal."
    $ChromeWindow.Quit() #$ChromeWindow.Close()
    $ArrayValue++
}

#CAN BE ORDERED [TRUE]
else{
    Write-Host -ForegroundColor Green "PS5 vielleicht verfügbar!"
    $ChromeWindow.Quit() #$ChromeWindow.Close()
    $ArrayValue++                                                                                       #Set $ArrayValue = 2 if you want to stop here
    Write-Host -ForegroundColor Yellow "Nachricht wird an Telefon gesendet..."
    Invoke-WebRequest -Method Get -Uri $WirePushApp -UseBasicParsing
    Write-Host -ForegroundColor Green "Nachricht gesendet!"
}
}