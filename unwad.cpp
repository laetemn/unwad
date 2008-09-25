/*
    convert a lump to a png file
 */
 #include <stdio.h>
#include <cstdlib>
#include <map>
#include <math.h>
#include <iostream>
#include <fstream>
#include <ostream>
#include <sstream> // string stream


#include <png.hpp>  // make pngs

#include <magic.h>  // magically guess file types ;p

#include <minizip.h>  // zip stuff




/****************************
                    ZIP
*****************************/

class Zip // wraps some bastardized code from zlib/contrib (aka minizip)
{
  /*
  // int mz_main(int argc, char *argv[])
  
  printf("Usage : minizip [-o] [-a] [-0 to -9] [-p password] file.zip [files_to_add]\n\n" \
       "  -o  Overwrite existing file.zip\n" \
       "  -a  Append to existing file.zip\n" \
       "  -0  Store only\n" \
       "  -1  Compress faster\n" \
       "  -9  Compress better\n\n");
  */
  
private:
  
  static std::map<std::string, bool> seenFiles;
  
  static std::string fixPath(std::string path)
  {
#ifdef MSW
    for (unsigned i = 0; i<path.length(); i++)
    {
      if (path[i] == '/') path[i] = '\\';
    }
    // printf("\n newpath: %s\n", path.c_str());
#endif
    return path;
  }
  
public:
  

  static bool packFiles(std::vector<std::string> files, std::string zippath, unsigned stripChars=0)
  {
    std::stringstream strip("");
    strip << ">" << stripChars;
    files.insert(files.begin(),fixPath(zippath));
    files.insert(files.begin(),strip.str());
    files.insert(files.begin(),"-o");
    files.insert(files.begin(),"minizip");
    
    unsigned argc = files.size();
    
    const char *args[argc];
    
    for (unsigned i = 0; i < argc; i++) args[i] = files[i].c_str();
    
    bool result = !mz_main(argc, (char **)args);
    return result;
  };

   // this works fine on linux, but guess what...
  static bool packFile(std::string filepath, std::string zippath, unsigned stripChars=0, bool overwrite=false)
  {
    std::stringstream strip("");
    strip << ">" << stripChars;
    const char *ow = (overwrite || seenFiles.find(zippath) == seenFiles.end() ? "-o" : "-a");
    const char *args[] =
    {
      "minizip",ow,"-6", strip.str().c_str(), fixPath(zippath).c_str(), filepath.c_str()
    };
    int argcount = sizeof(args) / sizeof(char *);
    seenFiles[zippath] = true;
    return !mz_main(argcount, (char **)args);
  };
  
};
std::map<std::string, bool> Zip::seenFiles;

/****************************
            FILESYSTEM
*****************************/
#ifndef MSW
  #include <sys/stat.h>   // for mkdir
#endif

class Filesystem
{
private:
  
  static bool makeDir(std::string path)
  {
    // if (system(("mkdir " + path).c_str()))
#ifdef MSW
    if( mkdir( path.c_str() ) == 0 ) return true;
#else
    if( mkdir( path.c_str(), 0777 ) == 0 ) return true;
#endif
    
    return false;
  }
  
public:
  
  static bool exists(std::string path)
  {
    std::fstream f;
    f.open(path.c_str(), std::ios::in);
    if( f.is_open() )
    {
      f.close();
      return true;
    }
    f.close();
    return false;
  }
  
  static void create_directories(std::string path)
  {
    std::stringstream ss("");
    const char *p = path.c_str();
    for (unsigned i = 0; i < path.length(); i++)
    {
      ss << p[i];
      std::string s = ss.str();
      if (p[i]=='/' && !exists(s)) makeDir(s);
    }
    std::string s = ss.str();
    if (!exists(s))makeDir(s);
  }

};


/****************************
                REGEX
*****************************/

#include <sys/types.h>
#include <regex.h>

class Regex
{
private:
  
public:
  
  // determine if regex matches some text
  static bool match(const char *regex, const char *text)
  {
    regex_t compiledRegex;
    int cflags = REG_EXTENDED | REG_ICASE | REG_NOSUB;
    int error = regcomp((regex_t *)&compiledRegex, regex, cflags);
    if (error!=0)
    {
      std::cerr<<"\n Invalid regex: " << regex  << " \n";
      exit(EXIT_FAILURE);
    }
    
    size_t nmatch = 0; regmatch_t pmatch[nmatch];
    int result = regexec(&compiledRegex, text, nmatch, pmatch, 0);
    
    regfree((regex_t *)&compiledRegex);
    
    return !result;
  };
  static bool match(std::string regex, std::string text)
  { return match(regex.c_str(), text.c_str()); };
  
  // if regex matches, replace text with other text
  static std::string replace(const char *regex, const char *text, const char *replacement)
  {
    regex_t compiledRegex;
    int cflags = REG_EXTENDED | REG_ICASE;
    int error = regcomp((regex_t *)&compiledRegex, regex, cflags);
    if (error!=0)
    {
      std::cerr<<"\n Invalid regex: " << regex  << " \n";
      exit(1);
    }
    size_t nmatch = 10; regmatch_t pmatch[nmatch];
    int m = regexec(&compiledRegex, text, nmatch, pmatch, 0);
    
    if (m!=0) return std::string(text); 
    
    regfree((regex_t *)&compiledRegex);
    
    //return std::string(text); 
    
    std::stringstream ss("");
    std::string t(text);
    
    for (unsigned i = 0; i < strlen(replacement); i++)
    {
      if(replacement[i]=='\\' && replacement[i+1]>='1' && replacement[i+1]<='9')
      {
        unsigned index = atoi(&replacement[i+1]);
        i++;
        if (pmatch[index].rm_so == -1) continue;
        ss << t.substr(pmatch[index].rm_so, pmatch[index].rm_eo);
      }
      else ss << replacement[i];
    }
    
    return ss.str();
    
  };
  
  static std::string replace(std::string regex, std::string text, std::string replacement)
  {
    return replace(regex.c_str(), text.c_str(), replacement.c_str());
  };
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
  static bool staticStuffInitted;
  
  // constructor
  Lump()
  {
    formatDescription = "";  // description of lump format 
    fileExtension = "";  // file extension to add
    map = ""; // the map (level) this lump is associated with, if any
    type=Lump::UNKNOWN;
    format=Lump::GENERIC;
    looksLikeAPatch = -1;
    if (!staticStuffInitted)
    {
      staticStuffInitted = true;  
      
      // TODO: move namedLumps into an editable config file
      
      typeNames[Lump::UNKNOWN] = "Unknown";
      typeNames[Lump::MARKER] = "Marker";
      typeNames[Lump::NAMED] = "Named lump";
      typeNames[Lump::MAP] = "Map data";
      typeNames[Lump::ACS] = "Action Code Script";
      typeNames[Lump::TEXTURE] = "Texture definitions";
      typeNames[Lump::GFX] = "Image";
      typeNames[Lump::SPRITE] = "Sprite";
      typeNames[Lump::PATCH] = "Patch";
      typeNames[Lump::FLAT] = "Flat";
      typeNames[Lump::SOUND] = "Sound";
      typeNames[Lump::MUSIC] = "Music";
      typeNames[Lump::COLORMAP] = "Boom colormap";
      
      lumpTypesByName["PLAYPAL"] = Lump::NAMED;
      lumpTypesByName["COLORMAP"] = Lump::NAMED;
      lumpTypesByName["ENDOOM"] = Lump::NAMED;
      lumpTypesByName["PNAMES"] = Lump::NAMED;
      lumpTypesByName["GENMIDI"] = Lump::NAMED;
      lumpTypesByName["DMXGUSC"] = Lump::NAMED;
      lumpTypesByName["TEXTURE1"] = Lump::NAMED;
      lumpTypesByName["TEXTURE2"] = Lump::NAMED;
      
      
      namedLumps["PLAYPAL"] = "play palette";
      namedLumps["COLORMAP"] = "color map";
      namedLumps["ENDOOM"] = "text screen";
      namedLumps["PNAMES"] = "patch names";
      namedLumps["GENMIDI"] = "Doom MIDI information";
      namedLumps["DMXGUSC"] = "Doom GUS information";
      namedLumps["TEXTURE1"] ="Doom texture information";
      namedLumps["TEXTURE2"] ="Doom texture information";
      
      // zdoom stuff
      lumpTypesByName["LANGUAGE"] = Lump::NAMED;
      lumpTypesByName["DBIGFONT"] = Lump::NAMED;
      lumpTypesByName["CONFONT"] = Lump::NAMED;
      lumpTypesByName["DOOMDEFS"] = Lump::NAMED;
      lumpTypesByName["MAPINFO"] = Lump::NAMED;
      lumpTypesByName["DECORATE"] = Lump::NAMED;
      lumpTypesByName["ANIMDEFS"] = Lump::NAMED;
      lumpTypesByName["SNDINFO"] = Lump::NAMED;
      lumpTypesByName["KEYCONF"] = Lump::NAMED;
      lumpTypesByName["LOADACS"] = Lump::NAMED;
      lumpTypesByName["DECALDEF"] = Lump::NAMED;
      lumpTypesByName["DEHACKED"] = Lump::NAMED;
      lumpTypesByName["TERRAIN"] = Lump::NAMED;
      lumpTypesByName["SNDSEQ"] = Lump::NAMED;
      lumpTypesByName["HIRESTEX"] = Lump::NAMED;
      lumpTypesByName["TEXTURES"] = Lump::NAMED;
      
      
      namedLumps["LANGUAGE"] = "zdoom string replacements";
      namedLumps["DBIGFONT"] = "zdoom big font";
      namedLumps["CONFONT"] = "zdoom console font";
      namedLumps["DOOMDEFS"] = "gzdoom special effects lump";
      namedLumps["MAPINFO"] = "zdoom map information";
      namedLumps["DECORATE"] = "zdoom actor definitions";
      namedLumps["ANIMDEFS"] = "gzdoom animation information";
      namedLumps["SNDINFO"] = "zdoom sound sample information";
      namedLumps["KEYCONF"] = "zdoom keyboard configuration";
      namedLumps["LOADACS"] = "zdoom ACS script autoloader";
      namedLumps["DECALDEF"] = "zdoom decal definitions";
      namedLumps["DEHACKED"] = "zdoom DEHACKED emulation";
      namedLumps["TERRAIN"] = "zdoom terrain information";
      namedLumps["SNDSEQ"] = "zdoom sound sequencing configuration";
      namedLumps["HIRESTEX"] = "zdoom texture information, deprecated";
      namedLumps["TEXTURES"] = "zdoom texture information";
      
      // lumpTypesByName["DEMO*"] = Lump::NAMED;
      // lumpTypesByName["TEXTURE*"] = Lump::NAMED;
      
      // map lumps
      
      lumpTypesByName["THINGS"] = Lump::MAP;
      lumpTypesByName["LINEDEFS"] = Lump::MAP;
      lumpTypesByName["SIDEDEFS"] = Lump::MAP;
      lumpTypesByName["VERTEXES"] = Lump::MAP;
      lumpTypesByName["SEGS"] = Lump::MAP;
      lumpTypesByName["SSECTORS"] = Lump::MAP;
      lumpTypesByName["NODES"] = Lump::MAP;
      lumpTypesByName["SECTORS"] = Lump::MAP;
      lumpTypesByName["REJECT"] = Lump::MAP;
      lumpTypesByName["BLOCKMAP"] = Lump::MAP;
      lumpTypesByName["BEHAVIOR"] = Lump::MAP;
      
      // texture lumps
      
    }
  }
  
  
  // return name of lump as string
  // std::string getName(){return std::string(info.name,0,8); };
  std::string getName(bool lower=false)
  {
    std::string name(info.name,0,8);
    // make the name lower case and fix backslash in vile for windblows
    for (unsigned i = 0; i<name.length(); i++)
    {
      if (lower && name[i] >= 'A' && name[i] <= 'Z') name[i]+=32;
      if (name[i] == '\\') name[i]='^';
    }
    return  name;
  };
  
  // is it a flat?
  bool isFlat()
  {
    if( (info.size==0x1000)||(info.size==0x2000)||(info.size==0x4000)
        ||(info.size==0x8000)||(info.size==0x1040) )
    {
      int side = (int)sqrt(info.size);
      std::stringstream ss("");
      ss << "Doom flat, " << side << " x " << side;
      formatDescription = ss.str();
      return true;
    }
    return false;
  }
  
  // is it a patch?
  bool isPatch()
  {
    // if we already decided whether it was a patch, skip the checks
    if (looksLikeAPatch != -1) return looksLikeAPatch;
    
    // make sure it's not smaller than a patch header
    if ((int)info.size < (int)sizeof(Patch::PatchHead))
    {
      looksLikeAPatch = false; return false;
    }

    // load the header
    Patch::PatchHead *header = (Patch::PatchHead *)&data.front();
    
    // make sure header reports reasonable dimensions / offsets for a patch
    if (header->height <= 0 || header->height >= 4096 ||
      header->width <= 0 || header->width >= 4096 ||
      header->top <= -2047 || header->top >= 2047 ||
      header->left <= -2047 || header->left >= 2047)
    {
      looksLikeAPatch = false; return false;
    }
    
    // load column offsets
    long *columnOffsets = (long *)((char *)&data.front() + sizeof(Patch::PatchHead));
    
    // make sure size is not smaller than reported width would allow
    if ((int)info.size < (int) (sizeof(Patch::PatchHead) + (header->width * sizeof(long))))
    { 
      looksLikeAPatch = false; return false;
    }
    
    // make sure column offsets are in range
    for (int i = 0; i < header->width; i++)
      if (columnOffsets[i] > info.size || columnOffsets[i] < 0)
      { 
        looksLikeAPatch = false; return false;
      }
    
    // everything checked out
    std::stringstream ss("");
    ss << "Doom patch, " << header->width << " x " << header->height;
    ss << " Offset: " << header->left << " x " << header->top;
    formatDescription = ss.str();
    looksLikeAPatch = true; return true;
  };
  
  // guess type of lump; set the type
  void guessType()
  {
    std::string lumpName = getName();
    
    if (lumpTypesByName.count(lumpName) > 0)
    {
      type = lumpTypesByName[lumpName];
      return;
    }
    
    // Doom MUS?
    if (info.size > 16 && data[0] == 'M' && data[1] == 'U' && data[2] == 'S' 
        && data[3] == 0x1A)
    {
      type = MUSIC; 
      format = DOOMMUS;
      formatDescription = "Doom MUS music lump";
      return;
    }
    
    // Doom Sound?
    if ( (int)data[0] == 3 && (int)data[6] == 0 && (int)data[4] <= info.size - 8)
    {
        type = Lump::SOUND;
        format = Lump::DOOMSND;
        formatDescription = "Doom SND sound lump";
        // incorrectly guesses some graphics as sounds, so don't return yet
    }
    
    // Doom Patch?
    if (isPatch())
    {
      type = ( type == Lump::SPRITE ||  type == Lump::PATCH || type == Lump::TEXTURE ? type : Lump::GFX);
      format = (lumpName=="TITLEPIC" ? Lump::DOOMPICT : Lump::DOOMPIC);
      return;
      // formatDescription = "Doom patch";
    }
    
    // Doom flat?
    if (isFlat())
    {
      type = Lump::FLAT;
      format = DOOMFLAT;
      // formatDescription = "Doom flat";
    }
    
  };
  
  // write patch data to disk.
  bool write(std::string filename)
  {
    std::ofstream outfile(filename.c_str(),std::ios::binary|std::ios::out);
		return outfile.write((char *)&data.front(), data.size());
  };
  
  // append data to file.
  bool append(std::string filename)
  {
    std::ofstream outfile(filename.c_str(),std::ios::binary|std::ios::out|std::ios::app);
		return outfile.write((char *)&data.front(), data.size());
  };
  
};

// static member initialzers for Lump class
std::map<std::string, Lump::LumpType> Lump::lumpTypesByName;
std::map<Lump::LumpType, std::string> Lump::typeNames;
std::map<std::string, std::string> Lump::namedLumps;
bool Lump::staticStuffInitted = false;




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
  
  Options() // constructor
  {
    palFile = "";
    types = "";
    outPath = "";
    for (unsigned i = 3; i<=256*3; i+=3)  // dummy gray palette
      palData[i-3] = palData[i-2] = palData[i-1] = i/3-1;
    list = false;
    internalPalette = false;
    upper = false;
    pk3 = false;
    groupSprites = 0;
  }
  
  // should lump be saved?
  bool shouldSaveLump(Lump *lump)
  {
    
    // check list mode
    if (list == true) return false;
    
    // check types
    const char *t = types.c_str();
    
    printf("%c \n", (char)lump->type);
    
    if (types.length() <= 0) goto type_check_ok;
    
    if (t[0] == '!')
    {
      for (unsigned i = 1; i < types.length(); i++)
        if (t[i] == 'a' || lump->type == t[i]) return false;
    }
    else
    {
      for (unsigned i = 0; i < types.length(); i++)
        if (t[i] == 'a' || lump->type == t[i]) goto type_check_ok;
      return false;
    }
    
type_check_ok:;
    // check filter types
    
    if (filters.size() <= 0)  return true;
    
    for (unsigned i = 0; i < filters.size(); i++) // check each filter
    {
      const char * filter = filters[i].c_str();
      unsigned filterPos = 0;
      if (filter[0] == '!') // filter lumps not matching this type
      {
        for (filterPos = 1; filter[filterPos] != '/'; filterPos++)
          if (filter[filterPos] == 'a' || lump->type == filter[filterPos]) 
            continue; // negated type matches, check next filter
      }
      else // only filter lumps matching this type
      {
        for (filterPos = 0; filter[filterPos] != '/'; filterPos++)
          if (filter[filterPos] == 'a' || lump->type == filter[filterPos]) goto check_filter;
        continue; // filter doesn't apply to this type, check next filter
      }

check_filter:;
      
      // std::cout << "checking filter...\n";
      // std::cout << "filter " << i+1 << " :  " << filter << "\n";
      
      filter = filters[i].c_str() + filters[i].find('/') + 1;
      
      if (filter[0] == '!')
      {
        filter++;
        bool isMatch =  Regex::match(filter, lump->getName(!upper).c_str());
        if  ( isMatch ) return false;
      }
      else
      {
        bool isMatch =  Regex::match(filter, lump->getName(!upper).c_str());
        if  ( ! isMatch ) return false;
      }
      
    } // end of filter loop
    
    printf("=== exporting === \n");
    return  true;
  };
  
  
  std::string substitute(std::string substitution, std::string target)
  {
      const char *sub = substitution.c_str() + substitution.find('/') + 1;

      std::string thisSub(sub);
      std::string replacement(sub);
      thisSub = thisSub.substr(0,thisSub.find_first_of('/')); 
      replacement = replacement.substr(replacement.find_first_of('/')+1, replacement.length()); 

      return Regex::replace(thisSub, target, replacement);
    
  };
  
  std::string getLumpSaveName(Lump *lump)
  {
    std::string result = lump->getName(!upper);
    
    if (substitutions.size() <= 0)  return result;
    
    for (unsigned i = 0; i < substitutions.size(); i++) // check each substitution
    {
      const char * sub = substitutions[i].c_str();
      unsigned p = 0;
      if (sub[0] == '!') // substitutes lumps not matching this type
      {
        for (p = 1; sub[p] != '/'; p++)
          if (sub[p] == 'a' || lump->type == sub[p]) 
            continue; // negated type matches, check next substitution
      }
      else // only substitute lumps matching this type
      {
        for (p = 0; sub[p] != '/'; p++)
          if (sub[p] == 'a' || lump->type == sub[p])
          {            
            std::string newString = substitute(substitutions[i], result);
            if  (result != newString) printf("Renamed to %s \n", newString.c_str() );
            result = newString;
          }
        continue; // substitution doesn't apply to this type, check next substitution
      }
      
      std::string newString = substitute(substitutions[i], result);
      if  (result != newString) printf("Renamed to %s \n", newString.c_str() );
      result = newString;

    } // end of substitution loop
    
    return result;
  };
  
};


/****************************
          FormatGuesser
*****************************/

class FormatGuesser 
{
public:
  
  static std::string getDataFormat( const void * buffer, size_t length)
  {  
    std::string result = "";
    magic_t magicCookie = magic_open(MAGIC_NO_CHECK_TOKENS);  // MAGIC_NONE, MAGIC_MIME, MAGIC_NO_CHECK_TOKENS
    // magic_compile( magicCookie, "magic" );
    magic_load( magicCookie,  "magic/magic" );
    result = std::string(magic_buffer( magicCookie, buffer, length ));
    magic_close(magicCookie);
    return result;
  }
  static std::string getDataFormat( Lump *lump)
  {  
    return getDataFormat( (const void *)&lump->data.front(), lump->data.size()  );
  }
  
  static std::string getExtension( const void * buffer, size_t length)
  {  
    std::string mimeType = "";
    std::string extension = ".lump";
    magic_t magicCookie = magic_open(MAGIC_NO_CHECK_TOKENS + MAGIC_MIME);
    magic_load( magicCookie,  "magic/magic" );
    
    //magic_compile( magicCookie,  "magic/magic" );
    
    mimeType = std::string("") + (char *)magic_buffer( magicCookie, buffer, length );
    
    // printf("mime type: %s \n",mimeType);
    
    unsigned len = mimeType.length();
    magic_close(magicCookie);
    
    if (!mimeType.find("text")) extension = ".txt";
    else if (mimeType.find("x-") != std::string::npos)
      extension = "." + mimeType.substr ( mimeType.find_last_of("x-")+1, len ) ;
    else if (!mimeType.find('/') != std::string::npos)
      extension = "." + mimeType.substr ( mimeType.find_last_of('/')+1, len ) ;
    
    if (extension == ".octet-stream") extension = ".lump";
    
    // printf("extension: %s \n",extension);
    return extension;
  }
  static std::string getExtension( Lump *lump)
  {  
    return getExtension( (const void *)&lump->data.front(), lump->data.size()  );
  }
};



/****************************
          FlatToPng
*****************************/

class FlatToPng 
{
public:
  static bool write ( Lump *lump, unsigned char *palette, std::string pngpath )
  {
    int side = (int)sqrt(lump->info.size);
    png::image< png::rgb_pixel > image(side, side);
    
    unsigned char *bytes = (unsigned char *)&lump->data.front();
    
    for (int y = 0; y<side; y++) for (int x = 0; x<side; x++)
    {
        unsigned char *data = &bytes[x + y*side];
        unsigned char *r = &palette[*data*3+0];
        unsigned char *g = &palette[*data*3+1];
        unsigned char *b = &palette[*data*3+2];
        image.set_pixel(x,y,png::rgb_pixel((int)*r,(int)*g,(int)*b));
    }
    
    image.write(pngpath);
    return true;
  }
};


/****************************
          PatchToPng
*****************************/

class PatchToPng 
{
public:
  

  // CRC stuff for PNG.
  // This can probably be done by zlib?

  /* Table of CRCs of all 8-bit messages. */
  static unsigned long crc_table[256];

  /* Flag: has the table been computed? Initially false. */
  static int crc_table_computed; // = 0;

  /* Make the table for a fast CRC. */
  static void make_crc_table(void)
  {
    unsigned long c;
    int n, k;

    for (n = 0; n < 256; n++)
    {
      c = (unsigned long) n;

      for (k = 0; k < 8; k++)
      {
        if (c & 1)
          c = 0xedb88320L ^ (c >> 1);
        else
          c = c >> 1;
      }

      crc_table[n] = c;
    }

    crc_table_computed = 1;
  }
  /* Update a running CRC with the bytes buf[0..len-1]--the CRC
  should be initialized to all 1's, and the transmitted value
  is the 1's complement of the final running CRC (see the
  crc() routine below)). */
  static unsigned long update_crc(unsigned long crc, unsigned char *buf, int len)
  {
    unsigned long c = crc;
    int n;

    if (!crc_table_computed)
      make_crc_table();

    for (n = 0; n < len; n++)
      c = crc_table[(c ^ buf[n]) & 0xff] ^ (c >> 8);

    return c;
  }

  /* Return the CRC of the bytes buf[0..len-1]. */
  static unsigned long crc(unsigned char *buf, int len)
  {
    return update_crc(0xffffffffL, buf, len) ^ 0xffffffffL;
  }

  // swap bytes for big endian format

  static inline unsigned long byteSwapULong(unsigned long nLongNumber)
  {
     return (((nLongNumber&0x000000FF)<<24)+((nLongNumber&0x0000FF00)<<8)+
     ((nLongNumber&0x00FF0000)>>8)+((nLongNumber&0xFF000000)>>24));
  }
  
  static inline unsigned long byteSwapLong(long value)
  {
    return (long)byteSwapULong((unsigned long)value) ;
  }

  // write a png file given a lump and palette data

  static bool write ( Lump *lump, unsigned char *palette, std::string pngpath)
  {
		// Get header & offsets
		Patch::PatchHead *header = (Patch::PatchHead *)&lump->data.front();
		long *col_offsets= (long *)((char *)&lump->data.front() + sizeof(Patch::PatchHead));

    png::image< png::rgba_pixel > image(header->width, header->height);

		for (int c = 0; c < header->width; c++)
		{
			// Go to start of column
			unsigned char *data = (unsigned char *)&lump->data.front();
			data += col_offsets[c];
			// Read posts
			while (1)
			{
				// Get row offset
				unsigned char row = *data;

				if (row == 255) // End of column?
					break;

				// Get length of column
				data++;
				unsigned char length = *data;

				data++; // Skip buffer
				for (unsigned char  p = 0; p < length; p++)
				{
					data++;
          //image.set_pixel(c,row+p,png::rgb_pixel(*data,*data,*data));
          unsigned char *r = &palette[*data*3+0];
          unsigned char *g = &palette[*data*3+1];
          unsigned char *b = &palette[*data*3+2];
          
          image.set_pixel(c,row+p,png::rgba_pixel((int)*r,(int)*g,(int)*b,255));
				}
				data += 2; // Skip buffer & go to next row offset
			}
		}

    // std::string pngpath = lump->getName()+".png";
    
    image.write(pngpath);

    // rewrite the file with offsets
    
    std::ifstream infile(pngpath.c_str(),std::ios::binary|std::ios::in);
    
    infile.seekg (0, std::ios::end);
    int size = infile.tellg();
    
    char buffer[size];
    
    //char* data = new char[size];
    //char *data = (char *)&buffer;
    
    infile.seekg (0, std::ios::beg);
    infile.read((char *)&buffer,size);
    infile.close();

    std::ofstream outfile(pngpath.c_str(),std::ios::binary|std::ios::out);

		// Write PNG header and IHDR chunk
		outfile.write((char *)&buffer, 33);
    
		struct grabChunk
		{
			char name[4];
			long xoff;
			long yoff;
		};

		char chunkSize[4] = { 0, 0, 0, 8 }; // size of chunk
		//unsigned long chunkSize = byteSwapULong(8);

		grabChunk chunk = { 
      {'g', 'r', 'A', 'b'}, 
      PatchToPng::byteSwapLong((long)header->left), 
      byteSwapLong((long)header->top) 
    };
		unsigned long crcData = byteSwapULong(crc((unsigned char*)&chunk, 12));

		// Write grAb chunk
		outfile.write((char *)&chunkSize, 4);
		outfile.write((char *)&chunk, 12);
		outfile.write((char *)&crcData, 4);

		// Write the rest of the file
		outfile.write((char *)&buffer + 33, size - 33);

		outfile.close();

		return true;
	}
  
};

int PatchToPng::crc_table_computed = 0;
unsigned long PatchToPng::crc_table[256];



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
  
  static bool writeAu(Lump *lump, std::string filename)
  {
    
    char *data = (char *)&lump->data.front();
    DoomSoundHead *head =  (DoomSoundHead *)data;
    unsigned long headSize = sizeof(DoomSoundHead);
    unsigned long dataSize = lump->info.size - headSize;
    
    AuSoundHead ah;
    ah.size = dataSize;
    ah.rate = PatchToPng::byteSwapULong (head->samplerate);
    
    std::string outfn = filename + ".au";
    std::ofstream outfile(outfn.c_str(),std::ios::binary|std::ios::out);

    // write header
		outfile.write((char *)&ah, sizeof(AuSoundHead));
    
    // write sound data
    //outfile.write(sample, dataSize);
		for (unsigned i = 0; i < dataSize; i++)
    {
      char *sample = (data + headSize + i);
      char c = (char)*sample;
      c += 128;
      outfile.write((char *)&c, 1);
    }
    outfile.close();
    
    lump->fileExtension = ".au";
    return true;
  };
  
  static bool writeWav(Lump *lump, std::string filename)
  {
    
    char *data = (char *)&lump->data.front();
    DoomSoundHead *head =  (DoomSoundHead *)data;
    unsigned long headSize = sizeof(DoomSoundHead);
    unsigned long dataSize = lump->info.size - headSize;
    
    WavSoundHead wh;
    wh.length =  dataSize;
    wh.size = dataSize + 36;
    wh.rate = wh.bytesPerSecond = head->samplerate;
    
    std::string outfn = filename + ".wav";
    std::ofstream outfile(outfn.c_str(),std::ios::binary|std::ios::out);

    // write header
		outfile.write((char *)&wh, sizeof(WavSoundHead));
    
    // write sound data
    outfile.write(data + headSize, dataSize);
    outfile.close();
    
    lump->fileExtension = ".wav";
    return true;
  };
  
public:
  
  enum SoundFormat
  {
    AU = 0, WAV
  };

  static bool write(Lump *lump, std::string filename, SoundFormat format)
  {
    if (format == AU)
      return writeAu(lump, filename);
    else if (format ==WAV)
      return writeWav(lump, filename);
    return false;
  };
    
};

/****************************
    DOOM MUSIC TO MIDI
*****************************/

#include "qmus2mid.h"

class DoomMusToMidi 
{
public:
  
  static bool write(Lump *lump, std::string filename)
  {
    std::string outfn = filename + ".mid";
    lump->write(filename);
    // int qmus2mid(const char *mus, const char *mid, int nodisplay, WORD division, int BufferSize, int nocomp);
    bool result =  qmus2mid(filename.c_str(), outfn.c_str(), 1, 0, 128, 0);
    remove( filename.c_str() );
    lump->fileExtension = ".mid";
    return result;
  }  
    
};


/****************************
                WAD
*****************************/

class Wad 
{
  
private:
  
  std::map<std::string, Lump::LumpType> lumpTypesByName;

  void setLumpTypeFromName(Lump *lump)
  {
    std::string lumpName = lump->getName();
    if (lumpTypesByName.count(lumpName) > 0)
    {
      lump->type = lumpTypesByName[lumpName];
    }
  }
  
  void preparePath(std::string pathOrFile)
  {
    std::string path("");
    unsigned lastSlash =  pathOrFile.find_last_of('/');
    if (lastSlash != std::string::npos)
      path = pathOrFile.substr(0, lastSlash);
    if (path.length() > 0) Filesystem::create_directories(path);
  }
  
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
  
  Wad() // default constructor
  {
  };
  
  // put a file into a pk3
  void packFile(std::string path, std::string pk3path, unsigned strip=0, bool overwrite = false)
  {
    Zip::packFile(path, pk3path, strip, overwrite);
  }
  
  
  void loadFile(std::string path, Options *options )
 {
   
    std::string outpath = (options->outPath.length() > 0 ? options->outPath + "/" : path + ".files/");
    std::string pk3path = (options->outPath.length() > 0 ? options->outPath + ".pk3" : path + ".pk3");
    std::vector<std::string> filesToPack;
   
    printf("Saving files in %s \n", outpath.c_str());
    
    // open wad file
    std::fstream wadfile(path.c_str(),std::ios::binary|std::ios::in);
    // read wad header
    wadfile.read(reinterpret_cast<char *>(&head),sizeof(WadHead)); 
   
    // read lumps directory
    wadfile.seekg (head.directoryOffset, std::ios::beg);
    unsigned i;
    for(i=0; i<head.lumpCount; i++)
    {
      Lump l;
      wadfile.read(reinterpret_cast<char *>(&l.info),sizeof(Lump::DirectoryEntry)); 
      lumps.push_back(l);
    }
   
    printf("Finished reading %i lumps. \n", i);
    // read lump data and guess type
    std::string lastMarkerName = "";
    Lump::LumpType inMarkers = Lump::UNKNOWN;
    
    bool lastLumpMap = false;
    std::fstream mapFile;  //std::ios::binary|std::ios::out
    std::vector<Lump::DirectoryEntry> mapLumpDir;  //std::ios::binary|std::ios::out
    unsigned long mapOffset = 0;
    
    // Filesystem::create_directories(outpath);
    
    std::string outfile("");
    std::string lastoutfile("");
    
    for(unsigned i=0; i<head.lumpCount; i++)
    {
      
      // read lump data
      if (lumps[i].info.size > 0)
      {
        wadfile.seekg (lumps[i].info.offset, std::ios::beg);
        lumps[i].data.resize(lumps[i].info.size);
        wadfile.read(reinterpret_cast<char *>(&lumps[i].data.front()),lumps[i].info.size);
      }
      
      // if lump is between markers assume its type
      lumps[i].type = inMarkers;
      
      // have lump guess its type
      if (lumps[i].type == Lump::UNKNOWN
          || lumps[i].type == Lump::SPRITE
          || lumps[i].type == Lump::PATCH
          || lumps[i].type == Lump::FLAT) lumps[i].guessType();
      
      // handle map data
      
      if (lumps[i].type == Lump::MAP) 
      {
        lumps[i].format = Lump::BINARY;
        lumps[i].formatDescription = "Doom map data";
        
        if (options->shouldSaveLump(&lumps[i])) 
        {
          // outfile = outpath + "maps/"; // + lastMarkerName + "/" + options->getLumpSaveName(&lumps[i]);
          outfile = "";
          preparePath(outpath + "maps/");
          
          if (!lastLumpMap)
          {
            mapOffset = sizeof(WadHead);
            mapFile.open((outpath + "maps/" + lastMarkerName + ".wad").c_str(), std::ios::binary|std::ios::out);
            WadHead h;
            mapFile.write((char *)&h, sizeof(WadHead));
            
            Lump::DirectoryEntry d;
            d.offset = mapOffset;
            d.size = 0;
            strncpy((char *)&d.name, lumps[i-1].getName().c_str(), 8);
            mapLumpDir.push_back(d);
          }
          Lump::DirectoryEntry d;
          d.offset = mapOffset;
          d.size = lumps[i].data.size();
          mapOffset += d.size;
          strncpy((char *)&d.name, lumps[i].getName().c_str(), 8);
          mapLumpDir.push_back(d);
          mapFile.write((char *)&lumps[i].data.front(), lumps[i].data.size());
          
          lastLumpMap = true;
        }
        goto done;
      }
      else
      {        
        
        if (lastLumpMap)
        {
          int pos = mapFile.tellp();
          mapFile.write((char *)&mapLumpDir.front(), mapLumpDir.size()*sizeof(Lump::DirectoryEntry));
          mapFile.seekp(4, std::ios::beg);
          long lumpCount = mapLumpDir.size();
          mapFile.write((char *)(long)&lumpCount, sizeof(long));
          mapFile.write((char *)(long)&pos, sizeof(long));
          mapFile.close();
          mapLumpDir.clear();
          if(options->pk3)
          {
            // packFile(outpath + "maps/" + lastMarkerName + ".wad", pk3path, outpath.length());
            filesToPack.push_back(outpath + "maps/" + lastMarkerName + ".wad");
          }
        }
        
        lastLumpMap = false;
      }
      
      // handle marker lumps
      if (lumps[i].info.size == 0) 
      {
        lumps[i].type = Lump::MARKER;
        lumps[i].formatDescription = "Marker";
        lastMarkerName = lumps[i].getName();
        if (lastMarkerName == "S_START"|| lastMarkerName == "SS_START") 
          inMarkers = Lump::SPRITE;
        else if (lastMarkerName == "S_END" || lastMarkerName == "SS_END") 
          inMarkers = Lump::UNKNOWN;
        else if (lastMarkerName == "P_START"|| lastMarkerName == "PP_START") 
          inMarkers = Lump::PATCH;
        else if (lastMarkerName == "P_END"|| lastMarkerName == "PP_END") 
          inMarkers = Lump::UNKNOWN;
        else if (lastMarkerName == "A_START") inMarkers = Lump::ACS;
        else if (lastMarkerName == "A_END") inMarkers = Lump::UNKNOWN;
        else if (lastMarkerName == "F_START" || lastMarkerName == "FF_START")
          inMarkers = Lump::FLAT;
        else if (lastMarkerName == "F_END" || lastMarkerName == "FF_END") 
          inMarkers = Lump::UNKNOWN;
        else if (lastMarkerName == "C_START") inMarkers = Lump::COLORMAP;
        else if (lastMarkerName == "C_END") inMarkers = Lump::UNKNOWN;
        lastMarkerName = options->getLumpSaveName(&lumps[i]);  // lowercase map name
        outfile = "";
        goto done;
      }
      
      lumps[i].fileExtension = FormatGuesser::getExtension( &lumps[i]  );
      
      // handle acs data
      if (lumps[i].type == Lump::ACS && options->shouldSaveLump(&lumps[i])) 
      {
        if (lumps[i].fileExtension == ".lump") lumps[i].fileExtension == ".o";
        outfile = outpath + "acs/"  + options->getLumpSaveName(&lumps[i]) + lumps[i].fileExtension;
        preparePath(outfile);
        lumps[i].write(outfile);
        if(options->pk3)
        {
          // packFile(outfile, pk3path, outpath.length());
          filesToPack.push_back(outfile);
        }
        goto done;
      }
      
      // use libmagic to determine data format
      if (lumps[i].format == Lump::GENERIC)
      {
        // magically guess file type
        lumps[i].formatDescription = FormatGuesser::getDataFormat( &lumps[i]  );
        
        if (lumps[i].formatDescription.find("image") != std::string::npos)
        {
          lumps[i].type = (lumps[i].type ? lumps[i].type : Lump::GFX);
          lumps[i].format = Lump::BINARY;
        }
        else if (lumps[i].formatDescription.find("audio") != std::string::npos
            || lumps[i].formatDescription.find("sound") != std::string::npos
            || lumps[i].formatDescription.find("MP3") != std::string::npos
            || lumps[i].formatDescription.find("MPEG") != std::string::npos)
        {
          lumps[i].type = (lumps[i].type != Lump::UNKNOWN ? lumps[i].type : Lump::SOUND);
          lumps[i].format = Lump::BINARY;
        }
        if (lumps[i].formatDescription.find("module") != std::string::npos
            || lumps[i].formatDescription.find("MIDI") != std::string::npos)
        {
          lumps[i].type = (lumps[i].type != Lump::UNKNOWN ? lumps[i].type : Lump::MUSIC);
          lumps[i].format = Lump::BINARY;
        }
        else if (lumps[i].formatDescription.find("DBase 3 data file") != std::string::npos)
        {
          lumps[i].type = (lumps[i].type != Lump::UNKNOWN ? lumps[i].type : Lump::SOUND);
          lumps[i].format = Lump::DOOMSND;
          lumps[i].formatDescription =  "Doom SND sound lump";
        }
      }
      
      if (options->shouldSaveLump(&lumps[i]) == false) goto done;
      
      if (lumps[i].type == Lump::SPRITE)
      {
        if (lumps[i].format == Lump::DOOMPIC) 
        {
          outfile = outpath + "sprites/" + options->getLumpSaveName(&lumps[i]) + ".png";
          preparePath(outfile); PatchToPng::write(&lumps[i], options->palData, outfile);
        }
        else
        {
          outfile = outpath + "sprites/" + options->getLumpSaveName(&lumps[i]) + lumps[i].fileExtension;
          preparePath(outfile); lumps[i].write(outfile);
        }
        goto done;
      }
      if (lumps[i].type == Lump::PATCH)
      {
        if (lumps[i].format == Lump::DOOMPIC) 
        {
          outfile = outpath + "patches/" + options->getLumpSaveName(&lumps[i]) + ".png";
          preparePath(outfile); PatchToPng::write(&lumps[i], options->palData, outfile);
        }
        else
        {
          outfile = outpath + "patches/" + options->getLumpSaveName(&lumps[i]) + lumps[i].fileExtension;
          preparePath(outfile); lumps[i].write(outfile);
        }
        goto done;
      }
      if (lumps[i].type == Lump::GFX)
      {
        if (lumps[i].format == Lump::DOOMPIC) 
        {
          outfile = outpath + "graphics/" + options->getLumpSaveName(&lumps[i]) + ".png";
          preparePath(outfile); PatchToPng::write(&lumps[i], options->palData, outfile);
        }
        else
        {
          outfile = outpath + "graphics/" + options->getLumpSaveName(&lumps[i]) + lumps[i].fileExtension;
          preparePath(outfile); lumps[i].write(outfile);
        }
        goto done;
      }
      if (lumps[i].type == Lump::FLAT)
      {
        if (lumps[i].format == Lump::DOOMFLAT) 
        {
          outfile = outpath + "flats/" + options->getLumpSaveName(&lumps[i]) + ".png";
          preparePath(outfile); FlatToPng::write(&lumps[i], options->palData, outfile);
        }
        else
        {
          outfile = outpath + "flats/" + options->getLumpSaveName(&lumps[i]) + lumps[i].fileExtension;
          preparePath(outfile); lumps[i].write(outfile);
        }
        goto done;
      }
      if (lumps[i].format == Lump::DOOMPIC)  // export misc gfx
      {
          outfile = outpath + "graphics/" + options->getLumpSaveName(&lumps[i]) + ".png";
          preparePath(outfile); PatchToPng::write(&lumps[i], options->palData, outfile);
          goto done;
      }
      if (lumps[i].type == Lump::SOUND)
      {
        if (lumps[i].format == Lump::DOOMSND) 
        {
          outfile = outpath + "sounds/" + options->getLumpSaveName(&lumps[i]); // + ".au";
          preparePath(outfile); DoomSndExport::write(&lumps[i], outfile,DoomSndExport::WAV);
          outfile+=lumps[i].fileExtension;
        }
        else
        {
          outfile = outpath + "sounds/" + options->getLumpSaveName(&lumps[i]) + lumps[i].fileExtension;
          preparePath(outfile); lumps[i].write(outfile);
        }
        goto done;
      }
      if (lumps[i].type == Lump::MUSIC)
      {
        if (lumps[i].format == Lump::DOOMMUS) 
        {
          outfile = outpath + "music/" + options->getLumpSaveName(&lumps[i]) ; //+ ".mid";
          preparePath(outfile); DoomMusToMidi::write(&lumps[i], outfile);
          outfile+=lumps[i].fileExtension;
        }
        else
        {
          outfile = outpath + "music/" + options->getLumpSaveName(&lumps[i]) + lumps[i].fileExtension;
          preparePath(outfile); lumps[i].write(outfile);
        }
        goto done;
      }

      outfile = outpath + options->getLumpSaveName(&lumps[i]) + lumps[i].fileExtension;
      preparePath(outfile); 
      if (options->append && lumps[i].fileExtension == ".txt" && Filesystem::exists(outfile) )
        lumps[i].append(outfile);
      else lumps[i].write(outfile);

      done:;  //  done with this lump. Free resources, print stuff and process the next lump.
      
      if(options->pk3 && outfile != "" && outfile != lastoutfile)
      {
        // packFile(outfile, pk3path, outpath.length());
        filesToPack.push_back(outfile);
      }
      lastoutfile = outfile;
      
      
      // get palette data if needed
      if (options->internalPalette && lumps[i].getName() == "PLAYPAL")
        memcpy((char *)(options->palData), &lumps[i].data.front(), 256*3);

      
      printf("%s ",lumps[i].getName().c_str());
      if (lumps[i].type != Lump::NAMED)
        printf("(%s) \n",Lump::typeNames[lumps[i].type].c_str());
      else
        printf("(%s) \n",Lump::namedLumps[lumps[i].getName()].c_str());
      float kbsize = lumps[i].info.size/1024.0;
      unsigned digits = 1;
      for(unsigned d=1; d<=(unsigned)kbsize; d*=10) digits++;
      printf("%s; size: %fKB \n\n",lumps[i].formatDescription.c_str(), kbsize);
      
      lumps[i].data.clear();
      
    } // end of lump loop
   
    wadfile.close();
    
    if(options->pk3)
    {
      printf("\nAdding files to %s: \n", pk3path.c_str());
      for(unsigned i = 0; i < filesToPack.size(); i++) printf("to pack: %s \n", filesToPack[i].c_str());
      printf("\nCreating pk3... \n");
      Zip::packFiles(filesToPack, pk3path, outpath.length());
    }
    
    printf("Wad type: %s; lumps:%i; dir offset:%i \n\n",head.getMagic().c_str(),
        (int)head.lumpCount, (int)head.directoryOffset);

 };
  
 
};


/****************************
                MAIN
*****************************/

void showHelp()
{
  #include "readme.txt.h"
  printf("\n%s\n", readme_txt);
}

int main(int argc,char **argv) 
{
  
  Options options;
  try
  {
      // Read command line parameters
      std::vector<std::string> files;
      for (int i=1; i<argc; i++) 
      {
        if (std::string("-?") == argv[i])
        {
          showHelp();
          return 0;
        }
        else if (std::string("-l") == argv[i])  // only list lumps, don't extract
          options.list = true;
        else if (std::string("-u") == argv[i])  // upper-case lump names
          options.upper = true;
        else if (std::string("-a") == argv[i])  // append text files
          options.append = true;
        else if (std::string("-o") == argv[i-1])  // types
          options.outPath = argv[i];
        else if (std::string("-z") == argv[i])  // append text files
          options.pk3 = true;
        else if (std::string("-p") == argv[i-1])  // palette file
        {
          if (Filesystem::exists(argv[i])) options.palFile = argv[i];
          else std::cerr<<"Palette file does not exist, ignoring: "<<argv[i]<<"\n"; 
        }
        else if (std::string("-t") == argv[i-1])  // types
          options.types = argv[i];
        else if (std::string("-f") == argv[i-1])  // regex filter
        {
          std::string s(argv[i]);
          if (s.find_first_of('/') != std::string::npos) options.filters.push_back(s);
          else std::cerr<<"Bad filter string, ignoring: "<<argv[i]<<"\n"; 
        }
        else if (std::string("-r") == argv[i-1])  // regex rename
        {
          std::string s(argv[i]);
          if (s.find_first_of('/') != std::string::npos 
              && s.find_last_of('/') != std::string::npos 
              && s.find_first_of('/') != s.find_last_of("/"))
            options.substitutions.push_back(s);
          else std::cerr<<"Bad substitution string, ignoring: "<<argv[i]<<"\n"; 
        }
        else if (std::string("-g") == argv[i-1])  // sprite grouping
          options.groupSprites = atoi(argv[i]);
        else if (argv[i][0]!='-') // wad file to extract
        {
          if (Filesystem::exists(argv[i])) files.push_back(argv[i]);
          else std::cerr<<"Input file does not exist, ignoring: "<<argv[i]<<"\n"; 
        }
      }
      
      if (options.groupSprites > 0)
      {
        std::stringstream ss("");
        ss << "s/((.{" << options.groupSprites << "}).*)/\\2/\\1";
        options.substitutions.push_back(ss.str());
      }
      
      
      if (options.palFile.length() > 0)
      {
        printf("palette file: %s \n",options.palFile.c_str());
        // read palette file
        std::fstream cmfile(options.palFile.c_str(), std::ios::binary|std::ios::in);
        cmfile.seekg (0, std::ios::beg);
        cmfile.read((char *)(&(options.palData)),256*3);
        cmfile.close();
      }
      else options.internalPalette = true;
      
      int numFiles = files.size();
      printf("\n"); 
    
      if (numFiles<1) 
      { 
        std::cerr << "You must specify at least one input wad.\n"; 
        return EXIT_FAILURE;
      }
      
      for (int i = 0; i < numFiles; i++)
      {
        printf("Processing %s. \n", files[i].c_str()); 
        Wad wad;
        wad.loadFile(files[i].c_str(), &options);
        printf("\n"); 
      }
      
      // all done.
      printf("%s done. \n", argv[0]); 
    
      return 0;
  }
  catch (std::exception const& error)
  {
      std::cerr << argv[0] << ": oh shit: " << error.what() << std::endl;
      return EXIT_FAILURE;
  }
}
