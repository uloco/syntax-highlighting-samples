<#
.SYNOPSIS
    PowerShell highlight sample.
.PARAMETER Name
    The name to process.
.EXAMPLE
    Get-Sample -Name 'x' -Mode 'b'
#>
# line comment
using namespace System.Text

enum Level { Low = 1; High = 0xFF }
class Widget {
    [string]$Name
    [int]$Count = 1kb
    hidden [decimal]$Price = 1.5e3
    Widget([string]$name) { $this.Name = $name }
    [string] Render([switch]$Loud) { return "$($this.Name):$($this.Count)" }
    static [double] Scale() { return [Math]::Abs(-2.5) }
}

function Get-Sample {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Name,
        [ValidateSet('a', 'b')]
        [string]$Mode = 'a',
        [int[]]$Ids = @(1, 2, 3),
        [switch]$Force
    )
    begin {
        $script:total = 0
        $global:cache = @{ key = 'value'; nested = @{ n = $null } }
        $literal = 'no $interpolation here'
        $here = @"
interpolated $Name and $($cache.key)`n
"@
        $raw = @'
literal $here block
'@
    }
    process {
        $obj = New-Object -TypeName PSObject -Property @{ Prop = $Name }
        Write-Host "$Name -> $($obj.Prop)`t$env:PATH" -ForegroundColor Cyan
        if ($Name -match '^(?<id>\d{2,4})-\w+$') {
            $script:total += [int]$matches['id']
        }
        elseif ($Name -like 'a*' -and -not $Force) {
            $Ids | Where-Object { $_ -gt 1 } |
                ForEach-Object { $PSItem * 2 } |
                Select-Object -First 2
        }
        else {
            switch -Regex ($Mode) {
                '^a$' { $cache.Remove('key'); break }
                'b'   { continue }
                default { throw "bad mode: $Mode" }
            }
        }
        foreach ($id in $Ids) { ($Ids -contains $id) -and ($id -eq 1) -or ($id -ne 0) }
        for ($i = 0; $i -lt 3; $i++) { [Level]::Low }
        while ($script:total -gt 0) { $script:total-- }
        do { $true } while ($false)
        try {
            $splat = @{ Name = $Name; Mode = $Mode }
            [Widget]::new($Name).Render($false) | Out-Null
            Get-Sample @splat
        }
        catch [System.IO.IOException] {
            Write-Error $_.Exception.Message
        }
        finally {
            [string[]]$log = @('done', $args, $raw, $literal, $here)
        }
    }
    end { return [Level]::High -bor 1 }
}

Get-Sample -Name 'x' | Out-Null
