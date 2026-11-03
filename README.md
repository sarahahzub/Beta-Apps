# Beta Apps

Test builds of [WebOS Chromium](https://github.com/sarahahzub/WebOS-Chromium) and
[webOS ATL](https://github.com/sarahahzub/WebOS-ATL) for LG webOS TVs. Beta apps
install **next to** the normal apps, with their own app id, icon (orange **B** badge), settings and bookmarks, so
testing them never changes or breaks the normal install. Remove a beta app any time from the TV's app list or
Homebrew Channel.
The exception is the webOS ATL 32-bit beta: it **replaces** webOS ATL (see below).

## Chromium Beta 0.0.51

<img src="assets/chromium-beta.png" width="80" alt="Chromium Beta icon">

| | |
|---|---|
| App | Chromium Beta (`org.nativechromium.browser.beta`) |
| What to test | Runs on **webOS 5 (2020) and newer**. The normal Chromium needs webOS 9. |
| Built against | glibc 2.28 and the libwayland API that every webOS since 5 has |
| Size | 105 MB download, about 178 MB installed |

This build passed webosbrew's compatibility check for webOS 5.3, 6.4, 7.4, 8.3, 9.2, 10.2 and 11.2. It hasn't
been tried on a real webOS 5-8 TV yet; that's what we need testers for. Hardware video, the GPU and memory may
behave differently on older models.

**New in 0.0.51:** a GPU report. On TVs where the app turns the GPU off (e.g. LG C1, webOS 6), it asks the
TV's graphics driver once per boot what it supports and writes the answers to
`/tmp/org.nativechromium.browser.beta/media.log` (lines starting with `gpuprobe:`). If you have such a TV and
root access, please attach that file to your report.

**New in 0.0.50:** Chrome no longer crashes at GPU start on TVs whose graphics driver lacks
`eglGetPlatformDisplay` (e.g. LG C1, webOS 6); it falls back to older EGL functions. The GPU still stays off by
default on those TVs (as in 0.0.49) until testers confirm it works. To try GPU drawing (root):
`echo gpu=on > /tmp/org.nativechromium.browser.beta/media.opts`, then restart the app, and report whether pages
draw and scroll. (0.0.49 fixed the crash after the splash screen on those TVs, 0.0.47 a missing
`libwayland-egl.so.1`.)

### Install

**Homebrew Channel:** Settings → **Add repository**:
```
https://raw.githubusercontent.com/sarahahzub/Beta-Apps/main/webosbrew/apps.json
```
then open **Chromium Beta** in the app list and install it.

**Developer Mode:** download the IPK from [Releases](https://github.com/sarahahzub/Beta-Apps/releases), then
`ares-install -d <your-tv> org.nativechromium.browser.beta_0.0.51_arm.ipk`.

### Report

Open a **TV compatibility report** on [WebOS Chromium](https://github.com/sarahahzub/WebOS-Chromium/issues/new/choose)
and write "Beta 0.0.51" in the notes. Please include:
- TV model and webOS version (Settings → Support → TV Information);
- whether it starts and shows the New Tab page;
- whether a YouTube video plays smoothly;
- whether the remote works (arrows, OK, Back, 3-dot menu).

If it doesn't start, the TV shows a short message when the webOS version is too old; please include that text.
With SSH access, `/tmp/org.nativechromium.browser.beta/media.log` and `browser.log` help a lot.

## webOS ATL 32-bit beta 0.2.1

<img src="assets/webosatl32-beta.png" width="80" alt="webOS ATL icon">

| | |
|---|---|
| App | webOS ATL 32-bit beta (`org.webosatl.manager`, the same id as webOS ATL) |
| What to test | Android apps on the **32-bit ATL runtime only** (armv7 soft-float, the TV's own ABI) |
| Needs | A rooted TV with Homebrew Channel (aarch64 CPU, 1.2 GB RAM, 600 MB free in `/media/developer`) |
| Size | 371 KB IPK; the manager then downloads the 257 MB runtime (`webosatl-runtime32-0.2.1.sqfs`) |

**New in 0.2.1** (the manager downloads runtime 0.2.1 after the update, about 257 MB):

- **USB storage (off by default).** Settings → **Storage** can move the Android runtime and the apps' data (APKs,
  app data, caches) to a USB drive and back. The drive can be FAT32, exFAT or NTFS: the apps' data goes into one
  ext4 image file on the drive (`webosatl/data.ext4`, 2-16 GB, at most 4 GB on FAT32), created with the TV's own
  `mkfs.ext4`. The programs and the manager stay in internal storage. Moving closes the Android apps, copies the
  files, checks the copy, and deletes the old copy only after the switch. The page shows the free space in internal
  storage, on the drive and in the data image. Keep the drive plugged in: without it, Android apps don't start
  (the TV says why) and nothing is written to internal storage instead. If the drive is pulled out, the running
  Android apps are closed; plug it back in and they work again. At start-up webOS ATL waits up to 90 s for the drive.
  ([issue #6](https://github.com/sarahahzub/WebOS-ATL/issues/6))
- **Updating from webOS ATL 0.1.x or beta 0.2.0 loads the new programs.** The old service could not restart
  itself on the TV, so setup could hang at "Preparing the download". The app now restarts an old service itself.
- **Hardware video decoding** (per app: Android apps → the app → Hardware video decode) uses LG's Starfish
  pipeline for H.264, HEVC and VP9; 0.2.0 shipped an older helper that the runtime could not talk to.
- **No more black 4K video:** video that the TV has to decode in software is offered at most 1080p, so apps such
  as SmartTube pick a size that plays.
- **SmartTube:** use the **armeabi-v7a** (or universal) APK from SmartTube's releases. The arm64-v8a APK is
  refused by this 32-bit build.
- **Video decoder released on close:** the hardware video helper now always exits within 5 s when an app closes,
  so the next app that plays video can get the decoder ("Fail to acquire SUB_SCALER resource" before).
- **RAM:** an app's cache folder in `/tmp` (RAM on the TV) is deleted when the app stops.

**0.2.0** (still true):

- **32-bit only.** No 64-bit runtime is downloaded or used. Apps that ship only 64-bit (`arm64-v8a`) native
  libraries are refused: the TV shows a short message, and the app's log in webOS ATL says why.
- **It replaces an existing webOS ATL install.** Installed Android apps and their data stay. A 64-bit runtime left
  by webOS ATL 0.1.x is removed to free its space.
- **Rollback:** reinstall `org.webosatl.manager` 0.1.1 from
  [WebOS-ATL releases](https://github.com/sarahahzub/WebOS-ATL/releases/tag/v0.1.1) (Homebrew Channel with the
  WebOS-ATL repository, or `ares-install`). It downloads the 64-bit runtime again.

Tested only in GitHub runner twins of an LG 43UR7500 (webOS TV Lite 10.3.1): 597 of 1043 apps worked, and 410 of
the 625-app core set. It has **not been tried on a real TV yet**. LG GL (`ATL_GL=lg`) and hardware video decoding
are untested with this runtime.

### Install

**Homebrew Channel:** Settings → **Add repository**:
```
https://raw.githubusercontent.com/sarahahzub/Beta-Apps/main/webosbrew/apps.json
```
then install **webOS ATL 32-bit beta**. Open it and press **Install** (or, after an update from webOS ATL, wait for
the runtime download on the Status page).

**Developer Mode:** download the IPK from
[the release](https://github.com/sarahahzub/Beta-Apps/releases/tag/webosatl32-beta-v0.2.1), then
`ares-install -d <your-tv> org.webosatl.manager_0.2.1_all.ipk`, open webOS ATL and press **Install**.

### Report

Open an issue on [WebOS-ATL](https://github.com/sarahahzub/WebOS-ATL/issues/new) and write "32-bit beta 0.2.1" in
the title. Please include:
- TV model and webOS version (Settings → Support → TV Information);
- whether setup finished and the Status page shows the Android runtime as 0.2.1;
- if you try USB storage: the drive's file system (FAT32, exFAT, NTFS) and whether moving there and back worked;
- which apps start and work, and which don't (app name and where you got the APK);
- for an app that fails: its log (webOS ATL → Android apps → the app → **App log**).

With SSH access, `/media/developer/webosatl/logs/atld.log` and `atlmgr.log` help a lot.
