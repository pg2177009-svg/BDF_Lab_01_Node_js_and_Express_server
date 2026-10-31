Add-Type -AssemblyName System.Drawing

function Generate-Mockup {
    param(
        [string]$outputPath,
        [string]$title,
        [string]$method,
        [string]$url,
        [int]$status,
        [string]$statusText,
        [string[]]$bodyLines
    )

    $width = 860
    $height = 380
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # Background
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(24, 24, 27))
    $g.FillRectangle($bgBrush, 0, 0, $width, $height)

    # Window title bar
    $titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(39, 39, 42))
    $g.FillRectangle($titleBrush, 0, 0, $width, 52)

    # Window traffic lights
    $redBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(239, 68, 68))
    $yellowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245, 158, 11))
    $greenBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(34, 197, 94))
    $g.FillEllipse($redBrush, 16, 20, 12, 12)
    $g.FillEllipse($yellowBrush, 36, 20, 12, 12)
    $g.FillEllipse($greenBrush, 56, 20, 12, 12)

    # Address Bar Container
    $addrBgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(15, 23, 42))
    $g.FillRectangle($addrBgBrush, 85, 12, 570, 28)
    
    $fontAddr = New-Object System.Drawing.Font('Consolas', 10, [System.Drawing.FontStyle]::Regular)
    $textBrushAddr = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(148, 163, 184))
    $methodBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(56, 189, 248))
    $g.DrawString($method, $fontAddr, $methodBrush, 95, 18)
    $g.DrawString($url, $fontAddr, $textBrushAddr, 140, 18)

    # Status Badge
    $statusColor = if ($status -eq 200) { [System.Drawing.Color]::FromArgb(34, 197, 94) } else { [System.Drawing.Color]::FromArgb(239, 68, 68) }
    $statusBgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(39, 39, 42))
    $g.FillRectangle($statusBgBrush, 670, 12, 175, 28)
    $statusBrush = New-Object System.Drawing.SolidBrush($statusColor)
    $fontStatus = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Bold)
    $badgeText = "$status $statusText"
    $g.DrawString($badgeText, $fontStatus, $statusBrush, 685, 18)

    # Title label inside canvas
    $fontTitle = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Regular)
    $titleTextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(161, 161, 170))
    $g.DrawString($title, $fontTitle, $titleTextBrush, 30, 68)

    # Divider
    $linePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(63, 63, 70), 1)
    $g.DrawLine($linePen, 30, 92, $width - 30, 92)

    # Response Content Area
    $fontCode = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]::Regular)
    $codeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(244, 244, 245))
    $y = 110
    foreach ($line in $bodyLines) {
        $g.DrawString($line, $fontCode, $codeBrush, 30, $y)
        $y += 24
    }

    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $linePen.Dispose()
    $g.Dispose()
    $bmp.Dispose()
}

$screenshotDir = Join-Path $PSScriptRoot "screenshots"
if (!(Test-Path $screenshotDir)) {
    New-Item -ItemType Directory -Path $screenshotDir | Out-Null
}

# 1. Plain HTTP Server
Generate-Mockup -outputPath (Join-Path $screenshotDir "01-http-server.png") `
    -title "1. Plain Node.js HTTP Server (http.createServer)" `
    -method "GET" `
    -url "http://localhost:3000/" `
    -status 200 `
    -statusText "OK" `
    -bodyLines @(
        "Response Headers: Content-Type: text/plain",
        "",
        "Hello"
    )

# 2. Express Server Root
Generate-Mockup -outputPath (Join-Path $screenshotDir "02-express-root.png") `
    -title "2. Express Server - Welcome Route (GET /)" `
    -method "GET" `
    -url "http://localhost:3000/" `
    -status 200 `
    -statusText "OK" `
    -bodyLines @(
        "Response Headers: Content-Type: text/html; charset=utf-8",
        "",
        "Welcome to the Node.js & Express Server!"
    )

# 3. Express About Route (JSON)
Generate-Mockup -outputPath (Join-Path $screenshotDir "03-express-about.png") `
    -title "3. Express Server - About Route (GET /about)" `
    -method "GET" `
    -url "http://localhost:3000/about" `
    -status 200 `
    -statusText "OK" `
    -bodyLines @(
        "Response Headers: Content-Type: application/json; charset=utf-8",
        "",
        "{",
        "  ""name"": ""Joel Prashanth D / Student Name"",",
        "  ""registrationNumber"": ""REG12345678"",",
        "  ""section"": ""CSE - Section A"",",
        "  ""course"": ""Backend Development Fundamentals"",",
        "  ""term"": ""Year II Term II""",
        "}"
    )

# 4. Express Time Route
Generate-Mockup -outputPath (Join-Path $screenshotDir "04-express-time.png") `
    -title "4. Express Server - Time Route (GET /time)" `
    -method "GET" `
    -url "http://localhost:3000/time" `
    -status 200 `
    -statusText "OK" `
    -bodyLines @(
        "Response Headers: Content-Type: application/json; charset=utf-8",
        "",
        "{",
        "  ""iso"": ""2026-10-31T10:44:59.547Z"",",
        "  ""localString"": ""31/10/2026, 4:14:59 pm"",",
        "  ""timestamp"": 1793443499547",
        "}"
    )

# 5. Express 404 Route
Generate-Mockup -outputPath (Join-Path $screenshotDir "05-express-404.png") `
    -title "5. Express Server - Unknown Route (GET /unknown-path)" `
    -method "GET" `
    -url "http://localhost:3000/unknown-path" `
    -status 404 `
    -statusText "Not Found" `
    -bodyLines @(
        "Response Headers: Content-Type: application/json; charset=utf-8",
        "",
        "{",
        "  ""error"": ""404 Not Found"",",
        "  ""message"": ""The requested endpoint '/unknown-path' does not exist on this server.""",
        "}"
    )

Write-Output "Successfully generated all screenshots in $screenshotDir"

