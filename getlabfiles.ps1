Configuration getlabfiles
{
  param ($MachineName)

  Node $MachineName
  {
	Script ConfigureVM { 
		SetScript = { 
	    $dir = "c:\Labfiles"
            $FileURI = "https://raw.githubusercontent.com/KevinRemde/AZInfraLabBase/master/labfiles.zip"
            New-Item $dir -ItemType directory
            $output = "$dir\labfiles.zip"
            (New-Object System.Net.WebClient).DownloadFile($FileURI,$output)
        } 

		TestScript = { 
			Test-Path c:\Labfiles
		} 
		GetScript = { <# This must return a hash table #> }          
	}   
  }
} 