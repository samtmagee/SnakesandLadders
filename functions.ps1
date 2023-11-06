function Invoke-Role {
    param (
        [int]$sides = 6
    )
    Get-Random -Minimum 1 -Maximum $sides
}

for ($i = 0; $i -lt 20; $i++) {
    Invoke-Role -sides 50

}