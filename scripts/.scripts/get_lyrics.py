import re
import eyeD3
import urllib.request
import argparse
from bs4 import BeautifulSoup
 
def get_lyrics(artist,song_title):
    artist = artist.lower()
    song_title = song_title.lower()
    # remove all except alphanumeric characters from artist and song_title
    artist = re.sub('[^A-Za-z0-9]+', "", artist)
    song_title = re.sub('[^A-Za-z0-9]+', "", song_title)
    if artist.startswith("the"):    # remove starting 'the' from artist e.g. the who -> who
        artist = artist[3:]
    url = "http://azlyrics.com/lyrics/"+artist+"/"+song_title+".html"
    
    try:
        content = urllib.request.urlopen(url).read()
        soup = BeautifulSoup(content, 'html.parser')
        lyrics = str(soup)
        # lyrics lies between up_partition and down_partition
        up_partition = '<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->'
        down_partition = '<!-- MxM banner -->'
        lyrics = lyrics.split(up_partition)[1]
        lyrics = lyrics.split(down_partition)[0]
        lyrics = lyrics.replace('</i>','').replace('<i>','').replace('<br>','').replace('</br>','').replace('<br/>','').replace('</div>','').strip()
        return lyrics
    except Exception as e:
        return "Exception occurred \n" +str(e)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='get_lyrics')
    parser.add_argument('arg0', nargs='?', metavar='arg0', type=str, help='artist of the song you want the lyrics from if --file is used, used for path')
    parser.add_argument('arg1', nargs='?', metavar='arg1', type=str, help='title of the song you want the lyrics from')
    parser.add_argument('--file', dest='input_method', action='store_const', const='filename', default='artist and title', help='use this flag to handle input as filename')
    args = parser.parse_args()
    if args.input_method == 'filename':
        path = args.arg0
        tag = eyeD3.Tag()
        print(path)
        tag.link(path)

    else:
        artist = args.arg0
        title = args.arg1
        print (get_lyrics(artist, title))
