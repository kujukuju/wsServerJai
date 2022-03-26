### WS Server Jai

A simple port of wsServer https://github.com/Theldus/wsServer to jai.

Only works on linux.

Copy libws.so to your project root folder (unfortunately) and `#import wsServerJai;`.

NOTE: Apparently when you receive a message in onmessage it happens not on the main thread or something. Although this seems to be the opposite of what the library claims to do? It's probably better. But so you will have to handle packets while considering concurrency.

### Basic Code
```jai
jai_context: Context;

main :: () {
    events: ws_events;
    events.onopen = onopen;
    events.onclose = onclose;
    events.onmessage = onmessage;

    ws_socket(*events, 4000, 0);
}

onopen :: (fd: s32) #c_call {
    push_context jai_context {
        print("Opened connection. %\n", fd);
    }
}

onclose :: (fd: s32) #c_call {
    push_context jai_context {
        print("Closed connection. %\n", fd);
    }
}

// apparently 
onmessage :: (fd: s32, message: *u8, size: u64, type: s32) #c_call {
    push_context jai_context {
        print("Received message. %\n", fd);
        
        for i: 0..size - 1 {
            print("%", message[i]);

            if i < size - 1 {
                print(" ");
            } else {
                print("\n");
            }
        }

        // responding in a way that tests concurrency between connections
        data1 := u8.[4, 5, 6, 7];
        ws_sendframe_bin(fd, data1.data, data1.count, false);

        sleep_milliseconds(2000);

        data2 := u8.[8, 9, 10, 11];
        ws_sendframe_bin(fd, data2.data, data2.count, false);
    }
}

#scope_file

#import "Basic";
#import "wsServerJai";
```