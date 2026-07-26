# Firmware memory baseline

## Identification

- Date: 2026-07-26
- Git source commit: `<COMMIT_BEFORE_BASELINE_REPORT>`
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

