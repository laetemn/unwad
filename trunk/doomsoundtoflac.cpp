
/****************************
      DOOM SOUND TO FLAC
*****************************/

#include "FLAC++/metadata.h"
#include "FLAC++/encoder.h"

struct DoomSoundHead
{
	unsigned short three;
	unsigned short samplerate;
	unsigned short samples;
	unsigned short zero;
};

class MyFlacEncoder: public FLAC::Encoder::File {
public:
	MyFlacEncoder(): FLAC::Encoder::File() { }
};

class DoomSoundToFLAC
{
public:

  static bool write(Lump *lump, std::string filename)
  {
    
    char *data = (char *)&lump->data.front();
    DoomSoundHead *head =  (DoomSoundHead *)data;
    
    unsigned total_samples = (unsigned)head->samples;
    FLAC__int32 pcm[total_samples];
    
    bool ok = true;
    MyFlacEncoder encoder;
    FLAC__StreamEncoderInitStatus init_status;
    FLAC__StreamMetadata *metadata[2];
    FLAC__StreamMetadata_VorbisComment_Entry entry;
    
    unsigned sample_rate = (unsigned)head->samplerate;
    
    // std::cout<<"sample_rate: "<<sample_rate<<"\n";
    // std::cout<<"total_samples: "<<total_samples<<"\n";
     
    // check the encoder
    if(!encoder) {
      fprintf(stderr, "ERROR: allocating encoder\n");
      return 1;
    }

    ok &= encoder.set_verify(true);
    ok &= encoder.set_compression_level(6);
    ok &= encoder.set_channels(1);
    ok &= encoder.set_bits_per_sample(8);
    ok &= encoder.set_sample_rate(sample_rate);
    ok &= encoder.set_total_samples_estimate(total_samples);

    // add some metadata
    if(ok) {
      if(
        (metadata[0] = FLAC__metadata_object_new(FLAC__METADATA_TYPE_VORBIS_COMMENT)) == NULL ||
        (metadata[1] = FLAC__metadata_object_new(FLAC__METADATA_TYPE_PADDING)) == NULL ||
        !FLAC__metadata_object_vorbiscomment_entry_from_name_value_pair(&entry, "TITLE", lump->getName().c_str()) ||
        !FLAC__metadata_object_vorbiscomment_append_comment(metadata[0], entry, false) ||
        !FLAC__metadata_object_vorbiscomment_entry_from_name_value_pair(&entry, "COMMENT", "Ripped using Unwad") ||
        !FLAC__metadata_object_vorbiscomment_append_comment(metadata[0], entry, false)
      ) {
        fprintf(stderr, "ERROR: out of memory or tag error\n");
        ok = false;
      }

      metadata[1]->length = 0; // set the padding length

      ok = encoder.set_metadata(metadata, 2);
    }

    // initialize encoder
    if(ok) {
      init_status = encoder.init(filename);
      if(init_status != FLAC__STREAM_ENCODER_INIT_STATUS_OK) {
        fprintf(stderr, "ERROR: initializing encoder: %s\n", FLAC__StreamEncoderInitStatusString[init_status]);
        ok = false;
      }
    }

    // read samples from SND data and feed to encoder
    if(ok) {
      
        // convert the packed little-endian 8-bit samples from SND into an interleaved FLAC__int32 buffer for libFLAC
        size_t i;
        for(i=0; i<total_samples; i++) {
          
          FLAC__int8 sample = (FLAC__int8)data[sizeof(DoomSoundHead)+i];
          sample+=128;
          pcm[i] = (FLAC__int32)( sample );
          
        }
        // feed samples to encoder */
        ok = encoder.process_interleaved(pcm, total_samples);
    }

    ok &= encoder.finish();

    if (!ok)
    {
      fprintf(stderr, "encoding: FAILED\n");
      fprintf(stderr, "   state: %s\n", encoder.get_state().resolved_as_cstring(encoder));
    }
    
    // now that encoding is finished, the metadata can be freed
    FLAC__metadata_object_delete(metadata[0]);
    FLAC__metadata_object_delete(metadata[1]);

    return 0;
  }


};

