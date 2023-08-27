$port = 8000
$root = "E:\Ref\ngrok" #Replace with the location where you have the script file

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()

Write-Host "Listening on port $port"

while($listener.IsListening){
    $context = $listener.GetContext()
    $response = $context.Response
    $path = $root + $context.Request.RawUrl
    if(Test-Path -Path $path -PathType Leaf){
        $content = Get-Content -Path $path -Raw
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
    } else {
        $response.StatusCode = 404
    }
    $response.Close()
}
