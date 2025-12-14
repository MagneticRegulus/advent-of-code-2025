# advent-of-code-2025

This is a repo for Advent of Code 2025.

This year, I decided to complete the calendar in Ruby, my first programming language. I haven't programmed in Ruby in years, so this will be a lot of fun. Of course, my rustiness will show!

**This is not intended to be an exemplar of my programming skills; it's just some fun for a few days! Lots of this code will be abolute garbage**

### Day 2

Had a lot of fun with part one as I found an algorithm which really sped up the program run time, but it was less practical for part 2. There is another algorithm *there* for part 2, I just hadn't quite figured it out yet.

### Day 4

I wrote some terribly inefficient (and I *mean* inefficient) ruby code for this one because I wanted to play around with ruby classes again. Mistake. It worked...it just took 17 minutes 25 seconds. If I had more time, I would have made it much faster.

I must remember to do things more simply tomorrow!

### Day 5

Part 1 was much shorter than yesterday's, took about 20 minutes to sort out. Though, I tried to create a flattened list of all the valid ids...crashed my computer twice. Check if any ranges cover a give id? Instant response. Perfect Big O problem!

Part 2, I actually found pretty much the solution I was looking for on Stack_exchange, but it was a good way to be reminded of the .inject method and how you can use it to build an enumerable.

### Day 7

Yet again, I tried to brute force my way through part 2 and crashed my computer. Good stuff! **I did say lots of this code will be garbage**

### Day 8
I think I finally remembered how to use ruby classes again in a way that is helpful rather than being over-complex.

### Day 9
Well part 2 was a bit much, but I did eventually get it...took me a while to realise I just needed to see if anylines bisected the inner tiles of a rectangle

### Day 10
I think I need to start over with this one because I spent a lot of time making a graph with nodes only to have the most optimal performance solution be too high an answer. I think I need to make this more mathy than what I've done

### Day 11
Ok part 2 of this one took a few days to do because I simply forgot to mark nodes as visited. Whoops! Once I did that, the whole program went from taking 12+ hours to run to 0.07 seconds. *sigh* Kicking myself, kicking myself! But otherwise this was a pretty simple DFS graph. Pretty cool. I did basically have the solution in a few hours on day 11, it was just that one thing!