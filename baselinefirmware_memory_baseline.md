[1mdiff --git a/docs/baseline/firmware_memory_baseline.md b/docs/baseline/firmware_memory_baseline.md[m
[1mindex 13700b6..d0382cd 100644[m
[1m--- a/docs/baseline/firmware_memory_baseline.md[m
[1m+++ b/docs/baseline/firmware_memory_baseline.md[m
[36m@@ -3,7 +3,7 @@[m
 ## Identification[m
 [m
 - Date: 2026-07-26[m
[31m-- Git source commit: `<COMMIT_BEFORE_BASELINE_REPORT>`[m
[32m+[m[32m- Git source commit: 9a671b038031bbdf44c1cd9c25979f7a77d813e0[m
 - Configuration: `target-debug`[m
 - Target: WeAct Studio STM32H743VIT6 DevBoard[m
 - MCU: STM32H743VIT6[m
[36m@@ -39,3 +39,78 @@[m [mLimitations:[m
 - interrupt nesting is not included;[m
 - maximum call-path stack has not yet been formally calculated.[m
 [m
[32m+[m[32m## Build[m
[32m+[m
[32m+[m[32m- Configure command: `cmake --preset target-debug`[m
[32m+[m[32m- Build command: `cmake --build --preset target-debug --verbose`[m
[32m+[m[32m- Build result: successful[m
[32m+[m[32m- Compiler warnings: 0[m
[32m+[m[32m- Assembler warnings: 0[m
[32m+[m[32m- Linker warnings: 0[m
[32m+[m
[32m+[m[32m## Artifacts[m
[32m+[m
[32m+[m[32m| Artifact | Path | File size, bytes |[m
[32m+[m[32m|---|---|---:|[m
[32m+[m[32m| ELF | `build/target-debug/artifacts/firmware.elf` | 32152 |[m
[32m+[m[32m| BIN | `build/target-debug/artifacts/firmware.bin` | 216 |[m
[32m+[m[32m| HEX | `build/target-debug/artifacts/firmware.hex` | 678 |[m
[32m+[m[32m| MAP | `build/target-debug/artifacts/firmware.map` | 11620 |[m
[32m+[m
[32m+[m[32m## GNU size[m
[32m+[m
[32m+[m[32m```text[m
[32m+[m[32m   text    data     bss     dec     hex filename[m
[32m+[m[32m    212       4     260     476     1dc firmware.elf[m
[32m+[m
[32m+[m[41m    [m
[32m+[m[32m## 6. Добавить адреса секций[m
[32m+[m
[32m+[m[32m```markdown[m
[32m+[m[32m## Section addresses[m
[32m+[m
[32m+[m[32m| Section | VMA | LMA | Size, bytes |[m
[32m+[m[32m|---|---:|---:|---:|[m
[32m+[m[32m| `.isr_vector` | `0x08000000` | `0x08000000` | 64 |[m
[32m+[m[32m| `.text` | `0x08000040` | `0x08000040` | 148 |[m
[32m+[m[32m| `.data` | `0x20000000` | `0x080000D4` | 4 |[m
[32m+[m[32m| `.bss` | `0x20000004` | not loaded | 260 |[m
[32m+[m
[32m+[m[32m## Linker symbols[m
[32m+[m
[32m+[m[32m| Symbol | Address | Meaning |[m
[32m+[m[32m|---|---:|---|[m
[32m+[m[32m| `_sidata` | `0x080000D4` | `.data` load address |[m
[32m+[m[32m| `_sdata` | `0x20000000` | `.data` runtime start |[m
[32m+[m[32m| `_edata` | `0x20000004` | `.data` runtime end |[m
[32m+[m[32m| `_sbss` | `0x20000004` | `.bss` start |[m
[32m+[m[32m| `_ebss` | `0x20000108` | `.bss` end |[m
[32m+[m[32m| `_stack_limit` | `0x2001F000` | lower reserved stack boundary |[m
[32m+[m[32m| `_estack` | `0x20020000` | initial main stack pointer |[m
[32m+[m
[32m+[m[32m## Conclusions[m
[32m+[m
[32m+[m[32m- Minimal STM32H743 target firmware builds reproducibly with zero warnings.[m
[32m+[m[32m- Flash load image occupies 216 bytes.[m
[32m+[m[32m- Static DTCMRAM allocation occupies 264 bytes.[m
[32m+[m[32m- The main stack reserves 4096 bytes at the top of DTCMRAM.[m
[32m+[m[32m- ELF file size is not representative of Flash usage because it includes debug and symbol information.[m
[32m+[m[32m- `.data` has different LMA and VMA and is copied from Flash to DTCMRAM during reset.[m
[32m+[m[32m- `.bss` is allocated in DTCMRAM and initialized by startup code.[m
[32m+[m
[32m+[m[32m## Known limitations[m
[32m+[m
[32m+[m[32m- Minimal educational startup is used.[m
[32m+[m[32m- Clock tree is not configured.[m
[32m+[m[32m- `SystemInit()` is not called.[m
[32m+[m[32m- FPU runtime initialization has not been verified.[m
[32m+[m[32m- Peripheral interrupts are not enabled.[m
[32m+[m[32m- DMA buffers are not defined.[m
[32m+[m[32m- D-cache and I-cache are not enabled.[m
[32m+[m[32m- Heap is not configured.[m
[32m+[m[32m- Runtime stack high-water mark is not measured.[m
[32m+[m[32m- Interrupt and exception stack consumption is not included.[m
[32m+[m[32m- Hardware execution has not yet been verified.[m
[41m+[m
[41m+[m
[41m+[m
