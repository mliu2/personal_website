/**********************************************************
* Name:  Ming Liu                                         *
* Project:  Project 4, Prolog Buildup Dominoes            *
* Class:  CMPS 366 Organization of Programming Languages  *
* Date:  12/2/14                                          *
**********************************************************/
         
         

%*********************************************************************
%Function Name: tournament
%Purpose: Start point of build up game
%Parameters: None
%Return Value: None
%Assistance Received: None
%*********************************************************************
%readnum12
%newGame
%loadGame       

tournament :- write('============================='),
              write('Welcome to Build-Up Dominoes'),
              write('============================='),nl,
              write('1. New Game'),nl,
              write('2. Load Game'), nl,
              readnum12(Input),
              Input = 1,
			  newGame([0,0]).
tournament :- loader.
tournament :- abort.
%*********************************************************************
%Function Name: tourWin
%Purpose: Informs user which play has won the tournament
%Parameters: Wins, a list containing the number of wins the human and computer player have
%Return Value: The string displayed informing user of the player that won the tournament
%Assistance Received: None.
%*********************************************************************
tourWin([First, Second]) :- First = Second, write('Nobody has managed to win. What a pity.').
tourWin([First, Second]) :- First > Second, write('You have triumphed over the heathen computer').
tourWin([First, Second]) :- First < Second, write('You have been vanquished by the heathen computer.').

%----------------------------Game Processes------------------
%************************************************
%Source code to start a new game
%************************************************
%*********************************************************************
%Function Name: newGame
%Purpose: To set up parameters a new game 
%Parameters: Wins, a list (humanWins computerWins)
%Return Value: None
%Assistance Received: None
%*********************************************************************
%makeBoneyard
%shuffle
%makeNewStack
%mill
%compareTop
%goFirst
%newHand

%Makes and shuffles the boneyards. Makes the stacks and finds who goes first
newGame(Wins) :- makeBoneyard('b',6,6,HumYard1),
				 makeBoneyard('w',6,6,CompYard1),
				 shuffle(HumYard1, 28, 30, HumYard2),
				 shuffle(CompYard1, 28, 30, CompYard2),
				 makeNewStack(HumYard2, HumStacks),
				 makeNewStack(CompYard2, CompStacks),
				 append(HumStacks, CompStacks, Stacks),
				 mill(HumYard2, 6, HumYard3),
				 mill(CompYard2, 6, CompYard3),
				 compareTop(HumYard3, CompYard3, [HumYardFinal, CompYardFinal]),
				 goFirst(HumYardFinal, CompYardFinal, Player),
				 newHand(Player, [HumYardFinal, CompYardFinal], Stacks, [[],[]], [0, 0], Wins).

%*********************************************
%Source Code to create a boneyard of dominoes
%*********************************************
%*********************************************************************
%Function Name: makeBoneyard
%Purpose: to construct the boneyard 
%Parameters: color, the character W or B, indicating the color of the tile
%                        pip1, the maximum value of the first pip. Should be 6 when called.
%                        pip2, the maximum value of the second pip. Should be 6 when called.
%Return Value: List of dominoes
%Assistance Received: None
%********************************************************************* 
%makeBoneyard

makeBoneyard(Color, Pip1, Pip2, [Result]) :- Pip2 = 0, Result = [Color, Pip1, Pip2].
makeBoneyard(Color, Pip1, Pip2, [FirstResult|Result]) :- Pip1 = 0, NewPip2 is Pip2 - 1,
                                                         makeBoneyard(Color, NewPip2, NewPip2, NewRes),
                                                         FirstResult = [Color, Pip1, Pip2],
                                                         Result = NewRes.
makeBoneyard(Color, Pip1, Pip2, [FirstResult|Result]) :- NewPip1 is Pip1 - 1,
                                                         makeBoneyard(Color, NewPip1, Pip2, NewRes),
                                                         FirstResult = [Color, Pip1 ,Pip2],
                                                         Result = NewRes.
                                
%*********************************************************************
%Function Name: compareTop
%Purpose: Compares the top of two lists containing each of the boneyards, and shuffles if they are the same
%Parameters: NumList1, a list containing tiles of the human's boneyard.
%                        NumList2, a list containing tiles of the computer's boneyard.
%Return Value: a list RetYard containing the lists of the boneyards of the human and computer player's boneyards
%Assistance Received: none.
%*********************************************************************
%checkVal
%shuffle
%compareTop

%shuffles until the first dominoes are not equal
compareTop(NumList1, NumList2, RetYard) :- [Top1|_] = NumList1, [Top2|_] = NumList2,
                                           write('Your top tile: '),write(Top1), nl,
                                           write('Computer\'s top tile'), write(Top2), nl,
                                           checkVal(Top1, Val1), checkVal(Top2, Val2),
                                           Val1 = Val2, write('Tied first tile: shuffling...'), nl,
                                           length(NumList1, Length),
                                           shuffle(NumList1, Length, 1, NewList1), shuffle(NumList2, Length, 1, NewList2),
                                           compareTop(NewList1, NewList2, NewRetYard),
                                           RetYard = NewRetYard.
compareTop(NumList1, NumList2, RetYard) :- RetYard = [NumList1, NumList2].

%*********************************************************************
%Function Name: goFirst
%Purpose: Checks which player goes first
%Parameters: NumList1, a list containing tiles of the human's boneyard.
%                        NumList2, a list containing tiles of the computer's boneyard.
%Return Value: an atom of value 1 or 2, indicating which player goes first. 1 is human. 2 is computer
%Assistance Received: None.
%*********************************************************************
%checkVal

%if human player's tile is bigger, human goes first
goFirst(NumList1, NumList2, Turn) :- [Top1|_] = NumList1, [Top2|_] = NumList2,
									 checkVal(Top1, Val1), checkVal(Top2, Val2), 
                                     Val1 > Val2,
                                     Turn = 1.
%if human player's tile is smaller, computer goes first
goFirst(NumList1, NumList2, Turn) :- [Top1|_] = NumList1, [Top2|_] = NumList2, 
									 checkVal(Top1, Val1), checkVal(Top2, Val2), 
									 Val1 < Val2,
                                     Turn = 2.
%*********************************************************************
%Function Name: makeNewStack
%Purpose: Gets the top 6 tiles off of a boneyard to create one player's stacks
%Parameters: NumList, a list containing tiles that form one player's boneyard
%Return Value: A list containing the tiles that form one player's stacks
%Assistance Received: None.
%*********************************************************************
%draw

makeNewStack(NumList, Stacks) :- draw(NumList, 6, Stacks).

%*********************************************************************
%Function Name: newHand
%;Purpose: Sets up the parameters for playing a brand new hand
%Parameters: Player, an atom that keeps track of whose turn it is. 1 for human. 2 for computerWins
%                        Boneyards, a list of two lists containing human Boneyard, computer Boneyard
%                        Stacks, a list of the top tiles of the stack. The first 6 elements are the human's side. The last 6 are the computer's side.
%                        Hands, a list containing the player's hands as two lists
%                        Scores, a list containing the player's scores
%                        Wins, a list containing the number of rounds each player as won
%Return Value: None
%Local Variables: NewHScore, NewCScore, contain the scores from the most recent round.
%					FinalHumScore, FinalCompScore, the final scores for the game.
%					NewWins, the updated list of scores.
%					NewYards, the updated list of Boneyards.
%					NewStacks, the updated list containing the stack.
%					NewHands, the updated list of the player's hands.
%Algorithm: If the boneyards are empty, the final scores will be displayed and the wins updated. endGame is then called.
%                       If the boneyards are not empty, create a new list of hands and list of scores. If no hand is dealt, the score is set to [0 0]
%                       Playturn is then called with a boneyard with 6 fewer tiles from the top.
%Assistance Received: None
%*********************************************************************
%getScore
%endGame
%---or---
%draw
%findHand
%playTurn

%called by newHand/6 if the game ends
newHand([HumWins, CompWins], FinalHumScore, FinalCompScore) :- FinalHumScore > FinalCompScore,
                        write('Your final score: '),
						write(FinalHumScore), nl,
						write('Compuer\'s final score: '),
						write(FinalCompScore), nl,
						%Updates the round wins at the end of a game.
						NewHumWins is HumWins + 1,
						NewWins = [NewHumWins, CompWins],
						endGame(NewWins).
newHand([HumWins, CompWins], FinalHumScore, FinalCompScore) :- FinalHumScore < FinalCompScore,
						write('Your final score: '),
						write(FinalHumScore), nl,
						write('Compuer\'s final score: '),
						write(FinalCompScore), nl,
						%Updates the round wins at the end of a game.
						NewCompWins is CompWins + 1,
						NewWins = [HumWins, NewCompWins],
						endGame(NewWins).
newHand(Wins, FinalHumScore, FinalCompScore) :- FinalHumScore = FinalCompScore,
						write('Your final score: '),
						write(FinalHumScore), nl,
						write('Compuer\'s final score: '),
						write(FinalCompScore), nl,
						%Updates the round wins at the end of a game.
						endGame(Wins).

%main newHand function
newHand(_, [HumYard, CompYard], Stacks, Hands, [HumScore, CompScore], Wins) :- 
						HumYard = [], CompYard = [],
						getScore(Stacks, Hands, [NewHScore, NewCScore]),
                        FinalHumScore is HumScore + NewHScore,
						FinalCompScore is CompScore + NewCScore,
						newHand(Wins, FinalHumScore, FinalCompScore).
						/*FinalHumScore > FinalCompScore,
                        write('Your final score: '),
						write(FinalHumScore), nl,
						write('Compuer\'s final score: '),
						write(FinalCompScore), nl,
						%Updates the round wins at the end of a game.
						NewHumWins is HumWins + 1,
						NewWins = [NewHumWins, CompWins],
						endGame(NewWins).*/
/*newHand(_, [HumYard, CompYard], Stacks, Hands, [HumScore, CompScore], [HumWins, CompWins]) :- 						
						HumYard = [], CompYard = [],
						getScore(Stacks, Hands, [NewHScore, NewCScore]),
                        FinalHumScore is HumScore + NewHScore,
						FinalCompScore is CompScore + NewCScore,
						write(CompScore),write('|'), write(NewCScore),
						FinalHumScore < FinalCompScore,
						write('Your final score: '),
						write(FinalHumScore), nl,
						write('Compuer\'s final score: '),
						write(FinalCompScore), nl,
						%Updates the round wins at the end of a game.
						NewCompWins is CompWins + 1,
						NewWins = [HumWins, NewCompWins],
						endGame(NewWins).*/
/*newHand(_, [HumYard, CompYard], Stacks, Hands, [HumScore, CompScore], Wins) :- 						
						HumYard = [], CompYard = [],
						getScore(Stacks, Hands, [NewHScore, NewCScore]),
                        FinalHumScore is HumScore + NewHScore,
						FinalCompScore is CompScore + NewCScore,
						FinalHumScore = FinalCompScore,
						write('Your final score: '),
						write(FinalHumScore), nl,
						write('Compuer\'s final score: '),
						write(FinalCompScore), nl,
						%Updates the round wins at the end of a game.
						endGame(Wins).*/
newHand(Player, [HumYard, CompYard], Stacks, _, _, Wins) :- 		
						draw(HumYard, 6,NewHumHand),
						draw(CompYard, 6,NewCompHand),
						mill(HumYard, 6, NewHumYard),
						mill(CompYard, 6, NewCompYard),
						NewYards = [NewHumYard, NewCompYard],
						NewHands = [NewHumHand, NewCompHand],
						findHand(HumYard, HandNum), 
						%If new game, then set up the scores list
						HandNum = 0,
						NewScores = [0,0],
						playTurn(Player, NewYards, Stacks, NewHands, NewScores, [false, false], Wins).
newHand(Player, [HumYard, CompYard], Stacks, Hands, [HumScore, CompScore], Wins) :- 	
						draw(HumYard, 6,NewHumHand),
						draw(CompYard, 6,NewCompHand),
						mill(HumYard, 6, NewHumYard),
						mill(CompYard, 6, NewCompYard),
						NewYards = [NewHumYard, NewCompYard],
						NewHands = [NewHumHand, NewCompHand],
						findHand(HumYard, HandNum), 
						%Ongoing games will have new Boneyards, new Hands, new Scores, and reset the Pass list.
						HandNum \= 0,
						getScore(Stacks, Hands, [NewHScore, NewCScore]),
                        FinalHumScore is HumScore + NewHScore,
						FinalCompScore is CompScore + NewCScore,
						NewScores = [FinalHumScore, FinalCompScore],
						playTurn(Player, NewYards, Stacks, NewHands, NewScores, [false, false], Wins).

%*********************************************************************
%Function Name: playTurn
%Purpose: Lets the human or computer play
%Parameters: Player, a value that keeps track of whose turn it is, 1 for human, 2 for computer
%			 Yards, a list of lists containing the human player and computer player's boneyards
%			 Stacks, a list of the top tiles on the stack
%			 Hands, a list of lists containing the human player and computer player's hands
%			 Scores, a list of the human and computer player's scores
%			 Passes, a list containing a list of which player passed
%			 Wins, a list of the human and computer player's number of wins
%Local Variables: 
%Algorithm: If player is set to 0 (undetermined), get which player goes first, draw new hands
%			If both players passes or if both hands are empty, call newHand
%			Otherwise, 
%				If human is going, print board and ask if the user wants to save
%					Checks if the player must pass. If the yes, pass to next player
%					Ask user for input and update stacks and hands and pass to next player
%				If computer is going, print board and ask if the user wants to save
%					Checks if the player must pass. If the yes, pass to next player
%					Otherwise, call AIPlay to let computer play
%Return Value: T, from (terpri) from endGame from newHand
%Assistance Received: None
%*********************************************************************
%newHand
%---or---
%printBoard
%saveYN
%canPass
%wantHelp
%readnum05
%inputStack
%playTurn
%---or---
%printBoard
%saveYN
%canPass
%AIPlay
%playTurn

%indeterminate player means first player must be determined

playTurn(Player, [HumYard,CompYard], Stacks, Hands, Scores, _, Wins) :- 
			Player = 0,
			compareTop(HumYard, CompYard, [NewHumYard, NewCompYard]),
			goFirst(NewHumYard, NewCompYard, NewPlayer),
			newHand(NewPlayer, [NewHumYard, NewCompYard], Stacks, Hands, Scores, Wins).

%Both players have passes, so a new hand begins			
playTurn(Player, Yards, Stacks, Hands, Scores, Passes, Wins) :- 
			Passes = [true, true],
			newHand(Player, Yards, Stacks, Hands, Scores, Wins).

%Both hands are empty, so a new hand begins			
playTurn(Player, Yards, Stacks, Hands, Scores, _, Wins) :- 
			Hands = [[],[]],
			newHand(Player, Yards, Stacks, Hands, Scores, Wins).

%If hand is empty, the player must pass
playTurn(Player, Yards, Stacks, Hands, Scores, Passes, Wins) :- 
			Hands = [HumHand, _],
			HumHand = [],
			Player = 1,
			write('==========================='), nl,
			write('Your Turn!'), nl,
			printBoard(Yards, Stacks, Hands, Scores, Wins),
			write('You must pass.'), nl,
			replaceAt(Passes, 0, true, NewPasses),
			playTurn(2, Yards, Stacks, Hands, Scores, NewPasses, Wins).

%If the hand is not empty, determine if there are any plays available, pass that info on
playTurn(Player, Yards, Stacks, Hands, Scores, Passes, Wins) :- 
			Hands = [HumHand, _],
			Player = 1,
			write('==========================='), nl,
			write('Your Turn!'), nl,
			printBoard(Yards, Stacks, Hands, Scores, Wins),
			saveYN(Player, Yards, Stacks, Hands, Scores, Wins),
			canPass(Stacks, HumHand, CanPass),
			playTurn(Player, Yards, Stacks, Hands, Scores, Passes, CanPass, Wins).
			/*(Pass = true, 
			write('You must pass.'), nl,
			replaceAt(Passes, 0, true, NewPasses),
			playTurn(2, Yards, Stacks, Hands, Scores, NewPasses, Wins);
			Pass = false,
			wantHelp(Stacks, Hands),
			inputStack(Stacks, Hands, Board),
			Board = [NewStacks, NewHands],
			replaceAt(Passes, 0, false, NewPasses),
			playTurn(2, Yards, NewStacks, NewHands, Scores, NewPasses, Wins)).*/
/*--------------------------------Computer Turn----------------------------------*/
%Computer passes if its hand is empty
playTurn(Player, Yards, Stacks, Hands, Scores, Passes, Wins) :- 
			Hands = [_, CompHand],
			Player = 2,
			CompHand = [],
			write('==========================='), nl,
			write('Computer\'s Turn!'), nl,
			printBoard(Yards, Stacks, Hands, Scores, Wins),
			saveYN(Player, Yards, Stacks, Hands, Scores, Wins),
			write('Computer passes'), nl,
			replaceAt(Passes, 1, true, NewPasses),
			playTurn(1, Yards, Stacks, Hands, Scores, NewPasses, Wins).

%Checks if the computer has moves available
playTurn(Player, Yards, Stacks, Hands, Scores, Passes, Wins) :- 
			Hands = [_, CompHand],
			Player = 2,
			write('==========================='), nl,
			write('Computer\'s Turn!'), nl,
			printBoard(Yards, Stacks, Hands, Scores, Wins),
			saveYN(Player, Yards, Stacks, Hands, Scores, Wins),
			canPass(Stacks, CompHand, CanPass),
			playTurn(Player, Yards, Stacks, Hands, Scores, Passes, CanPass, Wins).
			/*(CanPass = true,
			write('Computer passes'), nl,
			replaceAt(Passes, 1, true, NewPasses),
			playTurn(1, Yards, Stacks, Hands, Scores, NewPasses, Wins);
			CanPass = false,
			aiPlay(Stacks, Hands, Board),
			Board = [NewStacks, NewHands],
			replaceAt(Passes, 1, false, NewPasses),
			playTurn(1, Yards, NewStacks, NewHands, Scores, NewPasses, Wins)).*/
			
			
%Decisions made based on if the player must pass
playTurn(Player, Yards, Stacks, Hands, Scores, Passes, CanPass, Wins) :- 
			Player = 1,
			CanPass = true,
			write('You must pass.'), nl,
			replaceAt(Passes, 0, true, NewPasses),
			playTurn(2, Yards, Stacks, Hands, Scores, NewPasses, Wins).

%Allows human to play			
playTurn(Player, Yards, Stacks, Hands, Scores, Passes, CanPass, Wins) :- 
			Player = 1,
			CanPass = false,
			wantHelp(Stacks, Hands),
			inputStack(Stacks, Hands, Board),
			Board = [NewStacks, NewHands],
			replaceAt(Passes, 0, false, NewPasses),
			playTurn(2, Yards, NewStacks, NewHands, Scores, NewPasses, Wins).
			


%Computer has no moves, must pass.
playTurn(Player, Yards, Stacks, Hands, Scores, Passes, CanPass, Wins) :- 
			Player = 2,
			CanPass = true,
			write('Computer passes'), nl,
			replaceAt(Passes, 1, true, NewPasses),
			playTurn(1, Yards, Stacks, Hands, Scores, NewPasses, Wins).
%Computer plays
playTurn(Player, Yards, Stacks, Hands, Scores, Passes, CanPass, Wins) :- 
			Player = 2,
			CanPass = false,
			aiPlay(Stacks, Hands, Board),
			Board = [NewStacks, NewHands],
			replaceAt(Passes, 1, false, NewPasses),
			playTurn(1, Yards, NewStacks, NewHands, Scores, NewPasses, Wins).
			

%*********************************************************************
%Function Name: printBoard
%Purpose: Prints the board state 
%Parameters: Yards, a list of lists containing the human player and computer player's boneyards
%                        Stacks, a list of the top tiles on the stack
%                        Hands, a list of lists containing the human player and computer player's hands
%                        Scores, a list of the human and computer player's scores
%                        Wins, a list of the human and computer player's number of wins
%Return Value: None
%Assistance Received: None
%*********************************************************************
%findHand
%draw

printBoard([HumYard, _], Stacks, [HumHand, _], [HumScore, CompScore], [HumWins, CompWins]) :- 
                        write('Hand: '), findHand(HumYard, NumHands), write(NumHands), nl,
                        write('Computer\'s Rounds Won: '), write(CompWins), nl,
                        write('Compter\'s Score: '), write(CompScore), nl,
                        Stacks = [A,B,C,E,F,G|CompStack],
                        HumStack = [A,B,C,E,F,G],
                        write(CompStack), nl,
                        write('    W1      W2      W3      W4      W5      W6  '), nl,
                        write(HumStack), nl,
                        write('    B1      B2      B3      B4      B5      B6  '), nl,
                        write('---------------------------'), nl,
                        write(HumHand), nl,
                        write('    0       1        2       3       4       5  '), nl,
                        write('Your Score: '), write(HumScore), nl,
                        write('Your Rounds Won: '), write(HumWins), nl.

%*********************************************************************
%Function Name: endGame
%Purpose: Displays the number of rounds each player has won and prompts user if user wants to play again
%Parameters: Wins, a list containing the number of wins the human and computer player have
%Return Value: None
%Assistance Received: None.
%*********************************************************************
%readnum12
%newGame
%tourWin

endGame([HumWins, CompWins]) :- write('Your Rounds Won: '),
                                write(HumWins), nl,
                                write('Computer\'s rounds won: '),
                                write(CompWins), nl,
                                write('Play Again?'), nl,
                                write('1. Yes'), nl,
                                write('2. No'), nl,
                                readnum12(Input),
                                Input = 1,
                                newGame([HumWins, CompWins]).
endGame(Wins) :- tourWin(Wins), nl, abort.

%*********************************************************************
%Function Name: getScore
%Purpose: gets the score from the current board
%Parameters: Stacks, a list of the top tiles of the stack. The first 6 elements are the human's side. The last 6 are the computer's side.
%Return Value: Scores, A list with human's score and computer's score
%Assistance Received: Non
%*********************************************************************
%sumtiles

getScore(Stacks, [HumHand, CompHand], Scores) :- sumTiles(Stacks, 'b', HumStSum),
                                                 sumTiles(HumHand, 'b', HumHdSum),
                                                 sumTiles(Stacks, 'w', CompStSum),
                                                 sumTiles(CompHand, 'w', CompHdSum),
                                                 HumScore is HumStSum - HumHdSum,
                                                 CompScore is CompStSum - CompHdSum,
                                                 Scores = [HumScore, CompScore].
                                                                                                
%*********************************************************************
%Function Name: sumTiles
%Purpose: Sums the values of all of the tiles in a list of a given color
%Parameters: NumList, the list of tiles to be searched. Tiles should be lists containing color, pip1, and pip2.
%                        Color, a character 'w' or 'b' that the function will look for.
%Return Value: Sum, the sum of all of the tiles in the list of the given color
%Assistance Received: None
%*********************************************************************
%checkColor
%checkVal
%sumTiles

sumTiles(NumList, _, Sum) :- NumList = [], Sum = 0.
sumTiles([First|Rest], Color, Sum) :- checkColor(First, ColValue),
                                      ColValue = Color, checkVal(First, Value),
                                      sumTiles(Rest, Color, NewSum),
                                      Sum is Value + NewSum.
sumTiles([_|Rest], Color, Sum) :- sumTiles(Rest, Color, NewSum), Sum = NewSum.
%-----------------------------Validators---------------------------------------
%*********************************************************************
%Function Name: readnum12
%Purpose: To prompt user for input for integer between 1 and 2
%Parameters: None
%Return Value: Value, an integer between 1 and 2 
%Assistance Received: None
%*********************************************************************
readnum12(Value) :- write('Please enter a number from the menu: '),
                        nl, read(Input),
                        valid12(Input, Return),
                        Value = Return.
%*********************************************************************
%Function Name: inputStack
%Purpose: validates user input for stack and checks if the player is legal
%Parameters: Stacks, a list of tiles containing the stacks
%                        Hands, a list of lists containing the human and computer player's hands
%Return Value: a list Board, containing the list containing the updated stack and the list containing the updated hands.
%				if the play was illegal, return []
%Assistance Received: None
%*********************************************************************
%findAt
%stackToIndex
%tryplay
%replaceAt
%eliminate

inputStack(Stacks, [HumHand, CompHand], Board) :-  
				length(HumHand, HandSize),
				readnum05(HandSize, HandTile),
				write('Please enter a stack name: '),
				read(Input), findAt(HumHand, HandTile, Tile), nl,
				stackToIndex(Input, Index), 
				Index > -1, 
				tryplay(Stacks, Tile, Index, MayPlay),
				inputStack(Stacks, [HumHand, CompHand], Tile, Index, Input, MayPlay, Board).
inputStack(_, _, Board) :-
				write('Invalid move'), nl,
				Board = [].

inputStack(Stacks, [HumHand, CompHand], Tile, Index, Input, MayPlay, Board) :- 
				MayPlay = true,
				write('You Played '),
				write(Tile),
				write(' on '),
				write(Input), nl,
				replaceAt(Stacks, Index, Tile, NewStacks),
				findEle(HumHand, Tile, 0, HandTile),
				eliminate(HumHand, HandTile, NewHumHand),
				Board = [NewStacks, [NewHumHand, CompHand]].
inputStack(Stacks, [HumHand, CompHand], _, _,_, MayPlay, Board) :-
				MayPlay = false,
				write('Invalid move'), nl,
				inputStack(Stacks, [HumHand, CompHand], Board).
				

%*********************************************************************
%Function Name: stackToIndex
%Purpose: translate the user's input of stack name to the index on the stack list
%Parameters: Input, an atom containing the input from inputStack()
%Return Value: RetInd containing the index on the stack list, or -1 if the input could not be translated
%Assistance Received: None
%*********************************************************************

stackToIndex(Input, RetInd) :- string_chars(Input, [Side, CIndex]),
								atom_number(CIndex, Index),
								Index > 0, Index < 7,
								Side = 'w',
								RetInd is Index + 5.
stackToIndex(Input, RetInd) :- string_chars(Input, [Side, CIndex]),
								atom_number(CIndex, Index),
								Index > 0, Index < 7,
								Side = 'b',
								RetInd is Index - 1.
stackToIndex(_, RetInd) :- RetInd = -1.

%*********************************************************************
%Function Name: indexToStack
%Purpose: Translates the index on the stack list into human readable stack names
%Parameters: Input, an atom containing the index on the stack list
%Return Value: Stack, a list containing the stack name
%Assistance Received: None.
%*********************************************************************

indexToStack(Input, Stack) :- Input >= 6,
								Index is Input - 5,
								Stack = ['w', Index].
indexToStack(Input, Stack) :- Input < 6,
								Index is Input + 1,
								Stack = ['b', Index].

%*********************************************************************
%Function Name: readnum05
%Purpose: Validates user input for index of tile in hand
%Parameters: Handsize, an atom containing the size of the hand being played from
%Return Value: Value containing an index that can be validated
%Assistance Received: None.
%*********************************************************************
%read
%valid05

readnum05(Handsize, Value) :-	write('Please enter the index of the tile: '),
                        nl, read(Input),
                        valid05(Input, Handsize, Return),
                        Value = Return.
%*********************************************************************
%Function Name: valid05
%Purpose: Validates user input for the index of tile in hand
%Parameters: Num, an atom containing the index to be verified
%			 Handsize, an atom containing the size of the hand being played from
%Return Value: Value, containing an index that could be validated
%Assistance Received: None.
%*********************************************************************
%readnum05

valid05(Num, Handsize, Value) :- Num >= 0, Num < Handsize, Value = Num.
valid05(_, Handsize, Value) :- readnum05(Handsize, Return), Value = Return.

%*********************************************************************
%Function Name: valid12
%Purpose: To validate that the input is either 1 or 2
%Parameters: num, an integer passed in from readnum12()
%Return Value: Ret, A number between 1 and 2
%Assistance Received: None
%*********************************************************************

valid12(Value, Ret) :- Value = 1, Ret = 1.
valid12(Value, Ret) :- Value = 2, Ret = 2.
valid12(Value, Ret) :- Value\= 1, Value \= 2, readnum12(NewValue), Ret = NewValue.

%*********************************************************************
%Function Name: validYN
%Purpose: Validates user input of y or n
%Parameters: input, atom containing user input
%Return Value: Return, holding y or n, based on user input
%Assistance Received: none
%*********************************************************************
%validYN

validYN(Input, Return) :- Input = 'y', Return = Input.
validYN(Input, Return) :- Input = 'n', Return = Input.
validYN(Input, Return) :- Input \= 'y', Input \= 'n',
							write('(y./n.?)'), nl,
							read(NewInput),
							validYN(NewInput, NewRet),
							Return = NewRet.
%*********************************************************************
%Function Name: tryplay
%Purpose: Checks if the tile is playable
%Parameters: Stacks, a list containing the top tiles on the stacks
%			 Tile, the list containing the tile being played
%			 TileIndex, the index on the stack where the tile will be played
%Return Value: MayPlay of value True or false, indicating if the tile is playable
%Assistance Received: None.
%*********************************************************************
%findAt
%checkVal
%checkDouble

%Recieves input on what tile is being played and gets the derived values
tryplay(Stacks, Tile, TileIndex, MayPlay) :- findAt(Stacks, TileIndex, Stacktile),
											checkVal(Tile,ValHand), checkVal(Stacktile, ValStack),
											checkDouble(Tile, IsDouble), checkDouble(Stacktile, IsDoubleSt), 
											tryplay(ValHand, ValStack, IsDouble, IsDoubleSt, MayPlay).

%decides if the tile is playable based on the derived values
tryplay(_, _, IsDouble, IsDoubleSt, MayPlay) :- 
									IsDouble = true,
									IsDoubleSt = false,
									MayPlay = true.	
tryplay(ValHand, ValStack, IsDouble, IsDoubleSt, MayPlay) :-
									IsDouble = false,
									IsDoubleSt  = false,
									ValHand = ValStack,
									MayPlay = true.
	
tryplay(ValHand, ValStack, _, _, MayPlay) :- 
									ValHand > ValStack,
									MayPlay = true.
tryplay(_, _, _, _,MayPlay) :- MayPlay = false.

%*********************************************************************
%Function Name: canPass
%Purpose: Checks if the player can pass based on their hand and the stacks
%Parameters: Stacks, the list of the top tiles on the stacks
%			 playHand, the list containing the tiles in hand for the player 
%Return Value: Pass which is false, if the player cannot pass and true if the player can.
%Assistance Received: None.
%*********************************************************************
%bestPlay


canPass(Stacks, PlayHand, Pass) :- bestPlay(Stacks, PlayHand, Can),
									canPass(Stacks, PlayHand, Can, Pass).
canPass(_, _, Can ,Pass) :- Can \= [], Pass = false.
canPass(_, _, _, Pass) :- Pass = true.

%*********************************************************************
%Function Name: bestPlay
%Purpose: Finds if any plays are possible
%Parameters: Stacks, the list of the top tiles on the stacks.
%			 PlayHand, the list of the tiles in the player's hand
%Return Value: Plays, a list of [tile, index on stack], if the player can play. [] if the player can not
%Assistance Received: None.
%*********************************************************************
%findEle
%lowestValue
%tryplay
%bestPlay											

%If the hand is empty, no plays are possible
bestPlay(_, PlayHand, Plays) :- PlayHand = [], Plays = [].

%Calls a loop that begins checking if any moves remain
bestPlay(Stacks, PlayHand, Plays) :- bestPlay(Stacks, PlayHand, 0, 0, Plays).
%loop control mechanism
bestPlay(Stacks, PlayHand, Stackindex, Handindex, Plays) :- Stackindex = 12, 
															NewHandindex is Handindex + 1,
															bestPlay(Stacks, PlayHand, 0, NewHandindex, Plays).
bestPlay(_, PlayHand, _, Handindex, Plays) :- length(PlayHand, Length),
															Handindex = Length,
															Plays = [].

%Any true value will stop the loop
bestPlay(Stacks, PlayHand, Stackindex, Handindex, Plays) :- findAt(PlayHand, Handindex, HandTile),
															tryplay(Stacks, HandTile, Stackindex, MayPlay),
															bestPlay(Stacks, PlayHand, Stackindex, Handindex, MayPlay, Plays).
bestPlay(_,PlayHand, Stackindex, Handindex, May, Plays) :-	May = true,
															findAt(PlayHand, Handindex, Tile),
															Plays = [Tile, Stackindex].
bestPlay(Stacks, PlayHand, Stackindex, Handindex, May, Plays) :- May = false,
																NewStackindex is Stackindex + 1,
																bestPlay(Stacks, PlayHand, NewStackindex, Handindex, Plays).

/*bestPlay(Stacks, PlayHand, Plays) :- lowestValue(Stacks, LowVal), 
									findEle(Stacks, LowVal, 0, LowestTile),
									lowestValue(PlayHand, LowHand),
									tryplay(Stacks, LowHand, LowestTile, Can),
									bestPlay(Stacks, PlayHand, LowHand, LowestTile, Can, Plays).
bestPlay(_, _, LowHand, LowestTile, Can, Plays) :-
									Can = true, 
									Plays = [LowHand, LowestTile].
bestPlay(Stacks, PlayHand, LowHand, _, Can, Plays) :-
									Can = false, 
									findEle(PlayHand, LowHand, 0,HandIndex),
									eliminate(PlayHand, HandIndex, NewHand),
									bestPlay(Stacks, NewHand, NewPlay),
									Plays = NewPlay.
bestPlay(_, _, _, _, _,Plays) :- Plays = [].			*/				

%-------------------------------------Check for derived values-------------------------------
%*********************************************************************
%Function Name: findHand
%Purpose: Finds which hand is currently being played based on the number of tiles in the boneyard
%Parameters: Yard, a list containing any one boneyard
%Return Value: Hand of the values 0,1,2,3,4 or the string "corrupted data" indicating the hand.
%Assistance Received: None
%*********************************************************************

%Calculates the hand the game is currently on by counted the number of tiles in a boneyard
findHand(Yard, Hand) :- length(Yard, Length), Length = 22, Hand is 0 .
findHand(Yard, Hand) :- length(Yard, Length), Length = 16, Hand is 1 .
findHand(Yard, Hand) :- length(Yard, Length), Length = 10, Hand is 2 .
findHand(Yard, Hand) :- length(Yard, Length), Length = 4, Hand is 3 .
findHand(Yard, Hand) :- length(Yard, Length), Length = 0, Hand is 4 .
findHand(_, Hand) :- Hand = 'corrupt data' .

%*********************************************************************
%Function Name: checkVal
%Purpose: Checks the value of the tile
%Parameters: A list containing the tile to be checked
%Return Value: Value containing the sum of the two pips on the tile
%Assistance Received: None.
%*********************************************************************

checkVal([_, Pip1, Pip2], Value) :- Value is Pip1 + Pip2.

%*********************************************************************
%Function Name: checkColor
%Purpose: Gets the color of the tile 
%Parameters: A list containing the tile to be checked
%Return Value: A character Value containing the color of the tile, or NIL if it failed to read
%Assistance Received: None.
%*********************************************************************

checkColor([Color|_], Value) :- Value = Color.

%*********************************************************************
%Function Name: checkDouble
%Purpose: Checks if the file is a double
%Parameters: A list containing the tile to be checked
%Return Value: Value true or false, indicating if the tile is a double
%Assistance Received: None.
%*********************************************************************

checkDouble([_, Pip1, Pip2], Value) :- Pip1 = Pip2, Value = true.
checkDouble([_, _, _], Value) :- Value = false.

%*********************************************************************
%Function Name: findAt
%Purpose: Finds the element at an index in a list
%Parameters: A list being searched
%                        Count, the index where the element should be
%Return Value: Ele, The element at that location
%Assistance Received: None.
%*********************************************************************
%findAt

findAt([First|_], Count, Ele) :- Count = 0, Ele = First.
findAt([_|Rest], Count, Ele) :- NewCount is Count - 1,
                                    findAt(Rest, NewCount, NewEle),
                                    Ele = NewEle.
%*********************************************************************
%Function Name: lowestValue
%Purpose: Finds the lowest tile of nonempty list
%Parameters: A list of tiles being searched
%Return Value: Value, The lowest tile in the list
%Assistance Received: None.
%*********************************************************************
%lowestValue
%checkVal


lowestValue([First|Rest], Value) :- Rest = [], Value = First.
lowestValue([First|Rest], Value) :- lowestValue(Rest, NewVal),
                                    checkVal(NewVal,Val1),
                                    checkVal(First, Val2),
                                    Val1 > Val2,
                                    Value = First.
lowestValue([First|Rest], Value) :- lowestValue(Rest, NewVal),
                                    checkVal(NewVal,Val1),
                                    checkVal(First, Val2),
                                    Val1 =< Val2,
                                    Value = NewVal.

%*********************************************************************
%Function Name: findEle
%Purpose: Finds the index of the first instance of an element
%Parameters: A list of tiles being searched
%                        Ele, the element being searched for
%                        Count, a counter variable that records the index. Should be set to 0 when first called.
%Return Value: Index containing the index of the element.
%Assistance Received: None.
%*********************************************************************
%findEle

%when element is found, return the count into index
findEle([First|_], Ele, Count, Index) :- First = Ele, Index = Count.
findEle([_|Rest], Ele, Count, Index) :- NewCount is Count + 1,
                                            findEle(Rest, Ele, NewCount, NewIndex),
                                            Index = NewIndex.

%------------------------------------data manipulation----------------------------------
%************************************************
%Source code to replace a tile at index 'loc' with 'newThing'
%************************************************
%*********************************************************************
%Function Name: replaceAt
%Purpose: Replaces an element from numList at index loc with newThing
%Parameters: A list of tiles
%            Loc, an atom containing the index where replacement will occur
%            NewThing, an atom containing the replacement element
%Return Value: The updated list
%Assistance Received: None.
%*********************************************************************
%replaceAt

%Look through the list until that index is reached and return whatever was before it, it, and whatever comes after
replaceAt([_|Rest], Loc, NewThing, NewList) :- Loc = 0, NewList = [NewThing|Rest].
replaceAt([First|Rest], Loc, NewThing, NewList) :- NewLoc is Loc-1, 
                                                   replaceAt(Rest, NewLoc, NewThing, NextList),
                                                   NewList = [First|NextList].

        
%************************************************
%Source code to shuffle a boneyard
%************************************************
%*********************************************************************
%Function Name: shuffle
%Purpose: Shuffles the boneyard
%Parameters: Boneyard, the list of tiles being shuffles
%                        Size, an atom containing the size of the boneyard
%                        Times, the number of times the function will recur
%Return Value: NewYard, A list containing the shuffle stacks
%Assistance Received: Andrew K.
%*********************************************************************
%findAt
%eliminate
%shuffle

%gets a random number between 0 and size-1, get the domino at that location, and bring it to the front
shuffle(Boneyard, _, Times, NewYard) :- Times = 0, NewYard = Boneyard.
shuffle(Boneyard, Size, Times, NewYard) :- NewSize is Size, 
                                           random(0, NewSize, TileNum),
                                           findAt(Boneyard, TileNum, Domino),
                                           eliminate(Boneyard, TileNum, LessYard),
                                           ShuffleYard = [Domino|LessYard],
                                           NewTimes is Times -1,
                                           shuffle(ShuffleYard, Size, NewTimes, NewerYard),
                                           NewYard = NewerYard.
                                                                                        
%*********************************************************************
%Function Name: eliminate
%Purpose: Removes an element at an index
%Parameters: A list the element is being removed from
%            Count, the index of where the numList is being removed from
%Return Value: NewList, The updated list
%Assistance Received: None.
%*********************************************************************
%eliminate

eliminate([_|Rest], Count, NewList) :- Count = 0, NewList = Rest.
eliminate([First|Rest], Count, NewList) :- NewCount is Count - 1,
                                           eliminate(Rest, NewCount, NextList),
                                          NewList = [First|NextList].
%*********************************************************************
%Function Name: draw
%Purpose: Gets the next Number of elements from a list
%Parameters: A list that is being drawn from
%            Number, the number of elements being drawn
%Return Value: Drawn, The list of tiles that were drawn
%Assistance Received: None.
%*********************************************************************
%draw

%should be used with mill/3 to remove tiles after they have been drawn.
draw([First|_], Number, Drawn) :- Number = 1 , Drawn = [First].
draw([First|Rest], _, Drawn) :- Rest = [], Drawn = [First].
draw([First|Rest], Number, Drawn) :- NewNum is Number -1, 
                                     draw(Rest,NewNum,NewList),
                                     Drawn = [First|NewList].
%*********************************************************************
%Function Name: mill
%Purpose: Removes the next Number of tiles from a list
%Parameters: NumList, the list of tiles being removed from
%                        Number, the number of tiles being removed
%Return Value: The updated list of tiles, now missing the top 'number' of elements
%Assistance Received: None.
%*********************************************************************
%mill

%throws away tiles until number = 1 is processed.
mill(NumList, _, Update) :- NumList = [], Update = [].
mill([_|Rest], Number, Update) :- Number = 1, Update = Rest.
mill([_|Rest], Number, Update) :- NewNum is Number - 1,
                                      mill(Rest, NewNum, NewList),
                                      Update = NewList.

									  
									  
%--------------------------------------------------Computer Player----------------------------------------------
%**************************************************
%Computer plays
%**************************************************
%*********************************************************************
%Function Name: aiPlay
%Purpose: The computer player makes moves
%Parameters: Stacks, the list containing the top tiles on the stacks
%			 Hands, the list containing the lists of the human and computer player's hands
%Return Value: Board ,A list containing: the new list of tiles on the stacks, and a list of lists of the new hands of the two players
%Assistance Received: None.
%*********************************************************************
%precedenceAI
%indexToStack
%replaceAt
%findEle
%eliminate

aiPlay(Stacks, Hands, Board) :- Hands = [HumHand, CompHand],
								precedenceAI(Stacks, CompHand, Move),
								Move = [_, Tile, Index],
								indexToStack(Index, StackName),
								write('Computer plays '),
								write(Tile),
								write(' on '),
								write(StackName), nl,
								%Updates the Stacks and Hands
								replaceAt(Stacks, Index, Tile, NewStacks),
								findEle(CompHand, Tile, 0, HandIndex),
								eliminate(CompHand, HandIndex, NewCompHand),
								Board = [NewStacks, [HumHand, NewCompHand]].

%**************************************************
%Determining what to play
%**************************************************
%*********************************************************************
%Function Name: precedenceAI
%Purpose: Prints the reason why the computer arrived that move
%Parameters: Stacks, a list containing the top tiles on the stacks
%			 PlayHand, a list containing the hand being played from
%Return Value: Move, A list containing the precedence of the move, the tiles being played, 
%					and the index where it is being played on, or false, if the move is illegal
%Assistance Received: None.
%*********************************************************************
%precedenceAll
%precedenceHigh

precedenceAI(Stacks, PlayHand, Move) :- precedenceAll(Stacks, PlayHand, 0, 0, PrecList),
										precedenceHigh(PrecList, BestMove),
										precedenceAI(BestMove, Move).
										/*(First = -99,
										Move = false;
										First < 0,
										write('Computer tries to minimize point loss'), nl,
										Move = BestMove;
										First = 0,
										write('Computer is forced to make no point gain'), nl,
										Move = BestMove;
										First = 1,
										write('Computer cannot make the stack value higher'), nl,
										Move = BestMove;
										First > 20,
										write('Computer plays for maximum point gain'), nl,
										Move = BestMove;
										First < 20,
										write('Computer plays to reset a stack'), nl,
										Move = BestMove).*/
precedenceAI(BestMove, Move) :- [First|_] = BestMove,
								First = -99,
								Move = false.
precedenceAI(BestMove, Move) :- [First|_] = BestMove,
								First < 0,
								write('Computer tries to minimize point loss'), nl,
								Move = BestMove.
precedenceAI(BestMove, Move) :- [First|_] = BestMove,
								First = 0,
								write('Computer is forced to make no point gain'), nl,
								Move = BestMove.
precedenceAI(BestMove, Move) :- [First|_] = BestMove,
								First = 1,
								write('Computer cannot make the stack value higher'), nl,
								Move = BestMove.
precedenceAI(BestMove, Move) :- [First|_] = BestMove,
								First > 20,
								write('Computer plays for maximum point gain'), nl,
								Move = BestMove.
precedenceAI(BestMove, Move) :- [First|_] = BestMove,
								First < 20,
								write('Computer plays to reset a stack'), nl,
								Move = BestMove.

/*precedenceAI(Stacks, PlayHand, Move) :- precedenceAll(Stacks, PlayHand, 0, 0, PrecList),
										precedenceHigh(PrecList, BestMove),
										[First|_] = BestMove,
										First < 0,
										write('Computer tries to minimize point loss'), nl,
										Move = BestMove.
precedenceAI(Stacks, PlayHand, Move) :- precedenceAll(Stacks, PlayHand, 0, 0, PrecList),
										precedenceHigh(PrecList, BestMove),
										[First|_] = BestMove,
										First = 0,
										write('Computer is forced to make no point gain'), nl,
										Move = BestMove.
precedenceAI(Stacks, PlayHand, Move) :- precedenceAll(Stacks, PlayHand, 0, 0, PrecList),
										precedenceHigh(PrecList, BestMove),
										[First|_] = BestMove,
										First = 1,
										write('Computer cannot make the stack value higher'), nl,
										Move = BestMove.
precedenceAI(Stacks, PlayHand, Move) :- precedenceAll(Stacks, PlayHand, 0, 0, PrecList),
										precedenceHigh(PrecList, BestMove),
										[First|_] = BestMove,
										First > 20,
										write('Computer plays for maximum point gain'), nl,
										Move = BestMove.
precedenceAI(Stacks, PlayHand, Move) :- precedenceAll(Stacks, PlayHand, 0, 0, PrecList),
										precedenceHigh(PrecList, BestMove),
										[First|_] = BestMove,
										First < 20,
										write('Computer plays to reset a stack'), nl,
										Move = BestMove.
*/
%***************************************************
%Find highest precedence
%***************************************************
%*********************************************************************
%Function Name: precedenceHigh
%Purpose: Finds the move with the highest precedence
%Parameters: PrecedenceList, a list containing the precedence, the tile being played, and the index being played on, for every combination of tiles and indices
%Return Value: Move, A list of (precedence of the move, the tile being played, the index being played on)
%Assistance Received: None.
%*********************************************************************
%precedenceHigh

precedenceHigh([First|Rest], Move) :- Rest = [], Move = First.													
precedenceHigh([First|Rest], Move) :- precedenceHigh(Rest, NewMove),
									[HighPrec| _] = NewMove,
									First = [FirstPrec|_],
									(HighPrec > FirstPrec,
									Move = NewMove;
									HighPrec =< FirstPrec, 
									Move = First).
/* precedenceHigh([First|Rest], Move) :- precedenceHigh(Rest, NewMove),
									[HighPrec| _] = NewMove,
									First = [FirstPrec|_],
									HighPrec =< FirstPrec, 
									Move = First.					
*/
%***************************************************
%Creates an array of precedence
%***************************************************
%*********************************************************************
%Function Name: precedenceAll
%Purpose: Finds the precedence of every combination of tiles and indices
%Parameters: Stacks, a list containing the top tiles of the stacks
%			 PlayHand, the list containing the tiles in the hand being played from
%			 Stackindex, the index on the stack to begin at. Should be set to zero.
%			 Handindex, the index in the hand to begin at. Should be set to zero.
%Return Value: A list containing the precedence, the tile being played, and the index being played on, for every combination of tiles and indices
%Assistance Received: None.
%*********************************************************************
%findAt
%precedence
%precedenceAll

%If the hand has been exhausted, return empty list
precedenceAll(_, PlayHand, _, Handindex, PrecedenceList) :- 
			length(PlayHand, HandSize),
			HandSize = Handindex,
			PrecedenceList = [].
%If the stack has been exhausted, start from the beginning of the stacks with the next tile in hand
precedenceAll(Stacks, PlayHand, Stackindex, Handindex, PrecedenceList) :-
			length(Stacks, StackMax),
			Stackindex = StackMax,
			NewHandindex is Handindex + 1,
			precedenceAll(Stacks, PlayHand, 0, NewHandindex, NewPrecList),
			PrecedenceList = NewPrecList.
precedenceAll(Stacks, PlayHand, Stackindex, Handindex, PrecedenceList) :-
			findAt(PlayHand, Handindex, HandTile),
			precedence(Stacks, Stackindex, HandTile, Prec),
			NewStackindex is Stackindex + 1,
			precedenceAll(Stacks, PlayHand, NewStackindex, Handindex, NewPrecList),
			PrecedenceList = [[Prec, HandTile, Stackindex]|NewPrecList].
			
			

%***************************************************
%Finds precedence
%***************************************************
%*********************************************************************
%Function Name: precedence
%Purpose: Finds the precedence of a tile at a index on the stacks
%Parameters: Stacks, a list containing the top tiles of the stacks
%			 StackIndex, an atom containing the index of the tile being played one
%			 HandTile, the tile being played
%Return Value: Prec, The precedence of the move
%Local Variables: None
%Algorithm: Checks if the tile being played is smaller.
%				If yes, check the if the hand tile is a double
%				If no, return -99, as tile cannot be played
%				If both tiles are doubles, return -99, as tile cannot be played
%				Otherwise, check if the tiles are the same color
%					If yes, precedence = the value of the tile in hand - the value of the tile on the stack
%					If no, precedence = the value of the tile on the stack -  the value of the tile in hand
%				If both tiles are equal value:
%					If both tiles are doubles, return -99, as tile cannot be played
%					If both tiles are the same color, return 0, as there is no net score change
%					Otherwise, return 1, as the point gain is minimal
%				If the tile in hand is bigger:
%					If both tiles are the same color, precedence = the value of the tile on the stack -  the value of the tile in hand
%					If the tile in hand is a double, precedence = the value of the tile in hand - the value of the tile on the stack
%					Otherwise, precedence = 20 + precedence = the value of the tile in hand - the value of the tile on the stack
%Assistance Received: Andrew K.
%*********************************************************************
%checkVal
%findAt
%checkDouble
%checkColor




precedence(Stacks, StackIndex, HandTile, Prec) :-  
				checkVal(HandTile, HandVal),
				findAt(Stacks, StackIndex, StackTile),
				checkVal(StackTile, StackVal),
				checkDouble(HandTile, HandDouble),
				checkDouble(StackTile, StackDouble),
				checkColor(HandTile, HandColor),
				checkColor(StackTile, StackColor),
				precedence(Stacks, StackIndex, HandTile, HandVal, StackVal, HandDouble, StackDouble, HandColor, StackColor, Prec).
				
precedence(_, _, _, HandVal, StackVal, HandDouble, StackDouble, _, _, Prec) :- 	
				HandVal =< StackVal,
				HandDouble = true,
				StackDouble = true,
				Prec = -99.
precedence(_,_,_, HandVal, StackVal, HandDouble, _, _, _, Prec) :- 
				HandVal < StackVal,
				HandDouble = false,
				Prec = -99.
precedence(_,_,_, HandVal, StackVal, HandDouble, StackDouble, HandColor, StackColor, Prec) :- 
				HandVal < StackVal,
				HandDouble = true,
				StackDouble = false,
				HandColor = StackColor,
				Prec is HandVal - StackVal.
precedence(_,_,_, HandVal, StackVal, HandDouble, StackDouble, HandColor, StackColor, Prec) :- 
				HandVal < StackVal,
				HandDouble = true,
				StackDouble = false,
				HandColor \= StackColor,
				Prec is StackVal - HandVal.
precedence(_,_,_, HandVal, StackVal, _, _, HandColor, StackColor, Prec) :- 
				HandVal = StackVal,
				HandColor = StackColor,
				Prec = 0.
precedence(_,_,_, HandVal, StackVal, _, _, HandColor, StackColor, Prec) :- 
				HandVal = StackVal,
				HandColor \= StackColor,
				Prec = 1.
precedence(_,_,_, HandVal, StackVal, _, _, HandColor, StackColor, Prec) :- 
				HandVal > StackVal,
				HandColor = StackColor,
				Prec is StackVal - HandVal.
precedence(_,_,_, HandVal, StackVal, HandDouble, _, HandColor, StackColor, Prec) :- 
				HandVal > StackVal,
				HandColor \= StackColor,
				HandDouble = true,
				Prec is HandVal - StackVal.
precedence(_,_,_, HandVal, StackVal, HandDouble, _, HandColor, StackColor, Prec) :- 
				HandVal > StackVal,
				HandColor \= StackColor,
				HandDouble = false,
				Prec is 20 + HandVal - StackVal.

%*********************************************************************
%Function Name: wantHelp
%Purpose: Prompts if the user wishes to receives help
%Parameters: Stacks, the list of tiles on the top of the stacks
%			 Hands, the list containing the human player's hand and the computer player's hand.
%Return Value: none
%Assistance Received: None.
%*********************************************************************
%read
%validYN
%precedenceAI
%indexToStack

wantHelp(Stacks, Hands) :- write('Do you want help? (y./n.)'), nl,
							read(Input),
							validYN(Input, Return),
							Return = 'y',
							Hands = [HumHand, _],
							precedenceAI(Stacks, HumHand, Move),
							Move = [_, Tile, Index],
							indexToStack(Index, StackName),
							write('Computer recommends '),
							write(Tile),
							write(' on '),
							write(StackName),
							nl.
wantHelp(_, _) :- true.							
%--------------------------------------------SERIALIZATION----------------------------------------------
%*********************************************************************
%Function Name: saveYN
%Purpose: Validates user input if they want to save
%Parameters: Player, an atom that keeps track of whose turn it is. 1 for human. 2 for computerWins
%			 Yards, a list of two lists containing human Boneyard, computer Boneyard
%			 Stacks, a list of the top tiles of the stack. The first 6 elements are the human's side. The last 6 are the computer's side.
%			 Hands, a list containing the player's hands as two lists
%			 Scores, a list containing the player's scores
%			 Wins, a list containing the number of rounds each player as won
%Return Value: None
%Assistance Received: Andrew K.
%*********************************************************************
%read
%validYN
%saveGame

saveYN(Player, Yards, Stacks, Hands, Scores, Wins) :- 
		write('Do you wish to save? (y./n.)'), nl,
		read(Input),
		validYN(Input, Return),
		Return = 'y',
		saveGame(Player, Yards, Stacks, Hands, Scores, Wins),
		write('Saving and exiting...'), nl,
		abort.
saveYN(_, _, _, _, _, _) :- true.

%*************************************************
%Source code to save file
%*************************************************
%*********************************************************************
%Function Name: saveGame
%Purpose: Saves the game to a file
%Parameters: Player, an atom that keeps track of whose turn it is. 1 for human. 2 for computerWins
%			 Yards, a list of two lists containing human Boneyard, computer Boneyard
%			 Stacks, a list of the top tiles of the stack. The first 6 elements are the human's side. The last 6 are the computer's side.
%			 Hands, a list containing the player's hands as two lists
%			 Scores, a list containing the player's scores
%			 Wins, a list containing the number of rounds each player as won
%Return Value: None
%Assistance Received: None.
%*********************************************************************
%read
%telling
%tell
%told
%draw

%TODO what happens when filename is bad

saveGame(Player, [HumYard, CompYard], Stacks, [HumHand, CompHand], [HumScore, CompScore], [HumWins, CompWins]) :- 
		Stacks = [A,B,C,E,F,G|CompStack],
        HumStack = [A,B,C,E,F,G],
		write('Enter a file name'), nl,
		read(Input),
		telling(_),
		tell(Input),
		Player = 1,
		PTurn = 'human',
		Output = [[CompStack, CompYard, CompHand, CompScore, CompWins],[HumStack, HumYard, HumHand, HumScore, HumWins], PTurn],
		write(Output), write('.'),
		told, tell(user).
saveGame(Player, [HumYard, CompYard], Stacks, [HumHand, CompHand], [HumScore, CompScore], [HumWins, CompWins]) :- 
		Stacks = [A,B,C,E,F,G|CompStack],
        HumStack = [A,B,C,E,F,G],
		Player = 2,
		PTurn = 'computer',
		Output = [[CompStack, CompYard, CompHand, CompScore, CompWins],[HumStack, HumYard, HumHand, HumScore, HumWins], PTurn],
		write(Output), write('.'),
		told, tell(user).

%*************************************************
%Source code to open file to load
%*************************************************
%*********************************************************************
%Function Name: loader
%Purpose: gets the name of the file to load from
%Parameters: none
%Return Value: None
%Assistance Received: none.
%*********************************************************************
loader :- write('Enter a file name: '),
			read(Input),
			seeing(_),
			see(Input),
			read(Data),
			loadGame(Data).
			
%*********************************************************************
%Function Name: loadGame
%Purpose: loads the game from a file
%Parameters: Data, the data from file
%Return Value: None
%Assistance Received: none.
%*********************************************************************
		%read
		%open
%playTurn	%loadGame
%close		%close

%TODO bad filenames

loadGame(Data) :- 
			Data = [[CompStack, CompYard, CompHand, CompScore, CompWins],[HumStack, HumYard, HumHand, HumScore, HumWins], PTurn],
			append(HumStack, CompStack, Stacks),
			PTurn = 'human',
			Player = 1,
			seen,
			see(user),
			playTurn(Player, [HumYard, CompYard], Stacks, [HumHand, CompHand], [HumScore, CompScore], [false,false], [HumWins, CompWins]).
loadGame(Data) :- 
			Data = [[CompStack, CompYard, CompHand, CompScore, CompWins],[HumStack, HumYard, HumHand, HumScore, HumWins], PTurn],
			PTurn = 'computer',
			Player = 2,
			append(HumStack, CompStack, Stacks),
			seen, see(user),
			playTurn(Player, [HumYard, CompYard], Stacks, [HumHand, CompHand], [HumScore, CompScore], [false,false], [HumWins, CompWins]).
loadGame(Data) :- 
			Data = [[CompStack, CompYard, CompHand, CompScore, CompWins],[HumStack, HumYard, HumHand, HumScore, HumWins] | _],
			Player = 0,
			append(HumStack, CompStack, Stacks),
			seen, see(user),
			playTurn(Player, [HumYard, CompYard], Stacks, [HumHand, CompHand], [HumScore, CompScore], [false,false], [HumWins, CompWins]).
			
			
			
			