---
title: 高效研究的个人规则
categories:
- 随笔
# clearReading: true
# thumbnailImagePosition: bottom
# thumbnail_image: true
coverImage: avatar.jpg

---
> 作者：Eugene Vinitsky

Personal Rules of Productive Research

Caveats(`['kæviæt] 警告;说明`) and intent(`[ɪn'tɛnt]意图;目的;含义`): 
Painstakingly extracted via trial and error, ever evolving. Mostly an exercise to think through prior mistakes and avoid making them again. These are my personal rules, they might not work for you but it’s invariably a mistake when I stray from them. Given that I’m not the world’s most successful researcher (I’m not too shabby either though) maybe you’re better off taking advice from someone else. On the other hand, I would contend that these rules are universally useful.

There’s a ton of good blogs and information about how to structure and think about your research vision but comparatively less thinking on what the day to day looks like. I was trying to figure out what rules I would try to insist(`vi/vt坚持,强调`) my students follow or try and figured it might be helpful for other folks. It seems like a lot but I’d say outside of the detailed notebook most of these are are either a few minutes here or there or a suggestion to add structure to your thinking to aid you in thinking more clearly.
<!-- more -->

## Run the simplest experiment first.

This is the mistake I make the most often. ML experiments are so easy to mess up you absolutely need to verify at each step that the minimal experiment is working. The minimal experiment is the absolute bare(`adj赤裸的`) minimum needed to check that either your code works or your idea makes sense. Unfortunately, I don’t think there’s a coherent definition of minimal, it seems to mostly be an aesthetic(`[ɛsˈθɛtɪk]adj美的;美学的`) thing. I’d call it the thing that has the least moving pieces.

Since nothing is better than concrete(`adj具体的`) details, let me just list all the ways I’ve done this wrong:

1) I had an RL problem where we had to solve some task where the dynamics were defined by N trajectories. Instead of checking whether I could solve one interesting trajectory perfectly, I kept running the algorithm over all N trajectories. 

2) I had a problem that could be run in single or multi-agent mode. Instead of trying to verify correctness of the codebase by running the single-agent version, I jumped right to the multi-agent version.

3) I had a multi-agent problem where I could run it with 100s of agents or just a few. I jumped right to 100s. I’ve done this one three times.

## Write a mini-version of your paper before getting started
This should consist of

A short introduction explaining the project
A short related work section making clear that the result is both new and relevant (if things work out as you expect)
A minimal experiment or theorem that you can use to verify if the idea makes sense.
It’s so easy for your ideas to seem clear until you write them down. Once you write them down you start noticing that:

they might not be all that clear or coherent
they might not be all that different than prior work
they might not be that interesting
Caveat: this doesn’t work for curiosity driven research where you don’t actually know what you’re setting out to find before you get there. However, if you think you know the destination it’s worth checking that you actually want to / can get there!

## Keep an ultra-detailed notebook
I personally under-invested into this at the beginning of my PhD and only really got into it after I had to try to reproduce the results of one of my own papers and ran into huge challenges doing so. At the very least, it winds up saving you time in the long term. At best, it helps structure your thinking and prevents you from losing great ideas.

Things that at a minimum you should track for reproducibility:

Experiment notebook:
Git hash and branch of the experiment you run
Actual command you ran
Config of experiment that was run
Intent of the experiment i.e. what you were testing
Result of the experiment
Implied next experiment
Code notebook. This might seem a little excessive but each one has saved me hours in return for minutes of extra effort.
Bugs you fixed (because I promise you, they will happen again)
Tricks for installing things and challenges you ran into (because I promise you, they will happen again)
Key commands that you ran (because I promise you, you will want to rerun them at some point)
Ideas for potential research projects that spawn while working on this.
I personally like notion for this as I have a bunch of templates that I use for generating the structure of each experiment and can throw the corresponding results / figures in pretty easily.

## Every paper should be reproducible via 1 script
This means a script that: 

1) launches all experiments

2) creates all figures (that aren’t custom powerpoint / gimp figures) in one go. Possibly save the powerpoint figure creation file in the repo too (I’m not super confident about this but it makes sense to me)

You’re going to wind up remaking your figures way more often then you expect so the initial time investment is worth it.

## Save all your videos in one place. SAVE ALL YOUR VIDEOS IN  ONE PLACE
In a few years you’re going to be giving talks that summarize some of your past work. It is the worst feeling to be hunting for old videos / figures from the work or trying to reproduce them from two year old models that you can barely load. 

This also applies to figures, you want to be frequently check-pointing your figures for a paper into a folder somewhere. It will make the following suggestion way easier as it’s easy to make a talk when the figures are already done.

## Present regularly (seminars, to your advisors)
This is basically the #1 mistake some of my own students make at the beginning of our work together. I’ll give them a task, they’ll disappear into the ether, and then they’ll return two months later with some issues that could have used early feedback. What’s the point of being part of the research community if you’re not taking advantage of it? Feedback is the fastest way to discover that your ideas need to be cleared up a bit, to get pointers to work that you’ve missed, and to force yourself to keep your work organized in a manner that is legible.

## Suggested frequency:

If you have a graduate student mentor on a project, check in with them quite often! They’re there to help and know how to get out of some holes you can dig yourself into. 
Get lunch or informally discuss your work with smart folks basically as much as you can (you are likely to be quite rate-limited on how often you can find a way to do this rather than rate limited by how useful this is). This way you get to know them and probably learn a ton about how they think.
Present to your advisors at least every other week
Present to your lab group at least once a semester
Present to the department at least once a year (but better if once a semester)
Present or discuss your work in some informal settings (reading group, small seminar) at least twice a semester
Yeah, it’s a lot of presenting.

