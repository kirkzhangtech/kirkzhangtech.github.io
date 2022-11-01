---
title: raft_structure_guide
categories:
- 分布式
- MIT6.824
---
Raft Structure Advice

A Raft instance has to deal with the arrival of external events (Start() calls, AppendEntries and RequestVote RPCs, and RPC replies),and it has to execute periodic tasks (elections and heart-beats). There are many ways to structure(vt.组织) your Raft code to manage these activities; this document outlines(v.概括) a few ideas.
<!-- more -->
<!-- toc -->

## 1 struct raft instance

Each Raft instance has a bunch of state (the log, the current index,
&c) which must be updated in response to events arising in concurrent
goroutines. The Go documentation points out that the goroutines can
perform the updates directly using shared data structures and locks,
or by passing messages on channels. Experience suggests that for Raft
it is most straightforward to use shared data and locks.

<text style="font-family:Courier New;color:red">

experience suggests that directly struct raft instance using shared data and lock

</text>

## 2 two events of election and hearbeat

A Raft instance has two time-driven activities: the leader must send
heart-beats, and others must start an election if too much time has
passed since hearing from the leader. **It's probably best to drive each
of these activities with a dedicated long-running goroutine**, rather
than combining multiple activities into a single goroutine.

<text style="font-family:Courier New;color:red">
It's probably best to drive each of these activities
with a dedicated long-running goroutine
</text>

## 3. how struct election event
The management of the election timeout is a common source of
headaches. Perhaps the simplest plan is to maintain a variable in the
Raft struct containing the last time at which the peer heard from the
leader, and to have the election timeout goroutine periodically check
to see whether the time since then is greater than the timeout period.
It's easiest to use time.Sleep() with a small constant argument to
drive the periodic checks. Don't use time.Ticker and time.Timer;
they are tricky(adj.狡猾的,机警的) to use correctly.

<text style="font-family:Courier New;color:red">
using hashicorp struct by compare lastContact timestamp
</text>

## 4. seperate election, hearbeat, applier
You'll want to have a separate long-running goroutine that sends
committed log entries in order on the applyCh. It must be separate,
since sending on the applyCh can block; and it must be a single
goroutine, since otherwise it may be hard to ensure that you send log
entries in log order. The code that advances commitIndex will need to
kick the apply goroutine; it's probably easiest to use a condition
variable (Go's sync.Cond) for this.

<text style="font-family:Courier New;color:red">
using a seperate applier channel and with `sync.cond`
</text>

## 5. unhold lock during you apply log

Each RPC should probably be sent (and its reply processed) in its own
goroutine, for two reasons: so that unreachable peers don't delay the
collection of a majority of replies, and so that the heartbeat and
election timers can continue to tick at all times. It's easiest to do
the RPC reply processing in the same goroutine, rather than sending
reply information over a channel.

<text style="font-family:Courier New;color:red">
easy to understand, using two different channels to send and process
reply of RPC
</text>

## 6. figure 2 is good raft guide

Keep in mind that the network can delay RPCs and RPC replies, and when
you send concurrent RPCs, the network can re-order requests and
replies. Figure 2 is pretty good about pointing out places where RPC
handlers have to be careful about this (e.g. an RPC handler should
ignore RPCs with old terms). Figure 2 is not always explicit about RPC
reply processing. The leader has to be careful when processing
replies; it must check that the term hasn't changed since sending the
RPC, and must account for the possibility that replies from concurrent
RPCs to the same follower have changed the leader's state (e.g.
nextIndex).

<text style="font-family:'Courier new'; color:red ">

1. this part we should put eyes on checking reply of concurrent RPC, like
election and heartbeat.
2. ignore old term
3. be careful of term since you send out,must check leader when you receive replies
 
networking summary:</br>
1. Network delay message
2. Message arrive at peer not in order of sending and re-order response
3. Outage of sending out RPC

</text>
