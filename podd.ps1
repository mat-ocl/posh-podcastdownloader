$myFolder = "ChicaneSunsets"
$podcast_url = "http://portal-api.thisisdistorted.com/xml/chicane-presents-sun-sets"
$podcastfeed = Invoke-RestMethod -Uri $podcast_url
$all = $podcastfeed.Count
$received = 0
$podi = 0

$podcastfeed | Add-Member -MemberType NoteProperty -Name folder -Value $myFolder

$podcastfeed | Foreach-Object -Parallel {
    $podi += 1
    
    $filename = Select-Xml -Xml $_ -XPath "//title" | ForEach-Object {$_.node.InnerXML} 
    if($filename -match "<![[]CDATA[[](?<title>.*)[]][]]>")
    {
        $filename = $Matches.title
    }
    
    $filename = [System.Web.HttpUtility]::HtmlDecode($filename.Split([IO.Path]::GetInvalidFileNameChars()) -join '_')
    $filename += ".mp3"
    $folder = $_.folder
    Write-Host "./$folder/$filename"
    $ProgressPreference = 'SilentlyContinue'

    if(!(Test-Path "./$folder"))
    {
        New-Item -ItemType Directory -Path "./$folder"
    }

    if(!(Test-Path "./$folder/$filename" -PathType Leaf))
    {
        Invoke-WebRequest -Uri $_.enclosure.url -OutFile "./$folder/$filename"
        $_
    }
} -ThrottleLimit 10 | ForEach-Object { 
    $received += 1
    [int] $percentComplete = ($received / $all) * 100
    $ProgressPreference = 'Continue'
    Write-Progress -Activity Downloads -Status "$percentComplete% complete" -PercentComplete $percentComplete
}

Write-Host "Downloaded $received of $all podcasts"
