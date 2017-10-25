#ifndef JDPLAY_CALLBACK_H
#define JDPLAY_CALLBACK_H

#ifdef __cplusplus
extern "C" {
#endif
    
    typedef struct sJdPlayCallbacks {
        //callback to app
        void (*onDevicesStateChange)();
        void (*onMessageArrived)(int remote, long long from, short msg_id, int type, int action, char* value);
        int (*onCreateGroup)(int state, char *group_id, char *device_id);
        const char *(*onJoinGroup)(int state, int is_master, char *group_id, char *device_id);
        int (*onLeaveGroup)(int state, int is_master, char *group_id, char *device_id);
        int (*onMMPlayEvent)(int isMaster, int playOrPause); //1: play 0: pause
        
        void (*onPublished)(int type, int action, char *payload);
        void (*onPublishFailed)(char *payload);
        
        //callback to JdPlay
        void (*onProgressChange)(int remote, long long from, short msg_id, char* value);
        void (*onPlayStateChange)(int remote, long long from, short msg_id, char* value); //"0": pause "1": play "2":stop
        
        //callback to MqttService
        void (*onMsgArrived)(void *context, long long from, short msg_id, int msg_type, int msg_action, char* value);
        void (*onConnect)(void* context);
        
        void (*onDisconnect)(void* context);
        void (*onConnLost)(void *context, char *cause);
        int (*getNetworkState)();
        
    }JdPlayCallbacks;
    
#ifdef __cplusplus
}
#endif

#endif
