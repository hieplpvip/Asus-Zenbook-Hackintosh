# Installation Instruction

## Prerequisites

- Time and patience
- Basic knowledge of command line
- ~~A computer running macOS (for running scripts in this repo)~~ 

While not necessary, I recommend reading Dortania's [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/) entirely before we start to get a feel of how OpenCore/Hackintosh works. Don't worry if you're new to Hackintosh and get overwhelmed with the amount of information there. All the files have been prepared for you in this repo; you just need to follow the instruction below.

__Script can also be run in Windows, just download [iasl binary](https://acpica.org/downloads/binary-tools) and replace it in tools/asl__. (Maybe you also need installation of Git Bash).

## Step 0: Clone this repo

If you haven't cloned this repo, do it now:

```shell
git clone https://github.com/hieplpvip/Asus-Zenbook-Hackintosh zenbook
cd zenbook
```

## Step 1: Generate Serial Number

Follow [this guide](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html#generate-a-new-serial) to generate a fake serial number for yourself. Never use someone else's serial number!

In `src` folder, create a copy of `smbios-sample.txt` called `smbios.txt`:

```shell
cp src/smbios-sample.txt src/smbios.txt
```

Put your newly generate serial number in `smbios.txt`. It will be used to generate OpenCore config for you.

## Step 2: Building EFI folder

- Download necessary kexts and drivers:

```shell
./download.sh
```

- Build EFI folder:

```shell
./build.sh
```

## Step 3: Prepare USB Installer

Follow [this guide](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/mac-install.html#downloading-macos-modern-os) to create a macOS USB Installer.

When you get to `Now with all of this done, head to Setting up the EFI to finish up your work`, copy `EFI` folder in `build` to your USB EFI volume.

Now you're ready to install macOS.

## Step 4: Install macOS

Restart your laptop and boot from your USB. The installation process is fairly straightforward. If you're confused, read [this](https://dortania.github.io/OpenCore-Install-Guide/installation/installation-process.html#double-checking-your-work).

## Step 5: Post installation

Use [MountEFI](https://github.com/corpnewt/MountEFI) to mount the EFI volume on your main disk drive (not your USB) and copy `EFI` folder in `build` to it. Now you can boot without USB.

Congratulations! You have successfully installed macOS on your Zenbook laptop. There're still some works to do, though:

#### Enable HiDPI to get better display resolution

We'll use [one-key-hidpi](https://github.com/xzhih/one-key-hidpi). Since it requires making changes to root filesystem, which is read-only on Catalina+ when SIP is enabled, we need to disable SIP first (see [this guide](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/extended/post-issues.html#disabling-sip)).

After that, run the command from [one-key-hidpi](https://github.com/xzhih/one-key-hidpi)'s README and Restart your laptop.

Finally, don't forget to re-enable SIP for better security.

#### Test iMessage, Facetime, etc.

If you have correctly generated serial number, these services should work for you. If not, [clean up](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html#clean-out-old-attempts) and generate a new serial number.

#### Unlock 0xE2 MSR

While not needed, you are recommended to do it (for better system stability). Follow [this guide](https://dortania.github.io/OpenCore-Post-Install/misc/msr-lock.html).

#### Fix Other Issues
- If you experience poor quality audio, try to change frequency of audio output to 48,0Hz in 'Midi Audio Setup'. 
- Sometimes Audio from Speaker or Jack randomly disappear in some models, in this case closing and reopening the lid should fix. 

