# Beta Apps

Test builds of [WebOS Chromium](https://github.com/sarahahzub/WebOS-Chromium) and
[webOS ATL](https://github.com/sarahahzub/WebOS-ATL) for LG webOS TVs. Beta apps
install **next to** the normal apps, with their own app id, icon (orange **B** badge), settings and bookmarks, so
testing them never changes or breaks the normal install. Remove a beta app any time from the TV's app list or
Homebrew Channel.
The exception is the webOS ATL 32-bit beta: it **replaces** webOS ATL (see below).

## Chromium Beta 0.0.47

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

**New in 0.0.47:** fixes the app closing right after the splash screen on TVs such as the LG C1 (webOS 6).
Chrome needed a GPU library under the file name `libwayland-egl.so.1`, which some TVs don't have; it now finds
the TV's library under whichever name that TV uses. (0.0.46 fixed a different start-up problem.) If videos play
with sound but a black picture, please say so in your report.

### Install

**Homebrew Channel:** Settings → **Add repository**:
```
https://raw.githubusercontent.com/sarahahzub/Beta-Apps/main/webosbrew/apps.json
```
then open **Chromium Beta** in the app list and install it.

**Developer Mode:** download the IPK from [Releases](https://github.com/sarahahzub/Beta-Apps/releases), then
`ares-install -d <your-tv> org.nativechromium.browser.beta_0.0.47_arm.ipk`.

### Report

Open a **TV compatibility report** on [WebOS Chromium](https://github.com/sarahahzub/WebOS-Chromium/issues/new/choose)
and write "Beta 0.0.47" in the notes. Please include:
- TV model and webOS version (Settings → Support → TV Information);
- whether it starts and shows the New Tab page;
- whether a YouTube video plays smoothly;
- whether the remote works (arrows, OK, Back, 3-dot menu).

If it doesn't start, the TV shows a short message when the webOS version is too old; please include that text.
With SSH access, `/tmp/org.nativechromium.browser.beta/media.log` and `browser.log` help a lot.

## webOS ATL 32-bit beta 0.2.0

<img src="assets/webosatl32-beta.png" width="80" alt="webOS ATL icon">

| | |
|---|---|
| App | webOS ATL 32-bit beta (`org.webosatl.manager`, the same id as webOS ATL) |
| What to test | Android apps on the **32-bit ATL runtime only** (armv7 soft-float, the TV's own ABI) |
| Needs | A rooted TV with Homebrew Channel (aarch64 CPU, 1.2 GB RAM, 600 MB free in `/media/developer`) |
| Size | 345 KB IPK; the manager then downloads the 257 MB runtime (`webosatl-runtime32-0.2.0.sqfs`) |

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
[the release](https://github.com/sarahahzub/Beta-Apps/releases/tag/webosatl32-beta-v0.2.0), then
`ares-install -d <your-tv> org.webosatl.manager_0.2.0_all.ipk`, open webOS ATL and press **Install**.

### Report

Open an issue on [WebOS-ATL](https://github.com/sarahahzub/WebOS-ATL/issues/new) and write "32-bit beta 0.2.0" in
the title. Please include:
- TV model and webOS version (Settings → Support → TV Information);
- whether setup finished and the Status page shows the Android runtime as 0.2.0;
- which apps start and work, and which don't (app name and where you got the APK);
- for an app that fails: its log (webOS ATL → Android apps → the app → **App log**).

With SSH access, `/media/developer/webosatl/logs/atld.log` and `atlmgr.log` help a lot.
