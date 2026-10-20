$ErrorActionPreference = "Stop"
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$Root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Port = 8090
$Url  = "http://localhost:$Port/"
$Index = Join-Path $Root "index.html"
$Server = Join-Path $Root "server.js"

function Show-Header {
    Write-Host ""
    Write-Host "  ============================================================" -ForegroundColor Green
    Write-Host "      شركة نبض لتجارة وتوزيع الأدوية  -  NABD" -ForegroundColor Green
    Write-Host "      تشغيل الموقع محلياً" -ForegroundColor Green
    Write-Host "  ============================================================" -ForegroundColor Green
    Write-Host ""
}

function Show-Menu {
    Write-Host "   [1]  فتح الموقع في المتصفح         (الأسهل - بدون متطلبات)" -ForegroundColor White
    Write-Host "   [2]  تشغيل خادم محلي ثم فتح الموقع   (يتطلب Node.js)" -ForegroundColor White
    Write-Host "   [3]  خروج" -ForegroundColor White
    Write-Host ""
}

function Pause-BeforeExit {
    Write-Host "  اضغط أي مفتاح للإغلاق ..." -ForegroundColor DarkGray
    try { $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") } catch { Start-Sleep -Seconds 2 }
}

function Open-Direct {
    Write-Host "  جارٍ فتح index.html في المتصفح الافتراضي ..." -ForegroundColor Cyan
    Start-Process -FilePath $Index
    Write-Host "  ✔ تم بنجاح. سيتم إغلاق هذه النافذة تلقائياً." -ForegroundColor Green
    Write-Host ""
    Start-Sleep -Seconds 2
}

function Test-Node {
    return ($null -ne (Get-Command node -ErrorAction SilentlyContinue))
}

function Open-Server {
    if (-not (Test-Node)) {
        Write-Host "  [!] Node.js غير مثبّت على هذا الجهاز." -ForegroundColor Yellow
        Write-Host "      سيتم فتح الموقع مباشرة في المتصفح بدلاً من ذلك." -ForegroundColor Yellow
        Write-Host ""
        Open-Direct
        return
    }

    Write-Host "  جارٍ تشغيل الخادم المحلي على المنفذ $Port ..." -ForegroundColor Cyan
    Write-Host "  رابط الموقع : $Url" -ForegroundColor Cyan
    Write-Host "  لإيقاف الخادم: اضغط Ctrl + C" -ForegroundColor Cyan
    Write-Host ""

    Start-Job -ScriptBlock {
        param($u)
        Start-Sleep -Seconds 2
        Start-Process $u
    } -ArgumentList $Url | Out-Null

    Push-Location $Root
    try {
        & node $Server $Port
    }
    finally {
        Pop-Location
        Get-Job | Remove-Job -Force -ErrorAction SilentlyContinue
        Pause-BeforeExit
    }
}

Show-Header
Show-Menu

$choice = Read-Host "  اختر رقماً ثم اضغط Enter"

if ($choice -eq "1") {
    Open-Direct
}
elseif ($choice -eq "2") {
    Open-Server
}
elseif ($choice -eq "3") {
}
else {
    Write-Host ""
    Write-Host "  [!] اختيار غير صحيح. سيتم فتح الموقع مباشرة." -ForegroundColor Yellow
    Write-Host ""
    Open-Direct
}
