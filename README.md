# Beta Apps

Test builds of [WebOS Chromium](https://github.com/sarahahzub/WebOS-Chromium) for LG webOS TVs. Beta apps
install **next to** the normal apps, with their own app id, icon (orange **B** badge), settings and bookmarks, so
testing them never changes or breaks the normal install. Remove a beta app any time from the TV's app list or
Homebrew Channel.

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
