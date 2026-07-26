# Firmware memory baseline

## Identification

- Date: 2026-07-26
- Git source commit: 9a671b038031bbdf44c1cd9c25979f7a77d813e0
- Configuration: `target-debug`
- Target: WeAct Studio STM32H743VIT6 DevBoard
- MCU: STM32H743VIT6
- Compiler: GNU Arm Embedded GCC 15.2.1
- CMake: 4.4.0-rc1
- Ninja: 1.13.2

## Memory interpretation

- `.isr_vector`: 64 bytes
- `.text`: 148 bytes
- `.data`: 4 bytes
- `.bss`: 260 bytes
- Approximate Flash usage: 216 bytes
- Static RAM usage: 264 bytes
- Reserved main stack: 4096 bytes
- Minimum DTCMRAM requirement including reserved stack: 4360 bytes
- Heap: 0 bytes
- Remaining DTCMRAM before stack boundary: 126712 bytes

## Stack analysis

| Function | Static stack, bytes | Qualifier |
|---|---:|---|
| `signature_checksum` | 0 | static |
| `main` | 8 | static |

Limitations:

- runtime high-water mark not measured;
- startup assembly is not covered by `.su`;
- exception frames are not included;
- interrupt nesting is not included;
- maximum call-path stack has not yet been formally calculated.

## Build

- Configure command: `cmake --preset target-debug`
- Build command: `cmake --build --preset target-debug --verbose`
- Build result: successful
- Compiler warnings: 0
- Assembler warnings: 0
- Linker warnings: 0

## Artifacts

| Artifact | Path | File size, bytes |
|---|---|---:|
| ELF | `build/target-debug/artifacts/firmware.elf` | 32152 |
| BIN | `build/target-debug/artifacts/firmware.bin` | 216 |
| HEX | `build/target-debug/artifacts/firmware.hex` | 678 |
| MAP | `build/target-debug/artifacts/firmware.map` | 11620 |

## GNU size

```text
   text    data     bss     dec     hex filename
    212       4     260     476     1dc firmware.elf

    
## 6. Добавить адреса секций

```markdown
## Section addresses

| Section | VMA | LMA | Size, bytes |
|---|---:|---:|---:|
| `.isr_vector` | `0x08000000` | `0x08000000` | 64 |
| `.text` | `0x08000040` | `0x08000040` | 148 |
| `.data` | `0x20000000` | `0x080000D4` | 4 |
| `.bss` | `0x20000004` | not loaded | 260 |

## Linker symbols

| Symbol | Address | Meaning |
|---|---:|---|
| `_sidata` | `0x080000D4` | `.data` load address |
| `_sdata` | `0x20000000` | `.data` runtime start |
| `_edata` | `0x20000004` | `.data` runtime end |
| `_sbss` | `0x20000004` | `.bss` start |
| `_ebss` | `0x20000108` | `.bss` end |
| `_stack_limit` | `0x2001F000` | lower reserved stack boundary |
| `_estack` | `0x20020000` | initial main stack pointer |

## Conclusions

- Minimal STM32H743 target firmware builds reproducibly with zero warnings.
- Flash load image occupies 216 bytes.
- Static DTCMRAM allocation occupies 264 bytes.
- The main stack reserves 4096 bytes at the top of DTCMRAM.
- ELF file size is not representative of Flash usage because it includes debug and symbol information.
- `.data` has different LMA and VMA and is copied from Flash to DTCMRAM during reset.
- `.bss` is allocated in DTCMRAM and initialized by startup code.

## Known limitations

- Minimal educational startup is used.
- Clock tree is not configured.
- `SystemInit()` is not called.
- FPU runtime initialization has not been verified.
- Peripheral interrupts are not enabled.
- DMA buffers are not defined.
- D-cache and I-cache are not enabled.
- Heap is not configured.
- Runtime stack high-water mark is not measured.
- Interrupt and exception stack consumption is not included.
- Hardware execution has not yet been verified.



