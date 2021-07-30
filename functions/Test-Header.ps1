function Test-Header{
  # This function need to get status of the headers - it should catch the point, when a new header created
  # to make possible test domains availability before and after the  authentication 
  #
  
  if(!$script:headers){
  
    #if headers empty - we checking a token, if it exist we creating new headers
    if ($script:PCenterAccessToken){
        $script:headers = @{
            'api-version' = 'v1'
            'Accept' = 'application/json'           
            'Authorization' = "Bearer $script:PCenterAccessToken"
            'Host' = 'api.partnercenter.microsoft.com'
        }
      #write-host "new headers: $script:headers"
      $script:HeadersState = "NewCreated"
      }
      else {#write-host "headers not created"
      $script:HeadersState = "NotCreated"
      }# if token not exist we just write it
  }
  else {
        #Write-host "Headers already exists: $script:Headers"
        $script:HeadersState = "AlreadyExist"
        }
  
  #return $script:HeadersState
  return $script:Headers
  }