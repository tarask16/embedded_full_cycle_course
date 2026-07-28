# Host build baseline

## Scope

Host baseline validates that portable firmware code can be compiled
and tested natively on Windows independently of the STM32 target.

## Provenance

- Date: 2026-07-27
- Repository branch: `main`
- Host implementation commit: `cae4588ccd7c58f9c8a73b391a4a383e548e928a`
- Final source/build commit: `5dd11e981c95f4ae03c521e34fc37a8a30543844`
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
| `target-release` | STM32H743 optimized cross-build | `build/target-release` |

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



### Target Debug

- Clean STM32H743 build: passed
- Flash used: 280 bytes
- DTCMRAM used: 268 bytes
- ELF sections:
  - text: 276 bytes
  - data: 4 bytes
  - bss: 264 bytes

The symbol `efc_checksum_u8` is present in the target ELF at
`0x080000EC`.

### Target Release

- Configure: passed
- Clean build: passed
- Optimization policy: `-O2 -g1`
- `NDEBUG`: enabled for C translation units
- Flash used: 280 bytes
- DTCMRAM used: 268 bytes
- ELF sections:
  - text: 276 bytes
  - data: 4 bytes
  - bss: 264 bytes
- Symbol `efc_checksum_u8`: `0x080000EC`

## Artifact hashes

| Artifact | Size, bytes | SHA-256 |
|---|---:|---|
| Host Debug executable | `135019` | `13C7F2372CA8F7555AA37F3267968CE3757170880A454868157DEBDE223B4C4A` |
| Host Release executable | `131623` | `C0C11D53861C1C8B4CB192FE7FA220D2D73BDDD4056D54EBE6A82B50E12FEADC` |
| Host Debug static library | `2922` | `A76F57935F454FE7874248FB3E69FAA23C96D65418FD4C8E83B22D7F69CC4CD1` |
| Host Release static library | `1308` | `7C8B92846A631F0CF688F67049930120BC0A6E0F2832FB4F6818B4EB1AAFCFCB` |
| Target Debug ELF | `39260` | `73A9441E815F6B6BBD202127984DAB8034E938121F5DA03A82AA6CED5231DD11` |
| Target Debug HEX | `858` | `F7E8AA55221EA829D453A87E033F82505A2C0B4509098DAAC7213CDA8AD67EC4` |
| Target Debug BIN | `280` | `06A5B9C2DC251C1E0155123C70D15C7C34F4B63143A92B2DE7860E3014C94BC8` |
| Target Debug MAP | `12541` | `C94B003D5F8BE0765898A9D6F35C742A1677789B3CA78E31682B56A1AAEE6893` |
| Target Release ELF | `13040` | `E50021529E610E8BDEE1CAEAA750E55978914B29B64000924A241EF36E5F9AE8` |
| Target Release HEX | `858` | `DD37AECF7DABF46E93C79D757732F9F8D20E60DFDB92FF639CBDF48A71F53C0E` |
| Target Release BIN | `280` | `6DA6A1047062A0C1CB2C9FA807335DBEC3E2C8D37C942DDF464B8D7D63F934EF` |
| Target Release MAP | `12541` | `1E39BC5F111A4F7B51BE78DAEED3D1897D770A01DCB15DAB8B5C21812EC7AF51` |

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

cmake --preset target-release --fresh
cmake --build --preset target-release --clean-first
```

## Limitations

The checksum implementation is intentionally minimal and is not a
cryptographic checksum.
Invalid input `data == NULL && size > 0` is outside the function contract.
Host tests do not validate MCU registers, startup code, interrupts,
timing or peripheral behaviour.
Full NRST-release-to-main latency remains deferred due to the current
lack of hardware reset access and measurement equipment.

## Evidence logs

| Log | Size, bytes | SHA-256 |
|---|---:|---|
| Host Debug CTest | `977` | `0E83AA2889966768FAF936B3BC6B92F4C2587C6326E67BEC06B475D0F98460B1` |
| Host Release CTest | `983` | `9B1274FE2B31530AD3640B6791BF6C916455497166218DFD2A29ED223F4330C8` |
| Target Debug build | `813` | `2BDC8364385F3C3DA13DE263106AB61DDD905631FF3FDB1D71811051C38F2A89` |
| Target Release build | `815` | `FE37034D6739E5F54C5D2B5A4A7527AF2873F8C035E5807CC5A4F0113D6A0215` |