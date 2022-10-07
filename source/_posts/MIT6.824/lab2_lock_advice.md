---
title: MIT6.824之lab2_raft_lock_advice
categories:
- 分布式
- MIT6.824
---

# rule 1

whenever you have one more goroutine gonna modify data , you should use lock to prevent data and
avoid multip-goroutine change data ,go race is a good tool , that is enable to detect data race ,
but without any helpful on below rules

# rule 2

whenever your code make a sequence of modification on shared code.if they looked at the
data midway through the sequence,other goroutines might malfunction, you should use lock
to pretect code block which gonna be change and other routine read data midway, for example

```golang
  rf.mu.Lock()
  rf.currentTerm += 1
  rf.state = Candidate
  rf.mu.Unlock()
```


one more goroutine could not read any of above temp updates, so A goroutine should hold locking over the critical section.
on the other hand , if B goroutine using r.currenTerm or r.state, ,who must hold locking when access r.currenTerm at somewhere

# rule 3

Whenever code does a sequence of reads of shared data (or
reads and writes), and would malfunction if another goroutine modified
the data midway through the sequence, you should use a lock around the
whole sequence.

please must take care and review the multi-goroutine change data at the same time.and must aware if another goroutine modified
the data midway through the sequence, you should use a lock around the whole sequence.

```golang

rf.mu.Lock()
  if args.Term > rf.currentTerm {
   rf.currentTerm = args.Term
  }
  rf.mu.Unlock()

```

# rule 4

this rule just only apply to lab2, it announces that It's usually a bad idea to hold a lock while doing anything that might wait: reading a Go channel, sending on a channel, waiting for a timer, calling time.Sleep(), or sending an RPC (and waiting for the
reply).

# rule 5

this rule is also apply for lab2 specifical case.
Be careful about assumptions across a drop and re-acquire of a
lock. One place this can arise is when avoiding waiting with locks
held.

Be careful about assumptions across a drop and re-acquire of a
lock. One place this can arise is when avoiding waiting with locks
held. For example, this code to send vote RPCs is incorrect:

```golang
  rf.mu.Lock()
  rf.currentTerm += 1
  rf.state = Candidate
  for <each peer> {
    go func() {
      rf.mu.Lock()
      args.Term = rf.currentTerm
      rf.mu.Unlock()
      Call("Raft.RequestVote", &args, ...)
      // handle the reply...
    } ()
  }
  rf.mu.Unlock()
```

The code sends each RPC in a separate goroutine. It's incorrect
because args.Term may not be the same as the rf.currentTerm at which
the surrounding code decided to become a Candidate. Lots of time may
pass between when the surrounding code creates the goroutine and when
the goroutine reads rf.currentTerm; for example, multiple terms may
come and go, and the peer may no longer be a candidate. One way to fix
this is for the created goroutine to use a copy of rf.currentTerm made
while the outer code holds the lock. Similarly, reply-handling code
after the Call() must re-check all relevant assumptions after
re-acquiring the lock; for example, it should check that
rf.currentTerm hasn't changed since the decision to become a
candidate.

It can be difficult to interpret and apply these rules. Perhaps most
puzzling is the notion in Rules 2 and 3 of code sequences that
shouldn't be interleaved with other goroutines' reads or writes. How
can one recognize such sequences? How should one decide where a
sequence ought to start and end?

One approach is to start with code that has no locks, and think
carefully about where one needs to add locks to attain correctness.
This approach can be difficult since it requires reasoning about the
correctness of concurrent code.

一个更务实的方法是从观察开始的，如果没有
没有并发性（没有同时执行的goroutine），你就根本不需要锁。
就根本不需要锁了。但是，当RPC系统创建goroutines来执行RPC时，你的并发性被强加于你
当RPC系统创建goroutines来执行RPC处理程序时，你的并发性是被迫的，并且
因为你需要在不同的goroutine中发送RPC以避免等待。
你可以有效地消除这种并发，方法是确定所有
的地方（RPC处理程序、你在Make()中创建的后台goroutine
中创建的后台goroutines，等等），在每个goroutine的开始时获取锁，并且只释放锁。
锁，并且只有在该程序完全结束并返回时才释放锁。
完全结束并返回时才释放锁。这个锁协议确保
没有任何重要的东西是并行执行的；锁保证了
每个goroutine在任何其他goroutine被允许启动之前执行完毕。
允许启动。由于没有并行执行，所以很难违反
规则1、2、3或5。如果每个goroutine的代码在孤立情况下是正确的
(当单独执行时，没有并发的goroutine)，那么当你使用锁时，它很可能
当你使用锁来抑制并发性时，它仍然是正确的。所以你
可以避免对正确性进行明确的推理，或者明确的
识别关键部分。
> 通过www.DeepL.com/Translator（免费版）翻译

However, Rule 4 is likely to be a problem. So the next step is to find
places where the code waits, and to add lock releases and re-acquires
(and/or goroutine creation) as needed, being careful to re-establish
assumptions after each re-acquire. You may find this process easier to
get right than directly identifying sequences that must be locked for
correctness.

(As an aside, what this approach sacrifices is any opportunity for
better performance via parallel execution on multiple cores: your code
is likely to hold locks when it doesn't need to, and may thus
unnecessarily prohibit parallel execution of goroutines. On the other
hand, there is not much opportunity for CPU parallelism within a
single Raft peer.)

# 原文

<details>
<summary>原文</summary>
<pre>
Raft Locking Advice

If you are wondering how to use locks in the 6.824 Raft labs, here are
some rules and ways of thinking that might be helpful.

Rule 1: Whenever you have data that more than one goroutine uses, and
at least one goroutine might modify the data, the goroutines should
use locks to prevent simultaneous use of the data. The Go race
detector is pretty good at detecting violations of this rule (though
it won't help with any of the rules below).

Rule 2: Whenever code makes a sequence of modifications to shared
data, and other goroutines might malfunction if they looked at the
data midway through the sequence, you should use a lock around the
whole sequence.

An example:

  rf.mu.Lock()
  rf.currentTerm += 1
  rf.state = Candidate
  rf.mu.Unlock()

It would be a mistake for another goroutine to see either of these
updates alone (i.e. the old state with the new term, or the new term
with the old state). So we need to hold the lock continuously over the
whole sequence of updates. All other code that uses rf.currentTerm or
rf.state must also hold the lock, in order to ensure exclusive access
for all uses.

The code between Lock() and Unlock() is often called a "critical
section." The locking rules a programmer chooses (e.g. "a goroutine
must hold rf.mu when using rf.currentTerm or rf.state") are often
called a "locking protocol".

Rule 3: Whenever code does a sequence of reads of shared data (or
reads and writes), and would malfunction if another goroutine modified
the data midway through the sequence, you should use a lock around the
whole sequence.

An example that could occur in a Raft RPC handler:

  rf.mu.Lock()
  if args.Term > rf.currentTerm {
   rf.currentTerm = args.Term
  }
  rf.mu.Unlock()

This code needs to hold the lock continuously for the whole sequence.
Raft requires that currentTerm only increases, and never decreases.
Another RPC handler could be executing in a separate goroutine; if it
were allowed to modify rf.currentTerm between the if statement and the
update to rf.currentTerm, this code might end up decreasing
rf.currentTerm. Hence the lock must be held continuously over the
whole sequence. In addition, every other use of currentTerm must hold
the lock, to ensure that no other goroutine modifies currentTerm
during our critical section.

Real Raft code would need to use longer critical sections than these
examples; for example, a Raft RPC handler should probably hold the
lock for the entire handler.

Rule 4: It's usually a bad idea to hold a lock while doing anything
that might wait: reading a Go channel, sending on a channel, waiting
for a timer, calling time.Sleep(), or sending an RPC (and waiting for the
reply). One reason is that you probably want other goroutines to make
progress during the wait. Another reason is deadlock avoidance. Imagine
two peers sending each other RPCs while holding locks; both RPC
handlers need the receiving peer's lock; neither RPC handler can ever
complete because it needs the lock held by the waiting RPC call.

Code that waits should first release locks. If that's not convenient,
sometimes it's useful to create a separate goroutine to do the wait.

Rule 5: Be careful about assumptions across a drop and re-acquire of a
lock. One place this can arise is when avoiding waiting with locks
held. For example, this code to send vote RPCs is incorrect:

  rf.mu.Lock()
  rf.currentTerm += 1
  rf.state = Candidate
  for <each peer> {
    go func() {
      rf.mu.Lock()
      args.Term = rf.currentTerm
      rf.mu.Unlock()
      Call("Raft.RequestVote", &args, ...)
      // handle the reply...
    } ()
  }
  rf.mu.Unlock()

The code sends each RPC in a separate goroutine. It's incorrect
because args.Term may not be the same as the rf.currentTerm at which
the surrounding code decided to become a Candidate. Lots of time may
pass between when the surrounding code creates the goroutine and when
the goroutine reads rf.currentTerm; for example, multiple terms may
come and go, and the peer may no longer be a candidate. One way to fix
this is for the created goroutine to use a copy of rf.currentTerm made
while the outer code holds the lock. Similarly, reply-handling code
after the Call() must re-check all relevant assumptions after
re-acquiring the lock; for example, it should check that
rf.currentTerm hasn't changed since the decision to become a
candidate.

It can be difficult to interpret and apply these rules. Perhaps most
puzzling is the notion in Rules 2 and 3 of code sequences that
shouldn't be interleaved with other goroutines' reads or writes. How
can one recognize such sequences? How should one decide where a
sequence ought to start and end?

One approach is to start with code that has no locks, and think
carefully about where one needs to add locks to attain correctness.
This approach can be difficult since it requires reasoning about the
correctness of concurrent code.

A more pragmatic approach starts with the observation that if there
were no concurrency (no simultaneously executing goroutines), you
would not need locks at all. But you have concurrency forced on you
when the RPC system creates goroutines to execute RPC handlers, and
because you need to send RPCs in separate goroutines to avoid waiting.
You can effectively eliminate this concurrency by identifying all
places where goroutines start (RPC handlers, background goroutines you
create in Make(), &c), acquiring the lock at the very start of each
goroutine, and only releasing the lock when that goroutine has
completely finished and returns. This locking protocol ensures that
nothing significant ever executes in parallel; the locks ensure that
each goroutine executes to completion before any other goroutine is
allowed to start. With no parallel execution, it's hard to violate
Rules 1, 2, 3, or 5. If each goroutine's code is correct in isolation
(when executed alone, with no concurrent goroutines), it's likely to
still be correct when you use locks to suppress concurrency. So you
can avoid explicit reasoning about correctness, or explicitly
identifying critical sections.

However, Rule 4 is likely to be a problem. So the next step is to find
places where the code waits, and to add lock releases and re-acquires
(and/or goroutine creation) as needed, being careful to re-establish
assumptions after each re-acquire. You may find this process easier to
get right than directly identifying sequences that must be locked for
correctness.

(As an aside, what this approach sacrifices is any opportunity for
better performance via parallel execution on multiple cores: your code
is likely to hold locks when it doesn't need to, and may thus
unnecessarily prohibit parallel execution of goroutines. On the other
hand, there is not much opportunity for CPU parallelism within a
single Raft peer.)
</pre>
</details>