Convert doom wads to pk3; extract lumps and convert them to common formats. 

Usage:

unwad [options] <wad> [<wad2> ...]

  -?              Print this help information and exit. All other options
                  will be ignored.

  -l              Just list lump information, don't extract anything.

  -z              Create pk3(s) from extracted files.

  -p <P>          Path to raw palette file P (extracted playpal lump or
                  raw palette data). Default behavior is look for an
                  internal palette lump; failing that, use a gray scale
                  palette.

  -o <P>          Output files to path P. By default, files are saved to
                  a path determined by the name of the wad being
                  extracted. This can be used to merge several wads into
                  a single output file or directory.

  -a              Append text files rather than overwriting them. Useful
                  when merging wads with -o.

  -u              Use upper-case lump names. Lump names are changed to
                  lower-case by default.

  -t <T>          Only process lumps of type T. T can be a combination of
                  the following characters:

                    a - all lump types (default)
                    g - gfx
                    f - flat
                    p - patch
                    t - texture
                    s - sprite
                    n - sound (noise)
                    m - music
                    l - map (level)
                    o - acs not attached to a map (object code)
                    u - unknown lump types
                    k - miscellaneous (known) lump types that don't
                        fit in any other category

  -f <T>/<X>      Filter lumps using a regular expression. Only lumps
                  matching regex X will be processed. Alternatively, you
                  may use the character ! at the beginning of the regex
                  to ignore lumps matching the regex. This will only
                  affect lumps of type T.

  -r <T>/<X>/<R>  Rename extracted lumps using a regular expression.
                  Lumps matching regex X will be renamed according to
                  replacement string R. The replacement string may
                  contain the escape sequences \1 through \9 which refer
                  to the corresponding matching sub-expressions in regex
                  X. This will only affect lumps of type T.

  -g <N>          Group sprites by first N characters of sprite name.
                  -g N is interpreted as a replacement in the form of
                  s/((.{N}).*)/\2/\1 where N is a one-digit integer.

  -i <F>          Convert images to format F. F can be one of either 
                  "png" or "raw" (without the quotes). Default image
                  format is png.
                  (planned feature, not implemented yet)
                  
  -n <F>          Convert sounds to format F. F can be one of either 
                  "wav", "au", or "raw" (without the quotes). Default 
                  sound format is wav.
                  (planned feature, not implemented yet)

  -m <F>          Convert music to format F. F can be one of either 
                  "mid" or "raw" (without the quotes). Default music
                  format is mid.
                  (planned feature, not implemented yet)

  --raw           Don't do any conversion (same as -i raw -n raw -m raw).
                  Subsequent -i, -n, or -m arguments will override --raw
                  for that lump type.
                  (planned feature, not implemented yet)

All regular expressions are case-insensitive. Operations that deal with 
lump names occur in the same order as the options are listed.

  * If you use both -f and -r, -f should look for lump names as they
    would appear before being renamed by -r.

  * If you use both -r and -g, -g will look at the first x characters of
    the renamed lump name rather than the original lump name.

About filters:

More than one filter can be used. Filters having different T values will
not interfere with each other. Filters having the same T value must all
match the lump name in order for a lump of that type to be exported.

In other words, doing something like -t s -f s/bspi -f s/spos won't
export anything. Instead, use a single regex with a '|' operator. The '|'
character will probably need to be escaped with a '\' character so the
command line doesn't eat it.

About renaming files:

More than one renaming paramater may be used. All relevant matches will
be applied. The / character may be used as a path seperator in the
replacement string. Characters like '(', ')', and '\' (and probably more)
should all be escaped.

Example usage:

  # extract all lumps from DOOM2.WAD
  unwad DOOM2.WAD

  # extract the PLAYPAL lump from DOOM2.WAD
  unwad -f a/playpal DOOM2.WAD

  # extract all lumps from mypwad.wad, using palette file "playpal.lump"
  unwad -p playpal.lump mypwad.wad

  # extract all archvile sprites and noises from DOOM2.WAD
  unwad -t sn -f n/dsvi -f s/vile DOOM2.WAD

  # export all rock and slime flats from DOOM2.WAD. Notice the escape 
  # character (back slash) before '|'.
  unwad -t f -f f/rock\|slime DOOM2.WAD

  # extract all sprites and noises from HERETIC.WAD, renaming sprites
  # beginning with "head" to begin with "lich." Notice the use of
  # escape characters before '(', ')', and '\'.
  unwad -t sn -r s/^head\(.*\)/lich\\1 HERETIC.WAD

  # extract all lumps from DOOM2.WAD, leaving lump names in upper-case,
  # ignoring unknown lumps beginning with "DP" (pc speaker sounds)
  unwad -u -f u/!^dp DOOM2.WAD
