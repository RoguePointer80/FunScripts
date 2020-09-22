function Get-ChildItemWithSize
{
#    param (
#        [Parameter(Mandatory=$false)][string]$path
#    )

    $children = Get-ChildItem
    Foreach ($child in $children)
    {
        if( $child -is [System.IO.DirectoryInfo]) {
            $childSize = (Get-ChildItem $child -Recurse | Measure-Object -Property Length -sum -ErrorAction SilentlyContinue -ErrorVariable mesaureErrors).Sum
            foreach($mesaureError in $mesaureErrors)
            {
                $childSize = 0
            }
            $psobj = Select-Object @{n='Mode';e={$child.Mode}},@{n='LastWriteTime';e={$child.LastWriteTime}},@{n='Length';e={$childSize}},@{n='Name';e={$child.Name}} -InputObject $child
            Write-Output $psobj
        } else {
            Write-Output $child
        }
    }
}
