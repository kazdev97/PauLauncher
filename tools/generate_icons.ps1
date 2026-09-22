# Genera los iconos de PauLauncher (PNG 512/32 y multi-tamano ICO) sin dependencias.
# Requiere solo .NET System.Drawing (incluido en Windows).
Add-Type -AssemblyName System.Drawing

$outDir = Join-Path $PSScriptRoot '..\src-tauri\icons'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$rose    = [System.Drawing.Color]::FromArgb(255, 255, 158, 234)   # FF9EEA
$lilac   = [System.Drawing.Color]::FromArgb(255, 213, 158, 255)   # D59EFF
$mint    = [System.Drawing.Color]::FromArgb(255, 158, 255, 234)   # 9EFFEA
$bg      = [System.Drawing.Color]::FromArgb(255, 236, 232, 247)   # fondo pastel

function New-PauIcon([int]$size, [string]$path) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    # fondo redondeado con degradado rosa -> lila
    $rect = New-Object System.Drawing.Rectangle(0, 0, $size, $size)
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $rose, $lilac, 45.0)
    $radius = [int]($size * 0.22)
    $g.FillEllipse($brush, 0, 0, $size, $size)

    # acento menta (arco inferior)
    $pen = New-Object System.Drawing.Pen($mint, [int]($size * 0.09))
    $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $th = [int]($size * 0.42)
    $g.DrawArc($pen, [int]($size*0.12), $size - $th, [int]($size*0.76), $size, 180, 180)

    # "P" blanca
    $fontSize = [int]($size * 0.52)
    $fontFamily = 'Segoe UI'
    $font = New-Object System.Drawing.Font($fontFamily, $fontSize, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $txtRect = New-Object System.Drawing.RectangleF(0, [int]($size*0.02), $size, [int]($size*0.96))
    $g.DrawString('P', $font, $white, $txtRect, $sf)

    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

function New-PauIco([string]$path) {
    # Crea un ICO con tamanos 16,32,48,64,128,256
    $sizes = @(16, 32, 48, 64, 128, 256)
    $frames = @()
    foreach ($s in $sizes) {
        $bmp = New-Object System.Drawing.Bitmap($s, $s)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $g.Clear([System.Drawing.Color]::Transparent)
        $rect = New-Object System.Drawing.Rectangle(0, 0, $s, $s)
        $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $rose, $lilac, 45.0)
        $g.FillEllipse($brush, 0, 0, $s, $s)
        $pen = New-Object System.Drawing.Pen($mint, [math]::Max(1, [int]($s * 0.09)))
        $g.DrawArc($pen, [int]($s*0.12), [int]($s*0.55), [int]($s*0.76), $s, 180, 180)
        $font = New-Object System.Drawing.Font('Segoe UI', [int]($s*0.52), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
        $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $sf = New-Object System.Drawing.StringFormat
        $sf.Alignment = [System.Drawing.StringAlignment]::Center
        $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
        $txtRect = New-Object System.Drawing.RectangleF(0, [int]($s*0.02), $s, [int]($s*0.96))
        $g.DrawString('P', $font, $white, $txtRect, $sf)
        $g.Dispose()

        $ms = New-Object System.IO.MemoryStream
        $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
        $frames += ,@{ Size = $s; Bytes = $ms.ToArray() }
        $ms.Dispose()
        $bmp.Dispose()
    }
    # Encabezado ICO
    $fs = [System.IO.File]::Create($path)
    $bw = New-Object System.IO.BinaryWriter($fs)
    $bw.Write([uint16]0)
    $bw.Write([uint16]1)
    $bw.Write([uint16]$frames.Count)
    $offset = 6 + (16 * $frames.Count)
    foreach ($f in $frames) {
        $s = $f.Size
        $bytes = $f.Bytes
        $bw.Write([byte]($(if ($s -ge 256) {0} else {$s})))
        $bw.Write([byte]($(if ($s -ge 256) {0} else {$s})))
        $bw.Write([byte]0)
        $bw.Write([byte]0)
        $bw.Write([uint16]1)
        $bw.Write([uint16]32)
        $bw.Write([uint32]$bytes.Length)
        $bw.Write([uint32]$offset)
        $offset += $bytes.Length
    }
    foreach ($f in $frames) {
        $bw.Write($f.Bytes)
    }
    $bw.Dispose()
    $fs.Dispose()
}

New-PauIcon 512 (Join-Path $outDir 'icon.png')
New-PauIcon 32  (Join-Path $outDir '32x32.png')
New-PauIcon 128 (Join-Path $outDir '128x128.png')
& {
    $bmp = New-Object System.Drawing.Bitmap(256, 256)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)
    $rect = New-Object System.Drawing.Rectangle(0, 0, 256, 256)
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $rose, $lilac, 45.0)
    $g.FillEllipse($brush, 0, 0, 256, 256)
    $pen = New-Object System.Drawing.Pen($mint, 20)
    $g.DrawArc($pen, 30, 140, 196, 256, 180, 180)
    $font = New-Object System.Drawing.Font('Segoe UI', 132, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $txtRect = New-Object System.Drawing.RectangleF(0, 4, 256, 248)
    $g.DrawString('P', $font, $white, $txtRect, $sf)
    $g.Dispose()
    $bmp.Save((Join-Path $outDir '128x128@2x.png'), [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}
New-PauIco (Join-Path $outDir 'icon.ico')
Write-Output 'Iconos generados en:'
Get-ChildItem $outDir | Select-Object Name, Length | Format-Table -AutoSize