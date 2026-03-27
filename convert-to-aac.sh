#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Convert to AAC 64kHz
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🎵
# @raycast.packageName Audio Tools
# @raycast.argument1 { "type": "dropdown", "placeholder": "Sample Rate", "optional": true, "data": [{"title": "64000 Hz (default)", "value": "64000"}, {"title": "44100 Hz", "value": "44100"}, {"title": "48000 Hz", "value": "48000"}, {"title": "96000 Hz", "value": "96000"}, {"title": "Same as source", "value": "source"}] }
# @raycast.argument2 { "type": "dropdown", "placeholder": "Bitrate", "optional": true, "data": [{"title": "64k (default)", "value": "64k"}, {"title": "96k", "value": "96k"}, {"title": "128k", "value": "128k"}, {"title": "192k", "value": "192k"}] }

# Documentation:
# @raycast.description Convert selected audio files to AAC format with 64000 Hz sample rate
# @raycast.author Marcin
# @raycast.authorURL https://github.com/marcin

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

if ! command -v ffmpeg &> /dev/null; then
    echo "❌ Install ffmpeg: brew install ffmpeg"
    exit 1
fi

SAMPLE_RATE="${1:-64000}"
BITRATE="${2:-64k}"

# Get selected files from Finder
FILES=$(osascript -e '
tell application "Finder"
    set selectedItems to selection
    if selectedItems is {} then
        return ""
    end if
    set filePaths to ""
    repeat with i in selectedItems
        set filePaths to filePaths & POSIX path of (i as alias) & linefeed
    end repeat
    return filePaths
end tell
')

if [ -z "$FILES" ]; then
    echo "❌ Select files in Finder"
    exit 1
fi

AUDIO_EXTENSIONS="mp3|wav|flac|m4a|aac|ogg|wma|aiff|opus|webm|mp4|mkv|avi|mov"

converted=0

while IFS= read -r file; do
    [ -z "$file" ] && continue
    [ ! -f "$file" ] && continue
    
    extension="${file##*.}"
    extension_lower=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
    
    if ! echo "$extension_lower" | grep -qiE "^($AUDIO_EXTENSIONS)$"; then
        continue
    fi
    
    dir=$(dirname "$file")
    basename=$(basename "$file" ".$extension")
    output="$dir/${basename}_64k.aac"
    
    counter=1
    while [ -f "$output" ]; do
        output="$dir/${basename}_64k_${counter}.aac"
        ((counter++))
    done
    
    if [ "$SAMPLE_RATE" = "source" ]; then
        SR_ARGS=""
    else
        SR_ARGS="-ar $SAMPLE_RATE"
    fi
    
    # -nostdin prevents ffmpeg from reading stdin (which contains our file list)
    if ffmpeg -nostdin -i "$file" -c:a aac -b:a "$BITRATE" $SR_ARGS -vn -y "$output" 2>/dev/null; then
        ((converted++))
    fi
done <<< "$FILES"

if [ $converted -gt 0 ]; then
    [ "$SAMPLE_RATE" = "source" ] && sr_info="source" || sr_info="${SAMPLE_RATE}Hz"
    echo "✅ Converted $converted file(s) to AAC ($sr_info, $BITRATE)"
else
    echo "❌ No audio files found to convert"
fi
