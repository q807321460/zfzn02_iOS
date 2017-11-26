#ifndef __LIBVVONVIF_DEF_H__
#define __LIBVVONVIF_DEF_H__


#ifndef TVIDEOPARAMS
#define TVIDEOPARAMS
typedef struct _TVideoParams
{
	int timestamp;
	int width;
	int height;
	int frame_rate;
	int stream_format;
	int frame_type;
	unsigned char *data0;
	int linesize0;
	unsigned char *data1;
	int linesize1;
	unsigned char *data2;
	int linesize2;
	int datetime;
} TVideoParams;
#endif

#ifndef TAUDIOPARAMS
#define TAUDIOPARAMS
typedef struct _TAudioParams
{
	int timestamp;
	int sample_rate;
	int bit_rate;
	int channels;
	int stream_format;
	unsigned char *data;
	int len;
}TAudioParams;
#endif

#ifndef TVVVOICEPARAMS
#define TVVVOICEPARAMS
typedef struct _TVVVoiceParams
{
	int codec;
	int samplerate;
	int bitrate;
	int channels;
	int buffsize;
    int is_fullduplex;
}TVVVoiceParams;
#endif


#endif