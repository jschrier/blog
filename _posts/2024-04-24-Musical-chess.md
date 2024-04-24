---
title: "Musical chess"
date: 2024-04-24
tags: mathematica music chess
---

Could you use a chess game as a music sequencer? I have in mind live generative pieces generated while you play, perhaps using a [smart chess board as the interface](https://www.kickstarter.com/projects/bryghtlabs/chessup-2/description). **Some experiments at how this could sound...**  

We will use the[ Chess paclet](https://resources.wolframcloud.com/PacletRepository/resources/Wolfram/Chess/) to perform the implementation.

```mathematica
PacletInstall["Wolfram/Chess"]
Needs["Wolfram`Chess`"]
```

[//]: # (Failed to export image)

## A quick overview of the Chess paclet 

Random boards (i.e., after a certain number of randomly chosen moves) can be generated: 

```mathematica
b = RandomChessboard[10]
```

[//]: # (Failed to export image)

You can also load board states from a FEN description

```mathematica
b = Chessboard["2kr1b1r/ppp1qppp/2n2n2/3p1b2/3P1N2/2P1B3/PP1NQPPP/2KR1B1R b - - 3 11"]
```

[//]: # (Failed to export image)

The resulting board has a character array:

```mathematica
b["CharacterArray"]

(*{{"\[BlackRook]", "\[BlackKnight]", "\[BlackBishop]", " ", "\[BlackKing]", "\[BlackBishop]", "\[BlackKnight]", "\[BlackRook]"}, {"\[BlackPawn]", " ", " ", "\[BlackPawn]", "\[BlackPawn]", " ", "\[BlackPawn]", "\[BlackPawn]"}, {" ", "\[BlackPawn]", " ", " ", " ", " ", "\[WhiteKnight]", " "}, {"\[BlackQueen]", "\[WhiteKnight]", "\[BlackPawn]", " ", " ", "\[BlackPawn]", " ", " "}, {" ", " ", " ", " ", " ", " ", " ", " "}, {" ", " ", " ", " ", " ", " ", " ", " "}, {"\[WhitePawn]", "\[WhitePawn]", "\[WhitePawn]", "\[WhitePawn]", "\[WhitePawn]", "\[WhitePawn]", "\[WhitePawn]", "\[WhitePawn]"}, {"\[WhiteRook]", " ", "\[WhiteBishop]", "\[WhiteQueen]", "\[WhiteKing]", "\[WhiteBishop]", " ", "\[WhiteRook]"}}*)
```

Chessgame holds collections of board states plus metadata:

```mathematica
game = Import["ExampleData/sample.pgn", {"ChessGames", 1}]
```

[//]: # (Failed to export image)

You can access the board state from the list of FENs in the game:

```mathematica
Take[#, 5] &@game["FENs"]

(*{"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1", "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2", "rnbqkbnr/pppp1ppp/8/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2", "r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3"}*)
```

## Sonification 1:  Sequential tones for each board position

**Idea:** Assign each board position a MIDI tone (from 1-64), and then play a note of duration 0.1 if the location is occupied and no note (or rest) if the position is unoccupied. To my mind this sounds like a kind of demented [Philip Glass](https://en.wikipedia.org/wiki/Philip_Glass):

```mathematica
sonify[board_Chessboard] := With[
    {activePositions = board["CharacterArray"] /. {" " -> 0, _String -> 1} // Flatten}, 
    Sound@MapThread[SoundNote, {Range[8*8] - 32, 0.1*activePositions}]] 
 
sonify[fen_String] := sonify@Chessboard@fen
```

```mathematica
sonify[game_ChessGame] := Sound[ sonify /@ game["FENs"]]
```

```mathematica
sonify@game
Export["sonification01.mp3", %]
```

[//]: # (Failed to export image)

```
(*"sonification01.mp3"*)
```

## Sonification 2:  Pauses for absent pieces

**Idea:** Keep the assignments, but open locations are rests.  This creates a bit more variety in when notes sound, and thus a bit less monotonous. To my mind this sounds a bit more interesting, like a demented [John Cage](https://en.wikipedia.org/wiki/John_Cage):

```mathematica
sonify[board_Chessboard] := With[
    {activePositions = board["CharacterArray"] /. {" " -> 0, _String -> 1} // Flatten}, 
    Sound@Map[SoundNote[#, 0.1] &]@ (activePositions*(Range[8*8] - 32) /. {0 -> None})] 
 
sonify@game
Export["sonification02.mp3", %]
```

[//]: # (Failed to export image)

## Sonification 3:  Only play attacked pieces

**Idea:**  Only play notes corresponding to attacked pieces.  This will mean that we don\[CloseCurlyQuote]t have any sounds until  the middle of the keyboard as the game progresses. There is a bit more variety, but you get long stretches in the middle that are quite repetitive:

```mathematica
attacked[s_String] := With[
    {replaceAlpha = Thread[ Alphabet[][[1 ;; 8]] -> Range[0, 7]*8], 
     replaceInt = Thread[ (ToString /@ Range[8]) -> Range[8]]}, 
    -32 + Plus @@ Characters[s] /. replaceAlpha /. replaceInt] 
 
attacked[b_Chessboard] := attacked /@ b["AttackedSquares"]
```

```mathematica
sonify[board_Chessboard] := 
   Sound@Map[SoundNote[#, 0.1] &]@attacked[board] 
 
sonify@game
Export["sonification03.mp3", %]

```

[//]: # (Failed to export image)

```
(*"sonification03.mp3"*)
```

## Sonification 4: Drones

**Idea:**  OK, enough with the piano keyboard---let us instead think of this as an additive synthesis type problem. Each position is a sine oscillator.  We start with chaos (many overlapping tones and evolve to simplicity). Each row spans an octave. Unfortunately, this sounds super harsh.

```mathematica
divisions[start_] := Most@Subdivide[start, 2*start, 8] 
 
sonify[board_Chessboard] := With[
    {activePositions = board["CharacterArray"] /. {" " -> 0, _String -> 1} // Flatten, 
     frequencies = divisions /@ (2^# &) /@ Range[6, 13] // Flatten }, 
    Play[
     Total@Thread[ activePositions*Sin[frequencies 2 Pi t]], 
     {t, 0, 1}, SampleDepth -> 16, SampleRate -> 22000]] 
 
sonify@b
Export["sonification04.mp3", %]

```

[//]: # (Failed to export image)

```
(*"sonification04.mp3"*)
```

Comment:  This sounds really harsh, even for a single state.  I wouldn\[CloseCurlyQuote]t want to listen to this 

## Sonification 4b:  Closer tones

Idea: A neat trick with sine oscillators is the beating and interference patterns they form.  So instead let us use that as a basis. Suppose all 8 rows span 1 octave:  each row is a note, but within the row we have a subdivision until the next note.  This should lead us to have lots of beating early on and then start to pick out individual sounds.  This sounds like a demented [Edgard Vare'se](https://en.wikipedia.org/wiki/Edgard_Vare`se) to my ear...there are some interesting modulations, but it is still too sonically crowded.  And perhaps 1 second is too long for each move to occupy sonically: 

```mathematica
divisions[start_] := Subdivide[start, 2*start, 8]
```

```mathematica
sonify[board_Chessboard] := With[
    {activePositions = board["CharacterArray"] /. {" " -> 0, _String -> 1} // Flatten, 
     frequencies = (Most@Subdivide[First[#], Last[#], 8]) & /@ Partition[#, 2, 1] &@divisions[256] // Flatten }, 
    Play[
     Total@Thread[ activePositions*Sin[frequencies 2 Pi t]], 
     {t, 0, 1}, SampleDepth -> 16, SampleRate -> 22000]] 
 
sonify@game
Export["sonification04b.mp3", %]
```

[//]: # (Failed to export image)

```
(*"sonification04b.mp3"*)
```

## Sonification 4c: Sine oscillators on attack

Idea:  What if we only turn on the sine oscillator when a piece is attacked?  That should lead us to slowly dial in complexity.  It still is quite muddle in the middle, but has a kind of [bad B-movie theremin](https://en.wikipedia.org/wiki/Theremin) vibe:  

```mathematica
attacked[s_String] := With[
    {replaceAlpha = Thread[ Alphabet[][[1 ;; 8]] -> Range[0, 7]*8], 
     replaceInt = Thread[ (ToString /@ Range[8]) -> Range[8]]}, 
    Plus @@ Characters[s] /. replaceAlpha /. replaceInt] 
 
attacked[b_Chessboard] := 
   Total@Map[UnitVector[64, #] &]@Map[attacked]@b["AttackedSquares"] 
 
sonify[board_Chessboard] := With[
    {active = attacked[board], 
     frequencies = (Most@Subdivide[First[#], Last[#], 8]) & /@ Partition[#, 2, 1] &@divisions[256] // Flatten }, 
    Play[
     Total@Thread[ active*Sin[frequencies 2 Pi t]], 
     {t, 0, 0.5}, SampleDepth -> 16, SampleRate -> 22000]] 
 
sonify@game
Export["sonification04c.mp3", %]
```

[//]: # (Failed to export image)

```
(*"sonification04c.mp3"*)
```

## Other ideas:

- Do something smarter with rhythm 

- Differentiate the types of pieces (not just presence or absence at a location)

- Better elements of time--for example, have a long decay envelope  so that stationary pieces die down to zero volume, and the moves are emphasized

- Consider subtractive approach:  locations of pieces are band pass filters acting on a big noise input

## Seen elsewhere

- [Reddit post on sonifying the Morphy's Opera game](https://www.reddit.com/r/chess/comments/sebyik/sonification_of_the_opera_game/) (with youtube video).  Same basic idea as attempt 4, except only pieces in the center of the board play

```mathematica
ToJekyll["Musical chess", "mathematica music chess"]
```

[//]: # (Failed to export image)

[//]: # (Failed to export image)

[//]: # (Failed to export image)

[//]: # (Failed to export image)
