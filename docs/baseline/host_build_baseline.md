# Host build baseline

## Scope

Host baseline validates that portable firmware code can be compiled
and tested natively on Windows independently of the STM32 target.

## Provenance

- Date: 2026-07-27
- Repository branch: `main`
- Base commit before lesson 0.4 commit: `<BASE_COMMIT>`
- Operating system: Windows
- Host compiler: MSYS2 UCRT64 GCC 16.1.0
- Host target: `x86_64-w64-mingw32`
- CMake: 4.4.0-rc1
- Ninja: 1.13.2
- CTest: 4.4.0-rc1

## Architecture

Portable library:

- CMake target: `efc_core`
- Header: `firmware/common/include/efc/checksum.h`
- Source: `firmware/common/src/checksum.c`

The same library is compiled by:

- native GCC for Windows host tests;
- `arm-none-eabi-gcc` for STM32H743 firmware.

Target-specific code is excluded from host builds using
`CMAKE_CROSSCOMPILING`.

## Presets

| Preset | Purpose | Build directory |
|---|---|---|
| `host-debug` | Native Debug build and tests | `build/host-debug` |
| `host-release` | Native Release build and tests | `build/host-release` |
| `target-debug` | STM32H743 cross-build | `build/target-debug` |

## Test coverage

CTest test:

- Name: `efc_core.checksum`
- Executable: `efc_core_tests.exe`

Validated cases:

| Case | Expected result |
|---|---:|
| Signature `EFC-BASELINE-01` | 972 |
| Binary values `0, 1, 127, 128, 255` | 511 |
| Empty input | 0 |
| Single byte `255` | 255 |
| Embedded zero bytes | 60 |

## Results

### Host Debug

- Configure: passed
- Clean build: passed
- CTest: 1/1 passed
- Internal checks: 5/5 passed
- Log: `logs/lesson_0_4/host_debug_ctest.log`

### Host Release

- Configure: passed
- Clean build: passed
- CTest: 1/1 passed
- Internal checks: 5/5 passed
- Log: `logs/lesson_0_4/host_release_ctest.log`

### Target regression

- Clean STM32H743 build: passed
- Flash used: 280 bytes
- DTCMRAM used: 268 bytes
- ELF sections:
  - text: 276 bytes
  - data: 4 bytes
  - bss: 264 bytes

The symbol `efc_checksum_u8` is present in the target ELF at
`0x080000EC`.

## Artifact hashes

| Artifact | Size, bytes | SHA-256 |
|---|---:|---|
| Host Debug executable | `135019` | `A62F2B7CEB809D7432E0D0FC2E7FF231D68B272956FB6449E391E478F524D6F2` |
| Host Release executable | `131623` | `FC7F4C7CAC88B0D75E5A2A4BD241E895F5DDB73E893C7F1C39ABFA2EEEB88CFA` |
| Host Debug static library | `2922` | `A76F57935F454FE7874248FB3E69FAA23C96D65418FD4C8E83B22D7F69CC4CD1` |
| Host Release static library | `1308` | `7C8B92846A631F0CF688F67049930120BC0A6E0F2832FB4F6818B4EB1AAFCFCB` |
| Target ELF | `39260` | `73A9441E815F6B6BBD202127984DAB8034E938121F5DA03A82AA6CED5231DD11` |
| Target HEX | `858` | `F7E8AA55221EA829D453A87E033F82505A2C0B4509098DAAC7213CDA8AD67EC4` |

## Reproduction

```powershell
cmake --preset host-debug --fresh
cmake --build --preset host-debug --clean-first
ctest --preset host-debug --verbose

cmake --preset host-release --fresh
cmake --build --preset host-release --clean-first
ctest --preset host-release --verbose

cmake --preset target-debug
cmake --build --preset target-debug --clean-first