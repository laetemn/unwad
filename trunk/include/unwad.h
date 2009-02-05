/*
    convert a lump to a png file
 */
#include <cstdlib>
#include <map>
#include <vector>


/****************************
                    ZIP
*****************************/


class Zip // wraps some bastardized code from zlib/contrib (aka minizip)
{
  
private:
  
  static std::map<std::string, bool> seenFiles;
  
  static std::string fixPath(std::string path);
  
public:
  

  static bool packFiles(std::vector<std::string> files, std::string zippath, unsigned stripChars=0);

   // this works fine on linux, but guess what...
  static bool packFile(std::string filepath, std::string zippath, unsigned stripChars=0, bool overwrite=false);
  
};

/****************************
            FILESYSTEM
*****************************/

class Filesystem
{
private:
  
  static bool makeDir(std::string path);
  
public:
  
  static bool exists(std::string path);
  
  static void create_directories(std::string path);

};


/****************************
                REGEX
*****************************/

class Regex
{
private:
  
public:
  
  // determine if regex matches some text
  static bool match(const char *regex, const char *text);
  static bool match(std::string regex, std::string text);
  
  // if regex matches, replace text with other text
  static std::string replace(const char *regex, const char *text, const char *replacement);
  
  static std::string replace(std::string regex, std::string text, std::string replacement);
};

/****************************
                LUMP
*****************************/

class Patch
{
public:
  struct PatchHead
  {
    short	width;
    short	height;
    short	left;
    short	top;
  };
  
};

class Lump 
{
private:

  short looksLikeAPatch;  // -1 = not sure, 0 = no, 1 = yes 
  static bool staticStuffInitted;

public:
  
  // data from wad directory
  struct DirectoryEntry
  {
    long offset;
    long size;
    char name[8];
    
    DirectoryEntry()
    {
      for(unsigned i=0; i<8; i++) name[i] = 0;
    }
  };
  
  // types of lumps
  enum LumpType
  {
    UNKNOWN = 'u',NAMED = 'k',  // named: self-named lump, like playpal or endoom
    MAP = 'l',  ACS = 'o', TEXTURE = 't', GFX = 'g', SPRITE = 's', 
    PATCH = 'p', FLAT = 'f', SOUND = 'n', MUSIC = 'm', 
    MARKER=-1, COLORMAP=-2
  };
  
  // known lump formats
  enum LumpFormat
  {
    GENERIC = 0, BINARY, TEXT,
    DOOMPIC,   // playpal doom patch
    DOOMPICT, //titlepal doom patch
    DOOMFLAT, DOOMSND, DOOMMUS
  };
  
  //properties
  
  DirectoryEntry info;  // lump info from wad directory
  std::vector<char> data; // this will hold a copy of the lump's data
  LumpType type;  // type of lump
  LumpFormat format;  // format of lump
  std::string formatDescription;  // description of lump format 
  std::string fileExtension;  // file extension to add
  std::string map; // the map (level) this lump is associated with, if any
  
  static std::map<std::string, Lump::LumpType> lumpTypesByName;
  static std::map<Lump::LumpType, std::string> typeNames;
  static std::map<std::string, std::string> namedLumps;
  
  
  Lump(); // constructor
  
  // return name of lump as string
  std::string getName(bool lower=false);
  
  // guess type of lump; set the type
  void guessType();
  
  // is it a patch?
  bool isPatch();
  
  // is it a flat?
  bool isFlat();
  
  // write patch data to disk.
  bool write(std::string filename);
  
  // append data to file.
  bool append(std::string filename);
  
};




/****************************
           OPTIONS
*****************************/

class Options
{
public :
    
  unsigned char *palette;
  unsigned char palData[256*3];
  std::string palFile; // file to get palette from
  std::string types;  // string of characters  representing types of lump to extract (or types to skip if first char is '!')
  std::string outPath;  // path to save wad to
  std::vector<std::string > filters; // lump filter strings like: [!]types/[!]regex
  std::vector<std::string > substitutions; // lump rename strings like: [!]types/[!]regex/replacement
  bool list; // only list lumps, don't extract
  bool internalPalette; // use internal playpal lump
  bool upper; // upper-case lump names
  bool append;  // append text lumps
  bool pk3;
  int groupSprites;
  
  Options(); // constructor
  
  // should lump be saved?
  bool shouldSaveLump(Lump *lump);
  
  std::string substitute(std::string substitution, std::string target);
  
  std::string getLumpSaveName(Lump *lump) ;
  
};


/****************************
          FormatGuesser
*****************************/

class FormatGuesser 
{
public:
  
  static std::string getDataFormat( const void * buffer, size_t length);
  static std::string getDataFormat( Lump *lump);
  
  static std::string getExtension( const void * buffer, size_t length);
  static std::string getExtension( Lump *lump);
};



/****************************
          FlatToPng
*****************************/

class FlatToPng 
{
public:
  static bool write ( Lump *lump, unsigned char *palette, std::string pngpath );
};


/****************************
          PatchToPng
*****************************/

class PatchToPng 
{
public:

  // write a png file given a lump and palette data

  static bool write ( Lump *lump, unsigned char *palette, std::string pngpath);
  
  // swap bytes for big endian format (TODO: move this)

  static inline unsigned long byteSwapULong(unsigned long nLongNumber);
  
  static inline unsigned long byteSwapLong(long value);
  
private:
  
  // CRC stuff for PNG.
  // This can probably be done by zlib?

  /* Table of CRCs of all 8-bit messages. */
  static unsigned long crc_table[256];

  /* Flag: has the table been computed? Initially false. */
  static int crc_table_computed; // = 0;

  /* Make the table for a fast CRC. */
  static void make_crc_table(void);
  /* Update a running CRC with the bytes buf[0..len-1]--the CRC
  should be initialized to all 1's, and the transmitted value
  is the 1's complement of the final running CRC (see the
  crc() routine below)). */
  static unsigned long update_crc(unsigned long crc, unsigned char *buf, int len);

  /* Return the CRC of the bytes buf[0..len-1]. */
  static unsigned long crc(unsigned char *buf, int len);


};




/****************************
    DOOM SOUND EXPORT
*****************************/

class DoomSndExport
{
public:
  
  struct DoomSoundHead
  {
    unsigned short three;
    unsigned short samplerate;
    unsigned short samples;
    unsigned short zero;
  };

  struct AuSoundHead
  {
    unsigned long magic;
    unsigned long offset;
    unsigned long size;
    unsigned long encoding;
    unsigned long rate;
    unsigned long channels;
    
    // copy constructor
    AuSoundHead()
    {
      magic = PatchToPng::byteSwapULong (0x2e736e64); // ".snd"
      offset = PatchToPng::byteSwapULong (24); // length of header
      size = 0xffffffff; // unknown size
      encoding = PatchToPng::byteSwapULong (2); // 8-bit linear PCM
      channels = PatchToPng::byteSwapULong (1);
    }
    
  };

  struct WavSoundHead
  {
    char riff[4];
    unsigned size;
    char wave[4];
    char fmt[4];
    unsigned x10;
    unsigned short x01;
    unsigned short channels;
    unsigned rate;
    unsigned bytesPerSecond;
    unsigned short bytesPerSample;
    unsigned short bitsPerSample;
    char data[4];
    unsigned length;
    
    // copy constructor
    WavSoundHead()
    {
      riff[0] = 'R'; riff[1] = 'I'; riff[2] = 'F'; riff[3] = 'F' ;
      wave[0] = 'W'; wave[1] = 'A'; wave[2] = 'V'; wave[3] = 'E' ;
      fmt[0] = 'f'; fmt[1] = 'm'; fmt[2] = 't'; fmt[3] = ' ' ;
      x10 = 0x10; // length of format chunk
      x01 = 0x01;
      channels = 1;
      bytesPerSample = 1; // 8 bit mono
      bitsPerSample = 8; // 8 bit mono
      data[0] = 'd'; data[1] = 'a'; data[2] = 't'; data[3] = 'a' ;
    }
    
  };

private:
  
  static bool writeAu(Lump *lump, std::string filename);
  
  static bool writeWav(Lump *lump, std::string filename);
  
public:
  
  enum SoundFormat
  {
    AU = 0, WAV
  };

  static bool write(Lump *lump, std::string filename, SoundFormat format);
    
};

/****************************
    DOOM MUSIC TO MIDI
*****************************/


class DoomMusToMidi 
{
public:
  
  static bool write(Lump *lump, std::string filename);
    
};


/****************************
                WAD
*****************************/

class Wad 
{
  
  
public:
  
  struct WadHead 
  {
    char magic[4]; 
    unsigned long lumpCount; 
    unsigned long directoryOffset;
    
    WadHead() // copy constructor
    {
      magic[0]='P';magic[1]='W';magic[2]='A';magic[3]='D';
    };
    
    std::string getMagic(){return std::string(magic,0,4); };
    
  };
  
  WadHead head;
  std::vector<Lump> lumps;
  
  Wad();
  
  // put a file into a pk3
  void packFile(std::string path, std::string pk3path, unsigned strip=0, bool overwrite = false);
  
  void loadFile(std::string path, Options *options );
  
private:
  
  std::map<std::string, Lump::LumpType> lumpTypesByName;

  void setLumpTypeFromName(Lump *lump);
  
  void preparePath(std::string pathOrFile);
 
};


void showHelp();

/****************************
                MAIN
*****************************/

int unwad_main(int argc,char **argv) ;

#ifndef UNWAD_OBJECT
int main(int argc,char **argv);
#endif

