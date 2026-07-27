openocd `
    -f .\debug\openocd\weact_stm32h743_stlink.cfg `
    2>&1 |
    Tee-Object .\logs\lesson_0_3\openocd_after_flash.log