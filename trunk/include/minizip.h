extern "C"
{
#include "minizip/zip.h"

uLong filetime(char *f, tm_zip *tmzip, uLong *dt);
int check_exist_file(const char* filename);
int getFileCrc(const char* filenameinzip,void*buf,unsigned long size_buf,unsigned long* result_crc);
int mz_main(int argc, char **argv);

}
