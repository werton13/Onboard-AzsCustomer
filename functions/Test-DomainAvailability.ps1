function test-domainavailability {
    param(
    [string]$ProposedDomain,
    $headers 
    )
    
try {

 $DomainTestResult =  (Invoke-webrequest -Method 'Head' `
                         -Uri "https://api.partnercenter.microsoft.com/v1/domains/$ProposedDomain" `
                         -Headers $headers `
                         -ContentType 'application/json').statuscode
    }

catch {
        
        $DomainTestResult         = $_.Exception.Response.StatusCode.value__
      

        if($headers){$script:HeadersUsed = New-Object PSObject
                       $headers.GetEnumerator() | % { 
                         if($_.name -notmatch "Authorization"){
                       Add-member -InputObject $script:HeadersUsed `
                                                              -MemberType NoteProperty `
                                                              -Name $_.name `
                                                              -Value $_.value
                                                    }
                         else {
                       Add-member -InputObject $script:HeadersUsed `
                                                              -MemberType NoteProperty `
                                                              -Name $_.name `
                                                              -Value "access token was replaced by this string"
                     }
                       }
                    }
        else        {$script:HeadersUsed = "authentication headers was not provided"}
   
      }

                
if ($DomainTestResult -match "404"){ $script:TestResult = "Available"  }
if ($DomainTestResult -match "200"){ $script:TestResult = "Busy"  }
if ($DomainTestResult -match "401"){ $script:TestResult = "Not Authenticated"

                                     $script:DomainTestDetails = "DomainTestResult: $DomainTestResult `r`nHeaders used:$HeadersUsed"
                     

                                   }




return $script:TestResult
}





<# oldcode
function test-domainavailability {
    param(
    [string]$ProposedDomain,
    $headers 
    )
    
try {

 $DomainTestResult =  (Invoke-webrequest -Method 'Head' `
                     -Uri "https://api.partnercenter.microsoft.com/v1/domains/$ProposedDomain" `
                     -Headers $headers `
                     -ContentType 'application/json').statuscode
    }

catch {
        $DomainTestResult = $_.Exception.Response.StatusCode.value__
        $FailDetails = $_.Exception.Response.StatusDescription
      }
#$DomainTestResult

                  
if ($DomainTestResult -match "404"){ $script:TestResult = "Available"  }
if ($DomainTestResult -match "200"){ $script:TestResult = "Busy"  }
if ($DomainTestResult -match "401"){ $script:TestResult = "Not Authenticated"

$script:DomainTestDetails = "DomainTestResult: $DomainTestResult `
                            
                                                                "
                     
 #                                    $script:FailDetails = "headers used: $headers `
 #                                                           FailDetais: $Faildetails"
                                   }
#if ($DomainTestResult -match "401"){ $script:TestResult = $FailDetails  }
# else {write-host -ForegroundColor Red "Domain $ProposedDomain not available - try d
# ifferent domain"}
#Clear-Variable -Name  DomainTestResult

return $script:TestResult
}
#>
