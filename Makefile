CFLAGS = -g -Wall -fno-strict-aliasing -std=gnu99
LDFLAGS = -lpthread -lrt -lm -ltcmalloc
SHARED = -fPIC --shared
CC = gcc
INCLUDE = -I../KendyNet -I../KendyNet/core -I.. -I. -Igateserver -Igameserver\
		  -I../KendyNet/deps/luajit-2.0/src -I../KendyNet/deps/hiredis
DEFINE = -D_DEBUG -D_LINUX -DMQ_HEART_BEAT

gateservice.a:\
		gateserver/agentservice/agentservice.c\
		gateserver/agentservice/agentservice.h\
		gateserver/verifyservice/verifyservice.c\
		gateserver/verifyservice/verifyservice.h\
		gateserver/togame/togame.c\
		gateserver/togame/togame.h
		$(CC) $(CFLAGS) -c $^ $(INCLUDE) $(DEFINE)
		ar -rc gateservice.a *.o
		rm -f *.o
		
gameservice.a:\
		gameserver/avatar.c\
		gameserver/avatar.h\
		gameserver/superservice/superservice.c\
		gameserver/superservice/superservice.h\
		gameserver/superservice/cmdhandler.c\
		gameserver/superservice/clua.c\
		gameserver/superservice/gamedb.c\
		gameserver/superservice/gamedb.h\
		gameserver/battleservice/battleservice.h\
		gameserver/battleservice/battleservice.c\
		gameserver/battleservice/map.c\
		gameserver/battleservice/map.h		
		$(CC) $(CFLAGS) -c $^ $(INCLUDE) $(DEFINE)
		ar -rc gameservice.a *.o
		rm -f *.o
		
client:testclient.c kendynet.a
	$(CC) $(CFLAGS) -o client testclient.c kendynet.a ../KendyNet/deps/luajit-2.0/src/libluajit.a  $(INCLUDE) $(LDFLAGS) $(DEFINE)	-rdynamic -ldl			
		
gate:gateserver/gateserver.c kendynet.a gateservice.a
	$(CC) $(CFLAGS) -o gate gateserver/gateserver.c gateservice.a kendynet.a\
	 ../KendyNet/deps/hiredis/libhiredis.a ../KendyNet/deps/luajit-2.0/src/libluajit.a  $(INCLUDE) $(LDFLAGS) $(DEFINE)	-rdynamic -ldl	

