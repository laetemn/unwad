const char *readme_txt = "\
Usage:\n\
\n\
unwad [options] <wad> [<wad2> ...]\n\
\n\
  -?              Print this help information and exit. All other options\n\
                  will be ignored.\n\
\n\
  -l              Just list lump information, don't extract anything.\n\
\n\
  -z              Create pk3(s) from extracted files.\n\
\n\
  -p <P>          Path to raw palette file P (extracted playpal lump or\n\
                  raw palette data). Default behavior is look for an\n\
                  internal palette lump; failing that, use a gray scale\n\
                  palette.\n\
\n\
  -o <P>          Output files to path P. By default, files are saved to\n\
                  a path determined by the name of the wad being\n\
                  extracted. This can be used to merge several wads into\n\
                  a single output file or directory.\n\
\n\
  -a              Append text files rather than overwriting them. Useful\n\
                  when merging wads with -o.\n\
\n\
  -u              Use upper-case lump names. Lump names are changed to\n\
                  lower-case by default.\n\
\n\
  -t <T>          Only process lumps of type T. T can be a combination of\n\
                  the following characters:\n\
\n\
                    a - all lump types (default)\n\
                    g - gfx\n\
                    f - flat\n\
                    p - patch\n\
                    t - texture\n\
                    s - sprite\n\
                    n - sound (noise)\n\
                    m - music\n\
                    l - map (level)\n\
                    o - acs not attached to a map (object code)\n\
                    u - unknown lump types\n\
                    k - miscellaneous (known) lump types that don't\n\
                        fit in any other category\n\
\n\
  -f <T>/<X>      Filter lumps using a regular expression. Only lumps\n\
                  matching regex X will be processed. Alternatively, you\n\
                  may use the character ! at the beginning of the regex\n\
                  to ignore lumps matching the regex. This will only\n\
                  affect lumps of type T.\n\
\n\
  -r <T>/<X>/<R>  Rename extracted lumps using a regular expression.\n\
                  Lumps matching regex X will be renamed according to\n\
                  replacement string R. The replacement string may\n\
                  contain the escape sequences \\1 through \\9 which refer\n\
                  to the corresponding matching sub-expressions in regex\n\
                  X. This will only affect lumps of type T.\n\
\n\
  -g <N>          Group sprites by first N characters of sprite name.\n\
                  -g N is interpreted as a replacement in the form of\n\
                  s/((.{N}).*)/\\2/\\1 where N is a one-digit integer.\n\
\n\
  -w              Convert sounds to WAV format instead of FLAC.\n\
                  (not implemented)\n\
\n\
Operations that deal with lump names occur in the same order as the\n\
options are listed. For example:\n\
\n\
  * If you don't use the -u option (uppercase), any regex should look for\n\
    lower-case lump names.\n\
\n\
  * If you use both -f and -r, -f should look for lump names as they\n\
    would appear before being renamed by -r.\n\
\n\
  * If you use both -r and -g, -g will look at the first x characters of\n\
    the renamed lump name rather than the original lump name.\n\
\n\
About filters:\n\
\n\
More than one filter can be used. Filters having different T values will\n\
not interfere with each other. Filters having the same T value must all\n\
match the lump name in order for a lump of that type to be exported.\n\
\n\
In other words, doing something like -t s -f s/bspi -f s/spos won't\n\
export anything. Instead, use a single regex with a '|' operator. The '|'\n\
character will probably need to be escaped with a '\\' character so the\n\
command line doesn't eat it.\n\
\n\
About renaming files:\n\
\n\
More than one renaming paramater may be used. All relevant matches will\n\
be applied. The / character may be used as a path seperator in the\n\
replacement string. Characters like '(', ')', and '\\' (and probably more)\n\
should all be escaped so the command line doesn't eat them.\n\
\n\
Example usage:\n\
\n\
  # extract all lumps from mypwad.wad, using palette file \"playpal.lump\"\n\
  unwad -p playpal.lump mypwad.wad\n\
\n\
  # extract all archvile sprites and noises from DOOM2.WAD\n\
  unwad -t sn -f n/dsvi -f s/vile DOOM2.WAD\n\
\n\
  # export all rock and slime flats from DOOM2.WAD\n\
  # (notice you must escape the pipe character so the command line\n\
  # doesn't eat it!)\n\
  unwad -t f -f f/rock\\|slime DOOM2.WAD\n\
\n\
  # extract all sprites and noises from HERETIC.WAD, renaming sprites\n\
  # beginning with \"head\" to begin with \"lich.\" Notice the use of\n\
  # escape characters before '(', ')', and '\\'.\n\
  unwad -t sn -r s/^head\\(.*\\)/lich\\\\1 HERETIC.WAD\n\
\n\
  # extract all lumps from DOOM2.WAD, leaving lump names in upper-case,\n\
  # ignoring unknown lumps beginning with \"DP\" (pc speaker sounds)\n\
  unwad -u -f u/!^DP DOOM2.WAD\n\
";

