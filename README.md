# Convert to AAC 64kHz — Raycast Script

A Raycast script that converts selected audio (and audio from video) files to AAC, with **64 kHz** sample rate and **64 kbps** bitrate as defaults.

## Features

- Batch conversion of multiple Finder selections
- Audio extraction from common video containers
- Optional arguments in Raycast:
  - **Sample rate:** 64000 Hz (default), 44100 Hz, 48000 Hz, 96000 Hz, or same as source
  - **Bitrate:** 64k (default), 96k, 128k, 192k

## Supported formats

**Audio (input):** mp3, wav, flac, m4a, aac, ogg, wma, aiff, opus

**Video (audio track only):** mp4, mkv, avi, mov, webm

**Output:** AAC (`.aac`)

## Requirements

```bash
brew install ffmpeg
```

The script prepends Homebrew paths (`/opt/homebrew/bin`, `/usr/local/bin`) so `ffmpeg` is found when installed via Homebrew.

## Installation

1. Copy the script into your Raycast scripts folder, for example:

   ```bash
   cp convert-to-aac.sh ~/Documents/Raycast\ Script/
   chmod +x ~/Documents/Raycast\ Script/convert-to-aac.sh
   ```

2. In Raycast, refresh scripts (**⌘⇧R**).

## Usage

1. Select one or more files in **Finder**.
2. Run **Convert to AAC 64kHz** from Raycast.
3. Optionally choose sample rate and bitrate from the dropdowns.
4. Outputs are written next to the originals as `name_64k.aac`. If that name exists, the script uses `name_64k_1.aac`, `name_64k_2.aac`, and so on.

Non-audio extensions are skipped silently; if nothing matches, you’ll see a “no audio files” message.

## Output settings

| Setting      | Default   |
|-------------|-----------|
| Codec       | AAC       |
| Sample rate | 64000 Hz  |
| Bitrate     | 64 kbps   |
| Container   | `.aac` (ADTS) |
| Video       | Stripped (`-vn`) |

## Size example (rough)

For a ~16 minute source:

| Source / variant        | Approx. size |
|-------------------------|--------------|
| Original M4A @ 256 kbps | ~31 MB       |
| This script @ 64k       | ~8 MB        |
| This script @ 96k       | ~12 MB       |
| This script @ 128k      | ~15 MB       |

## Filename examples

```
input.m4a   → input_64k.aac
song.flac   → song_64k.aac
podcast.mp3 → podcast_64k.aac
video.mp4   → video_64k.aac   (audio only)
```

---

**Author:** Marcin  Tymków
**License:** MIT
