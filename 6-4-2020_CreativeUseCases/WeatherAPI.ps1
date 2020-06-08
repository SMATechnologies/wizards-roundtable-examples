param(
    $opencageKey     # OpenCage API key: https://opencagedata.com/api
    ,$openweatherKey # Open Weather API Key: https://openweathermap.org/guide
    ,$city = "77032" # Zip or City where you want to find weather Ex. "HOUSTON+TX"
)

$coords = Invoke-RestMethod -Uri ("https://api.opencagedata.com/geocode/v1/json?q=" + $city + "&key=" + $opencageKey) -Method GET -ContentType "application/json"
$weather = Invoke-RestMethod -Uri ("https://api.openweathermap.org/data/2.5/onecall?lat=" + $coords.results[0].geometry.lat +"&lon="+ $coords.results[0].geometry.lng +"&units=imperial&APPID=" + $openweatherKey) -Method GET -ContentType "application/json"

Write-Host "`r`nWeather forecast for"$coords.results[0].components.city"`r`n"
Write-Host "---------------------------------------`r`n"

$weather.daily | ForEach-Object{
                                    $utctime = $_.dt
                                    [datetime]$origin = '1970-01-01 00:00:00'
                                    $date = $origin.AddSeconds($utctime)
                                    ($date.DayOfWeek.ToString() + " - " + $date.Month.ToString() + "/" + $date.Day.ToString() + "/" + $date.Year.ToString())
                                    Write-Host "High Temp:"$_.temp.max"F`r`n"
                                    Write-Host "Weather:"$_.weather[0].description"`r`n`r`n"
                                }