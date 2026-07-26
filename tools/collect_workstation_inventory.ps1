[CmdletBinding()]
param(
    [string]$OutputDirectory = "docs/baseline"
)

$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null

$MarkdownPath = Join-Path $OutputDirectory "workstation_inventory.md"
$JsonPath = Join-Path $OutputDirectory "workstation_inventory.json"

function Invoke-VersionCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command,

        [string[]]$Arguments = @("--version")
    )

    $commandInfo = Get-Command $Command -ErrorAction SilentlyContinue

    if ($null -eq $commandInfo) {
        return [PSCustomObject]@{
            Found   = $false
            Path    = $null
            Version = "NOT FOUND"
        }
    }

    try {
        $output = & $commandInfo.Source @Arguments 2>&1 | Out-String

        return [PSCustomObject]@{
            Found   = $true
            Path    = $commandInfo.Source
            Version = $output.Trim()
        }
    }
    catch {
        return [PSCustomObject]@{
            Found   = $true
            Path    = $commandInfo.Source
            Version = "VERSION COMMAND FAILED: $($_.Exception.Message)"
        }
    }
}

$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$computer = Get-CimInstance Win32_ComputerSystem

$tools = [ordered]@{
    Git                 = Invoke-VersionCommand "git"
    CMake               = Invoke-VersionCommand "cmake"
    Ninja               = Invoke-VersionCommand "ninja"
    ArmGcc              = Invoke-VersionCommand "arm-none-eabi-gcc"
    ArmGpp              = Invoke-VersionCommand "arm-none-eabi-g++"
    ArmGdb              = Invoke-VersionCommand "arm-none-eabi-gdb"
    ArmSize             = Invoke-VersionCommand "arm-none-eabi-size"
    ArmObjcopy          = Invoke-VersionCommand "arm-none-eabi-objcopy"
    VSCode              = Invoke-VersionCommand "code"
    STM32CubeProgrammer = Invoke-VersionCommand "STM32_Programmer_CLI.exe"
    StLinkGdbServer     = Invoke-VersionCommand "ST-LINK_gdbserver.exe"
    OpenOcd             = Invoke-VersionCommand "openocd"
}

$repository = [ordered]@{
    IsGitRepository = $false
    Root            = $null
    Branch          = $null
    Commit          = $null
    Status          = $null
}

if (Get-Command git -ErrorAction SilentlyContinue) {
    & git rev-parse --is-inside-work-tree 2>$null | Out-Null

    if ($LASTEXITCODE -eq 0) {
        $repository.IsGitRepository = $true
        $repository.Root = (& git rev-parse --show-toplevel).Trim()
        $repository.Branch = (& git branch --show-current).Trim()
        $repository.Commit = (& git rev-parse HEAD).Trim()
        $repository.Status = (& git status --short | Out-String).Trim()
    }
}

$inventory = [ordered]@{
    CapturedAt = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssK")

    OperatingSystem = [ordered]@{
        Name         = $os.Caption
        Version      = $os.Version
        Build        = $os.BuildNumber
        Architecture = $os.OSArchitecture
    }

    Hardware = [ordered]@{
        Processor         = $cpu.Name.Trim()
        PhysicalCores     = $cpu.NumberOfCores
        LogicalProcessors = $cpu.NumberOfLogicalProcessors
        RamGiB            = [math]::Round($computer.TotalPhysicalMemory / 1GB, 2)
    }

    Shell = [ordered]@{
        PowerShellVersion = $PSVersionTable.PSVersion.ToString()
        PowerShellEdition = $PSVersionTable.PSEdition
    }

    RegionalSettings = [ordered]@{
        Culture        = (Get-Culture).Name
        UICulture      = (Get-UICulture).Name
        TimeZone       = (Get-TimeZone).Id
        InputEncoding  = [Console]::InputEncoding.WebName
        OutputEncoding = [Console]::OutputEncoding.WebName
    }

    Tools      = $tools
    Repository = $repository
}

$json = $inventory | ConvertTo-Json -Depth 8
[System.IO.File]::WriteAllText(
    (Join-Path (Get-Location) $JsonPath),
    $json,
    (New-Object System.Text.UTF8Encoding($true))
)

$lines = New-Object System.Collections.Generic.List[string]

$lines.Add("# Workstation inventory")
$lines.Add("")
$lines.Add("Дата фиксации: $($inventory.CapturedAt)")
$lines.Add("")

$lines.Add("## Операционная система")
$lines.Add("")
$lines.Add("- ОС: $($inventory.OperatingSystem.Name)")
$lines.Add("- Версия: $($inventory.OperatingSystem.Version)")
$lines.Add("- Build: $($inventory.OperatingSystem.Build)")
$lines.Add("- Архитектура: $($inventory.OperatingSystem.Architecture)")
$lines.Add("")

$lines.Add("## Аппаратная платформа")
$lines.Add("")
$lines.Add("- Процессор: $($inventory.Hardware.Processor)")
$lines.Add("- Физические ядра: $($inventory.Hardware.PhysicalCores)")
$lines.Add("- Логические процессоры: $($inventory.Hardware.LogicalProcessors)")
$lines.Add("- RAM: $($inventory.Hardware.RamGiB) GiB")
$lines.Add("")

$lines.Add("## Командная среда")
$lines.Add("")
$lines.Add("- PowerShell: $($inventory.Shell.PowerShellVersion)")
$lines.Add("- Edition: $($inventory.Shell.PowerShellEdition)")
$lines.Add("- Culture: $($inventory.RegionalSettings.Culture)")
$lines.Add("- UI culture: $($inventory.RegionalSettings.UICulture)")
$lines.Add("- Time zone: $($inventory.RegionalSettings.TimeZone)")
$lines.Add("- Input encoding: $($inventory.RegionalSettings.InputEncoding)")
$lines.Add("- Output encoding: $($inventory.RegionalSettings.OutputEncoding)")
$lines.Add("")

$lines.Add("## Инструменты")
$lines.Add("")
$lines.Add("| Инструмент | Найден | Путь |")
$lines.Add("|---|---:|---|")

foreach ($entry in $tools.GetEnumerator()) {
    if ($entry.Value.Found) {
        $found = "Да"
    }
    else {
        $found = "Нет"
    }

    if ($entry.Value.Path) {
        $path = $entry.Value.Path.Replace("|", "\|")
    }
    else {
        $path = "-"
    }

    $lines.Add("| $($entry.Key) | $found | $path |")
}

$lines.Add("")
$lines.Add("## Версии инструментов")
$lines.Add("")

foreach ($entry in $tools.GetEnumerator()) {
    $lines.Add("### $($entry.Key)")
    $lines.Add("")
    $lines.Add('```text')
    $lines.Add($entry.Value.Version)
    $lines.Add('```')
    $lines.Add("")
}

$lines.Add("## Репозиторий")
$lines.Add("")
$lines.Add("- Git-репозиторий: $($repository.IsGitRepository)")
$lines.Add("- Корень: $($repository.Root)")
$lines.Add("- Ветка: $($repository.Branch)")
$lines.Add("- Commit: $($repository.Commit)")
$lines.Add("")
$lines.Add("### Рабочее дерево")
$lines.Add("")
$lines.Add('```text')

if ([string]::IsNullOrWhiteSpace($repository.Status)) {
    $lines.Add("clean")
}
else {
    $lines.Add($repository.Status)
}

$lines.Add('```')
$lines.Add("")

$markdown = $lines -join [Environment]::NewLine
[System.IO.File]::WriteAllText(
    (Join-Path (Get-Location) $MarkdownPath),
    $markdown,
    (New-Object System.Text.UTF8Encoding($true))
)

Write-Host "Созданы файлы:"
Write-Host "  $MarkdownPath"
Write-Host "  $JsonPath"
