# Unlock 0xE2 MSR

## [VerifyMsrE2](https://github.com/acidanthera/AptioFixPkg)

Certain firmwares fail to properly initialize 0xE2 MSR register (`MSR_BROADWELL_PKG_CST_CONFIG_CONTROL`) across all the cores. This application prints 0xE2 values of all the cores and reports 0xE2 status. The notable example of desyncrhonised 0xE2 MSR registers are several GIGABYTE UEFI firmwares for Intel 100 Series and Intel 200 Series chipsets.

CFG Lock option is available on most APTIO V firmwares, although it may be hidden from the GUI. If VerifyMsrE2 reports that your 0xE2 register is consistently locked, you may try to unlock this option directly.

1. Download [UEFITool](https://github.com/LongSoft/UEFITool/releases) and [IFR-Extractor](https://github.com/LongSoft/Universal-IFR-Extractor/releases).
2. Open your firmware image in UEFITool and find `CFG Lock` unicode string. If it is not present, your firmware does not support this and you should stop.
3. Extract the Setup.bin PE32 Image Section that UEFITool found via Extract Body.
4. Run IFR-Extractor on the extracted file (e.g. `./ifrextract Setup.bin Setup.txt`).
5. Find `CFG Lock, VarStoreInfo (VarOffset/VarName):` in `Setup.txt` and remember the offset right after it (e.g. `0x123`).
6. Download and run a [modified GRUB Shell](http://brains.by/posts/bootx64.7z), thx to [brainsucker](https://geektimes.com/post/258090/) for the binary.
7. Enter `setup_var 0x123 0x00` command, where `0x123` should be replaced by your actual offset and reboot.

**WARNING**: variable offsets are unique not only to each motherboard but even to its firmware version. Never ever try to use an offset without checking.
