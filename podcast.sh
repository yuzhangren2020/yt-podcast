#!/bin/bash
DOC_ROUTE="/var/www/html"
WORK_DIR="/home/pi/yt-podcast"
HOST_IP=`hostname -I | cut -f1 -d' '` # eth0
TITLE="podcast"
TITLE_DIR="${DOC_ROUTE}/${TITLE}"

# download youtube
CHANNELS=("https://www.youtube.com/c/%E4%BA%9A%E5%86%9B%E7%8E%8B%E6%AD%AA%E5%98%B4/videos" \
"https://www.youtube.com/c/SIYUANXU/videos" \
"https://www.youtube.com/channel/UCjvjNeHndz4PGs9JXhzdHqw/videos" \
"https://www.youtube.com/channel/UCtAIPjABiQD3qjlEl1T5VpA/videos" \
"https://www.youtube.com/channel/UC1Lk6WO-eKuYc6GHYbKVY2g/videos" \
"https://www.youtube.com/c/gavinzhou/videos" \
"https://www.youtube.com/channel/UCX8KQ5xQlm0MnZkmHO7CBDw/videos" \
"https://www.youtube.com/channel/UCdCAD0k5hwdgvwcEhNlaxIA/videos")

for CHANNEL in "${CHANNELS[@]}"
do
    yt-dlp -x --audio-format mp3 --trim-filenames 30 --min-filesize 3m --max-filesize 60m --playlist-end 3 --paths $TITLE_DIR --download-archive archive $CHANNEL
done

# make rss file
ruby $WORK_DIR/makepodcast.rb $TITLE http://$HOST_IP/$TITLE/ $TITLE_DIR > $TITLE_DIR/$TITLE.rss
