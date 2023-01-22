---
Title: "Jai Alai Monte Carlo"
Date: 2022-07-27
Tags: gambling probability montecarlo
---

I recently read [Steven Skiena's ](https://amzn.to/3z5VWVF)*[Calculated Bets](https://amzn.to/3z5VWVF)*[: ](https://amzn.to/3z5VWVF)*[Computers, Gambling, and Modeling to Win ](https://amzn.to/3z5VWVF)*[(2001)](https://amzn.to/3z5VWVF) which describes Jai Alai and his efforts to develop an effective betting system.  I enjoyed reading his *[Algorithm Design Manual](https://amzn.to/3OG3WCA),* and this one doesn't disappoint--*Calculated Bets* is a thoroughly enjoyable book, with a wry sense of humor.  Prof. Skiena has a [summary slide-deck on his website](https://www3.cs.stonybrook.edu/~skiena/PREVIOUS-VERSION/talks/talk-jaialai.pdf).  Alas, betting on Jai Alai probably isn't viable any more--[according to Wikipedia, as of July 2022 there is only one active professional fronton in the USA](https://en.wikipedia.org/wiki/Jai_alai#List_of_active_United_States_jai-alai_frontons).  **But there's an interesting probability problem that can be solved by simple Monte Carlo simulations...**

One of the peculiarities of [Jai Alai](https://en.wikipedia.org/wiki/Jai_alai) is the scoring system and how one wins the game.  In the *Spectacular Seven* scoring system eight players play in each match, arranged in a first-in, first-out  queue.  Starting at the front of the queue, two players compete.  The loser of the point is added to the end of the queue, and the winner stays at the front.  Play continues until one player accumulates 7 points.  In Spectacular Seven, after the first 7 physical points, each win is scored as 2 points.  This creates a disparity--even if players have an equal chance of winning, players that start in certain positions in the queue have an advantage. We can simulate this by Monte Carlo.

The basic idea of the program is organized around a datastructure of players as a list of tuples, where the first entry in each tuple is the player ID number and the second is the player's score.  We begin by defining functions to compute the total score (needed for determining if we have entered the double-point regime) and whether the lead player has won or not:

```mathematica
totalPoints[players_] := Total@players[[All, 2]]  (* how many points have been scored? *)
NotWonQ[players_] := players[[1, 2]] < 7 (* has the current leader won yet? *)
```

**The road not traveled:** Another way to define the ending criterion by searching for the maximal score.But, we only care about the first time that the maximal score is greater than 7 (which means that the current leader won the match).  So the below is **not** necessary and will be slower than the expressions above.

```mathematica
mostPoints[players_] := MaximalBy[players, Last][[1, 2]] (*what's the leader's score?*)
NotWonQ[players_] := mostPoints[players] < 7 (*has anyone won yet?*)
```

**Back to implementation:** Having defined these, we define functions for simulating a single match:

```mathematica
match[players_] := With[
   {competitor = RandomSample[players[[1 ;; 2]]],(*assume matched competitors*)
    others = Splice[players[[3 ;;]]], (*other players in queue*)
    pointAdd = If[totalPoints[players] < 7, {0, 1}, {0, 2}]},(*double points after first round*)
   {competitor[[1]] + pointAdd, others, competitor[[2]]}] (*return competitors*)
```

A game is played until one player wins; define a helper function:

```mathematica
game[] := With[ (*play match until someone wins*)
    {players = Table[{i, 0}, {i, 8}]}, 
    NestWhile[match, players, NotWonQ]] 
 
winner[players_] := players[[1, 1]] (*extract the player number for winner*)
```

Simulate 10^5 games and determine the percent chance that each player has of winning:

```mathematica
outcomes = Table[winner@game[], {10^5}];
N@KeySort@ResourceFunction["Proportions"]@outcomes

(*<|1 -> 0.1635, 2 -> 0.16136, 3 -> 0.13961, 4 -> 0.12431, 5 -> 0.10172,6 -> 0.10324, 7 -> 0.08861, 8 -> 0.11765|>*)
```

From this, we see that 1 and 2 have a substantial advantage, especially over player 7.  A good match director will try to assign better players to position 7 to balance these odds. 

```mathematica
ToJekyll["Jai Alai Monte Carlo", "gambling probability"]
```
