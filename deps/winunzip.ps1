$file      = $args[0]
$directory = $args[1]

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($file,$directory)