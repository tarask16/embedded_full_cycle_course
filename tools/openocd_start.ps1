$Config = (
    Resolve-Path `
        .\debug\openocd\weact_stm32h743_stlink.cfg
).Path

$Log = '.\logs\lesson_0_3\openocd.log'

& openocd `
    -f $Config `
    2>&1 |
    ForEach-Object {
        if ($_ -is [System.Management.Automation.ErrorRecord]) {
            $_.Exception.Message
        }
        else {
            $_.ToString()
        }
    } |
    Tee-Object -FilePath $Log