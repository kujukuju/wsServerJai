
ws_events :: struct {
    onopen: #type (fd: s32) -> void #c_call;
    onclose: #type (fd: s32) -> void #c_call;
    onmessage: #type (fd: s32, message: *u8, size: u64, type: s32) -> void #c_call;
}

WS_FIN: s32 : 128;
WS_FIN_SHIFT: s32 : 7;
WS_FR_OP_CONT: s32 : 0;
WS_FR_OP_TXT: s32 : 1;
WS_FR_OP_BIN: s32 : 2;
WS_FR_OP_CLSE: s32 : 8;
WS_FR_OP_PING: s32 : 0x9;
WS_FR_OP_PONG: s32 : 0xA;
WS_FR_OP_UNSUPPORTED: s32 : 0xF;
WS_CLSE_NORMAL: s32 : 1000;
WS_CLSE_PROTERR: s32 : 1002;
WS_CLSE_INVUTF8: s32 : 1007;
WS_STATE_CONNECTING: s32 : 0;
WS_STATE_OPEN: s32 : 1;
WS_STATE_CLOSING: s32 : 2;
WS_STATE_CLOSED: s32 : 3;

get_handshake_accept :: (ws_key: *u8, dest: **u8) -> s32 #foreign wsserver;
// EXPORT int get_handshake_accept(char *wsKey, unsigned char **dest);
get_handshake_response :: (hsrequest: *u8, hsresponse: **u8) -> s32 #foreign wsserver;
// EXPORT int get_handshake_response(char *hsrequest, char **hsresponse);
ws_getaddress :: (fd: s32) -> *u8 #foreign wsserver;
// EXPORT char *ws_getaddress(int fd);
ws_sendframe :: (fd: s32, msg: *u8, size: u64, broadcast: bool, type: s32) -> s32 #foreign wsserver;
// EXPORT int ws_sendframe(int fd, const char *msg, uint64_t size, bool broadcast, int type);
ws_sendframe_txt :: (fd: s32, msg: *u8, broadcast: bool) -> s32 #foreign wsserver;
// EXPORT int ws_sendframe_txt(int fd, const char *msg, bool broadcast);
ws_sendframe_bin :: (fd: s32, msg: *u8, size: u64, broadcast: bool) -> s32 #foreign wsserver;
// EXPORT int ws_sendframe_bin(int fd, const char *msg, uint64_t size,bool broadcast);
ws_get_state :: (fd: s32) -> s32 #foreign wsserver;
// EXPORT int ws_get_state(int fd);
ws_close_client :: (fd: s32) -> s32 #foreign wsserver;
// EXPORT int ws_close_client(int fd);
ws_socket :: (evs: *ws_events, port: u16, thread_loop: s32) -> s32 #foreign wsserver;
// EXPORT int ws_socket(struct ws_events *evs, uint16_t port, int thread_loop);

#scope_file

wsserver :: #foreign_library "bin/libws";