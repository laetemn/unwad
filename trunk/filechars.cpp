// simple program to convert a text file to char*

#include <vector>
#include <string>
#include <fstream>
#include <sstream>

using namespace std;

// escape control chars and wrap with quotes
string prepareLine(string instr)
{
  stringstream ss("");
  for (unsigned i = 0; i < instr.length(); i++)
  {
    if (instr[i] == '\\' || instr[i] == '"') ss << "\\" << instr[i];
    else ss << instr[i];
  }
  ss << "\\n\\\n";
  return ss.str();
}

// replace chars not suitable for a variable name
string cleanFileName(char *fn)
{
  stringstream ss("");
  for (unsigned i = 0; i < strlen(fn); i++)
  {
    if (fn[i] == '.' || fn[i] == '\\' || fn[i] == '/') ss << "_";
    else ss << fn[i];
  }
  return ss.str();
}

// write string declaration given a variable name
string header(string varname)
{
  return "const char *" + varname + " = \"\\\n";
}

string footer()
{
  return "\";\n\n";
}

// convert text file to a .h containing a char*
void convertFile(char *filename)
{    
  vector<string> text;
  ifstream file( filename );
  string s;
  text.push_back( header(cleanFileName(filename)) );
  while(getline(file, s)) text.push_back( prepareLine(s) );
  text.push_back( footer() );
  file.close();
  ofstream outfile( (string(filename) + ".h").c_str() );
  for (unsigned i = 0; i < text.size(); i++) 
    outfile.write(text[i].c_str(), text[i].length());
  outfile.close();
}

// main
int main(int argc,char **argv) 
{
  try
  {
    for (int i = 1; i < argc; i++) convertFile(argv[i]);
  }
  catch (exception const &error)
  {
      printf("%s: exception: %s \n",argv[0], error.what());
      return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
