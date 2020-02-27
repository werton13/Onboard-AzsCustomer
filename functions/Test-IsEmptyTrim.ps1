function Test-IsEmptyTrim ([string] $field) #to check if field is empty or consist from spaces
{
    if($field -eq $null -or $field.Trim().Length -eq 0)
    {
        return $true    
    }
    
    return $false
}