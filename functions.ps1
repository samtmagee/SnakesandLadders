function Invoke-Role {
    param (
        [int]$sides = 6
    )
    Get-Random -Minimum 1 -Maximum $sides
}
$sleep = 500
$board = Import-Csv C:\GITHub\SnakesandLadders\board.csv

$ladderBottomLocations = $board | Where-Object { $_.'Type' -eq 'Ladder Bottom' } | Select-Object 'Location'
$ladderTopLocations = $board | Where-Object { $_.'Type' -eq 'Ladder Bottom' } | Select-Object 'Location','Exit'

$snakeHeadLocations = $board | Where-Object { $_.'Type' -eq 'Snake Head' } | Select-Object 'Location','Exit'

[int]$playerLocation = 0

while ($playerLocation -lt 100) {

    [int]$playerRoll = Invoke-Role -sides 6

    Write-Output "Rolled a $($playerRoll)"
    [int]$playerNewLocation = $playerLocation + $playerRoll
    if ($playerNewLocation -gt 100) {
        Write-Output "Roll too high ($playerNewLocation)"
        $playerLocation = 100 - ($playerNewLocation - 100)
        Write-Output "Location: Bounced back to $playerLocation)"
        Start-Sleep -Milliseconds $sleep
    }
    elseif ($ladderBottomLocations.'Location' -eq $playerNewLocation) {
        $playerNewNewLocation = $ladderTopLocations | Where-Object { $_.'Location' -eq $playerNewLocation }
        Write-Output "Location: $playerNewLocation climb the ladder to $($playerNewNewLocation.'Exit')"
        $playerLocation = $playerNewNewLocation.'Exit'
        Start-Sleep -Milliseconds $sleep
    }
    elseif ($snakeHeadLocations.'Location' -eq $playerNewLocation) {
        $playerNewNewLocation = $snakeHeadLocations | Where-Object { $_.'Location' -eq $playerNewLocation }
        Write-Output "Location: $playerNewLocation slide down the snake to $($playerNewNewLocation.'Exit')"
        $playerLocation = $playerNewNewLocation.'Exit'
        Start-Sleep -Milliseconds $sleep
    }
    else {
        Write-Output "Location: $playerNewLocation"
        $playerLocation = $playerNewLocation
        Start-Sleep -Milliseconds $sleep
    }
}