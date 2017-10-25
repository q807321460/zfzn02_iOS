#ifndef JDPLAY_H
#define JDPLAY_H

#ifdef __cplusplus
extern "C" {
#endif
    
    
#include "JdPlayCallbacks.h"
    
    void JdPlay_setCallbacks(JdPlayCallbacks *callbacks);
    int JdPlay_appOnMRFound(const char *urn, const char *location, const char *uuid, const char *device_info);
    int JdPlay_appOnMRRemoved(const char *uuid);
    int JdPlay_appOnNetChange(int state);
    int JdPlay_appOnSuspend();
    int JdPlay_appOnResume();
    
    const char* JdPlay_version();
    int JdPlay_init(const char *uuid, const char *userAgent);
    int JdPlay_setParameter(const char *key, const char *value);
    void JdPlay_debug(int level);
    char* JdPlay_dmsPathToUrl(const char *path);
    int JdPlay_selectDevice(const char* deviceID);
    char* JdPlay_getDeviceStatesInfo();
    int  JdPlay_publishBasic(const char *targetId, const char* topic,  int type, int action, int dataType, int value);
    int JdPlay_publishString(const char *targetId, const char* topic,int type, int action, const char* payload, int flag);
    
    int JdPlay_multiroomJoinGroup(const char *groupID, const char *deviceID);
    int JdPlay_multiroomLeaveGroup(const char* groupID, const char* deviceID);
    int JdPlay_multiroomControl(int type, const char* uuid, const char* payload);
    int JdPlay_isPhone();
    
#ifdef __cplusplus
}
#endif

#endif

