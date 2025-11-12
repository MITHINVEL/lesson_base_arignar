# start_embedded_dev.ps1
# Starting Arignar Embedded Development Environment

# Function to cleanup background processes
function Cleanup {
    Write-Host "`nCleaning up processes..." -ForegroundColor Yellow
    
    if ($null -ne $FlutterJob) {
        Stop-Job -Job $FlutterJob -ErrorAction SilentlyContinue
        Remove-Job -Job $FlutterJob -ErrorAction SilentlyContinue
        Write-Host "Flutter web server stopped" -ForegroundColor Green
    }
    
    if ($null -ne $NodeProcess) {
        Stop-Process -Id $NodeProcess.Id -ErrorAction SilentlyContinue
        Write-Host "Node.js server stopped" -ForegroundColor Green
    }
    
    exit 0
}

# Set trap to cleanup on script exit
$null = Register-EngineEvent PowerShell.Exiting -Action { Cleanup }
$null = [Console]::TreatControlCAsInput = $false

# Note: some PowerShell hosts do not expose Console::CancelKeyPress for direct assignment.
# We already registered a PowerShell.Exiting engine event above; avoid binding CancelKeyPress
# directly to prevent "PropertyAssignmentException" in constrained hosts.

Write-Host "Starting Arignar Embedded Development Environment" -ForegroundColor Blue

# Check if Flutter is installed
try {
    $null = Get-Command flutter -ErrorAction Stop
} catch {
    Write-Host "Flutter is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Check if Node.js is installed
try {
    $null = Get-Command node -ErrorAction Stop
} catch {
    Write-Host "Node.js is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Create .env file if it doesn't exist
$envPath = "embeddedWeb\.env"
if (-not (Test-Path $envPath)) {
    Write-Host "Creating .env file for embedded portal..." -ForegroundColor Yellow
    "API_KEY=your_api_key_here" | Out-File -FilePath $envPath -Encoding utf8
    Write-Host "Please update embeddedWeb\.env with your actual API_KEY" -ForegroundColor Yellow
}

# Install Node.js dependencies if needed
$nodeModulesPath = "embeddedWeb\node_modules"
if (-not (Test-Path $nodeModulesPath)) {
    Write-Host "Installing Node.js dependencies..." -ForegroundColor Blue
    Push-Location embeddedWeb
    npm install
    Pop-Location
}

Write-Host "Local development HTML created" -ForegroundColor Green

# Start Flutter web server in background
Write-Host "Starting Flutter web server on port 5000..." -ForegroundColor Blue
$FlutterJob = Start-Job -ScriptBlock { flutter run -d web-server --web-port=5000 --web-hostname=0.0.0.0 }
Start-Sleep -Seconds 3

# Start Node.js server in background
Write-Host "Starting Node.js embedded portal server on port 60494..." -ForegroundColor Blue
Push-Location embeddedWeb
# Allow the embedded Node server to read the port from PORT env var
$env:PORT = "60494"
$NodeProcess = Start-Process -FilePath "node" -ArgumentList "server.js" -PassThru -NoNewWindow
Pop-Location

# Wait a moment for Node.js to start
Start-Sleep -Seconds 2

Write-Host "Development environment started successfully!" -ForegroundColor Green
Write-Host "Flutter Web App: http://localhost:5000" -ForegroundColor Blue
if ($env:PORT) {
    Write-Host "Embedded Portal: http://localhost:$env:PORT" -ForegroundColor Blue
    Write-Host "Local Development Portal: http://localhost:$env:PORT/local-dev.html" -ForegroundColor Blue
} else {
    Write-Host "Embedded Portal: http://localhost:58257" -ForegroundColor Blue
    Write-Host "Local Development Portal: http://localhost:58257/local-dev.html" -ForegroundColor Blue
}
Write-Host ""
Write-Host "Tips:" -ForegroundColor Yellow
Write-Host "  • Use http://localhost:58257/local-dev.html for testing embedded integration"
Write-Host "  • Use http://localhost:5000 for direct Flutter development"
Write-Host "  • Hot reload works on the Flutter server"
Write-Host "  • Press Ctrl+C to stop both servers"
Write-Host ""

# Wait for user to stop the servers
try {
    while ($true) {
        Start-Sleep -Seconds 1
        if ($NodeProcess.HasExited) {
            Write-Host "Node.js server exited unexpectedly" -ForegroundColor Red
            break
        }
    }
} catch {
    Cleanup
}