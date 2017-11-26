//
//  pic_info.h
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#ifndef P2PONVIF_PRO_pic_info_h
#define P2PONVIF_PRO_pic_info_h

typedef struct _pic_info
{
	int timestamp;
	int sample_rate;
	int bit_rate;
	int channels;
	int stream_format;
	unsigned char *data;
	int len;
}pic_info;

#endif
