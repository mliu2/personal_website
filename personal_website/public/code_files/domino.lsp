	; ************************************************************
	; * Name:  Ming Liu                                          *
	; * Project:  Project 2, LISP Buildup Dominoes               *
	; * Class:  CMPS 366 Organization of Programming Languages   *
	; * Date:  10/17/14                                          *
	; ************************************************************

;*********************************************
;Source Code to create a tournament 
;*********************************************
;*********************************************************************
;Function Name: tournament
;Purpose: Start point of build up game
;Parameters: None
;Return Value: atom 'Exiting, indicating the program is exiting
;Assistance Received: None
;*********************************************************************
;readnum12
;newGame
;loadGame
(defun tournament ()
	(princ "=============================")
	(princ "Welcome to Build-Up Dominoes")
	(princ "=============================")
	(terpri)
	(princ "1. New Game")
	(terpri)
	(princ "2. Load Game")
	(terpri)
	;catches save from saveYN to exit game
	(catch 'saved
	;read and validate input
		(let ((input (readnum12)))
			(cond ((eq input 1)
					(newGame (list 0 0)))
				  ((eq input 2)
					(loadGame )))))'Exiting)
;*********************************************************************
;Function Name: tourWin
;Purpose: Informs user which play has won the tournament
;Parameters: Wins, a list containing the number of wins the human and computer player have
;Return Value: The string displayed informing user of the player that won the tournament
;Assistance Received: None.
;*********************************************************************
(defun tourWin (Wins) 
	(cond ( (> (first Wins) (second Wins)) 
				(princ "You Win the Tournament!"))
		  ( (< (first Wins) (second Wins)) 
				(princ "Computer Wins the Tournament."))
		  ( (= (first Wins) (second Wins)) 
				(princ "NOBODY WINS ON MY WATCH!")))
)
;----------------------------Game Processes------------------
;************************************************
;Source code to start a new game
;************************************************
;*********************************************************************
;Function Name: newGame
;Purpose: To set up parameters a new game 
;Parameters: Wins, a list (humanWins computerWins)
;Return Value: T, from (terpri) from endgame from newHand
;Assistance Received: None
;*********************************************************************
;makeBoneyard
;shuffle
;makeNewStack
;mill
;compareTop
;goFirst
;newHand
(defun newGame(Wins)
	(let* ((humanStartYard (shuffle (makeBoneyard #\B 6 6 ) 28 30))
		  (CPUStartYard (shuffle (makeBoneyard #\W 6 6 ) 28 30))
		  ;makes the list stacks with the 6 human stacks and 6 computer stacks, in that order
		  (Stacks (append (makeNewStack humanStartYard)(makeNewStack CPUStartYard)))
		  ;removes the top six tiles from each boneyard, because they have been used to make stacks
		  (humanYard (mill humanStartYard 6))
		  (CPUYard (mill CPUStartYard 6))
		  ;shuffles until the top tiles are not the same value
		  (Yards (compareTop humanYard CPUYard))
		  ;determines which player goes first, 1 is human , 2 is computer
		  (player (goFirst (first Yards) (first (rest Yards))))
		  )
		  ;initiates new hand
		  (newHand player Yards Stacks (list (list 0) (list 0)) (list NIL NIL) Wins)
	)
)
;*********************************************
;Source Code to create a boneyard of dominoes
;*********************************************
;*********************************************************************
;Function Name: makeBoneyard
;Purpose: to construct the boneyard 
;Parameters: color, the character W or B, indicating the color of the tile
;			 pip1, the maximum value of the first pip. Should be 6.
;			 pip2, the maximum value of the second pip. Should be 6.
;Return Value: The average grade in the class, a real value
;Assistance Received: None
;********************************************************************* 
;makeBoneyard
(defun makeBoneyard ( color pip1  pip2 )
	(cond ( ( = pip2 0 ) 
			;if pip2 is 0, then the recursion has ended return the 0-0 domino
			(list( list color pip1 pip2 ) ))
		( ( = pip1 0 )
			;if pip1 is 0, make the domino of those pips, decrease pip2 and set both equal to that value
			( cons  (list color pip1 pip2)( makeBoneyard color ( - pip2 1 ) ( - pip2 1 ) ) ))
		( t 
			;makes the domino of those pips, then make another one with a decremented pip1
			( cons  (list color pip1 pip2)( makeBoneyard color ( - pip1 1)  pip2))) ) )
 

;***********************************************
;Source code compares value top of boneyards and shuffles until they are not equal
;***********************************************
;*********************************************************************
;Function Name: compareTop
;Purpose: Compares the top of two lists containing each of the boneyards, and shuffles if they are the same
;Parameters: numList1, a list containing tiles of the human's boneyard.
;			 numList2, a list containing tiles of the computer's boneyard.
;Return Value: a list containing the lists of the boneyards of the human and computer player's boneyards
;Assistance Received: none.
;*********************************************************************
;checkVal
;shuffle
;compareTop
(defun compareTop (numList1 numList2)
	(princ "Your first tile: ")
	(princ (first numList1 ))
	(terpri)
	(princ "Computer's first tile: ")
	(princ (first numList2))
	(terpri)
	;if the top of the boneyards are not the same value, then return them
	(cond ((< (checkVal (first numList1 )) (checkVal (first numList2)))
			(list numList1 numList2))
		   ((> (checkVal (first numList1)) (checkVal (first numList2))) 
			(list numList1 numList2))
			;else keep shuffling
		   ((= (checkVal (first numList1)) (checkVal (first numList2)))
			 (princ "Tied first tile: shuffling...")
			 (terpri)
			 (compareTop (shuffle numList1 (length numList1) 1) (shuffle numList2 (length numList2) 1)))))
		
;************************************************
;Source code for determining whose turn comes first, 1 for P1, 2 for P2
;************************************************
;*********************************************************************
;Function Name: goFirst
;Purpose: Checks which player goes first
;Parameters: numList1, a list containing tiles of the human's boneyard.
;			 numList2, a list containing tiles of the computer's boneyard.
;Return Value: an atom of value 1 or 2, indicating which player goes first. 1 is human. 2 is computer
;Assistance Received: None.
;*********************************************************************
;checkVal
(defun goFirst (numList1 numList2)
	;if human player's tile is bigger, human goes first
	(cond ((> (checkVal (first numList1)) (checkVal (first numList2))) 
			(princ "Your go first")
			(terpri) 1)
			;if human player's tile is smaller, computer goes first
		   ((< (checkVal (first numList1)) (checkVal (first numList2))) 
			(princ "Computer goes first")
			(terpri) 2)))
;***********************************************
;Source code to make new stacks
;************************************************
;*********************************************************************
;Function Name: makeNewStack
;Purpose: Gets the top 6 tiles off of a boneyard to create one player's stacks
;Parameters: numList, a list containing tiles that form one player's boneyard
;Return Value: A list containing the tiles that form one player's stacks
;Assistance Received: None.
;*********************************************************************
;draw
(defun makeNewStack(numList)
	;six being the number of stacks
	(draw numList 6)) 
;*********************************************
;Source code for creating new hands
;*********************************************
;*********************************************************************
;Function Name: newHand
;Purpose: Sets up the parameters for playing a brand new hand
;Parameters: player, an atom that keeps track of whose turn it is. 1 for human. 2 for computerWins
;			 Boneyards, a list of two lists containing human Boneyard, computer Boneyard
;			 Stacks, a list of the top tiles of the stack. The first 6 elements are the human's side. The last 6 are the computer's side.
;			 Hands, a list containing the player's hands as two lists
;			 Scores, a list containing the player's scores
;			 Wins, a list containing the number of rounds each player as won
;Return Value: T, from (terpri) from endGame()
;Local Variables: winner, an atom of value 1,2, or 0 that will tell which player won
;				  handlist, a list of the lists holding human player's hand and computer player's hand
;				  scorelist, a list of two atoms holding the score for human player and computer player
;Algorithm: If the boneyards are empty, the final scores will be displayed and the wins updated. endGame is then called.
;			If the boneyards are not empty, create a new list of hands and list of scores. If no hand is dealt, the score is set to '(0 0)
;			Playturn is then called with a boneyard with 6 fewer tiles from the top.
;Assistance Received: None
;*********************************************************************
;getScore
;endGame
;---or---
;draw
;findHand
;playTurn
(defun newHand (player Boneyards Stacks Hands Scores Wins)
	(cond ((and (null(first Boneyards)) (null(second Boneyards)))
					;if both hands are empty, the game has ended, so display scores
					(princ "Your final score: ")
					(princ (+ (first Scores)(first (getScore Stacks Hands))))
					(terpri)
					(princ "Computer's final score: ")
					(princ (+ (second Scores)(second (getScore Stacks Hands))))
					(terpri)
					;sets and prints the winner, 1 is human, 2 is computer, 0 is draw.
					(let (( winner (cond ( (> (+ (first Scores)(first (getScore Stacks Hands))) (+ (second Scores)(second (getScore Stacks Hands))))
									(princ "You win! ") 1)
							( (< (+ (first Scores)(first (getScore Stacks Hands))) (+ (second Scores)(second (getScore Stacks Hands))))
									(princ "Computer wins. ") 2)
							( (equal (+ (first Scores)(first (getScore Stacks Hands))) (+ (second Scores)(second (getScore Stacks Hands))))
									(princ "The game was a tie. ") 0))))
						;updates the list Wins based on who won
						(cond ( (= winner 1) 
							(endGame (list (+ (first Wins) 1)(second Wins))))
						( (= winner 2) 
							(endGame(list (first Wins) (+ (second Wins) 1))))
						( (= winner 0)
							(endGame Wins)))))
					;draw a new hand of up to 6, as specified by the rules
		  (t (let ( (handlist (list (draw (first Boneyards) 6) (draw (first(rest Boneyards)) 6)))
					;if the game has not begun, set both scores to 0
					(scoreList (cond ((= (findHand (first Boneyards)) 0) 
									(list 0 0))
								;otherwise get the score from the current hand and add to the previous score
								( t (list (+ (first Scores) (first(getScore Stacks Hands))) (+ (second Scores) (second(getScore Stacks Hands))))))))
								;allows the next player to play, updates the boneyards and hands, and resets the pass list so neither player passed.
						(cond ((= player 1)	
									(playTurn 1	(list (mill (first Boneyards) 6)(mill (first (rest Boneyards)) 6)) Stacks handlist scoreList (list NIL NIL) Wins))
							  ((= player 2)	
									(playTurn 2 (list (mill (first Boneyards) 6)(mill (first (rest Boneyards)) 6)) Stacks handlist scoreList (list NIL NIL) Wins)))))))

;**********************************************
;Source code for printing Board state
;**********************************************
;*********************************************************************
;Function Name: printBoard
;Purpose: Prints the board state 
;Parameters: Yards, a list of lists containing the human player and computer player's boneyards
;			 Stacks, a list of the top tiles on the stack
;			 Hands, a list of lists containing the human player and computer player's hands
;			 Scores, a list of the human and computer player's scores
;			 Wins, a list of the human and computer player's number of wins
;Return Value: T, from (terpri)
;Assistance Received: None
;*********************************************************************
;findHand
;draw
(defun printBoard (Yards Stacks Hands Scores Wins)
	(princ "Hand: ")
	;finds the number of hands
	(princ (findHand (first Yards)))
	(terpri)
	(princ "Computer's Rounds Won: ")
	;gets the number of rounds the computer has won
	(princ (second Wins))
	(terpri)
	(princ "Computer's Score: ")
	;gets the computer's scores
	(princ (first (rest Scores)))
	(terpri)
	;gets last six in Stacks in correct order
	(princ (reverse(draw (reverse Stacks) 6)))
	(terpri)
	;formating so the labels match the tiles
	(princ "    W1      W2      W3      W4      W5      W6  ")
	(terpri)
	;gets the first size stacks in order
	(princ (draw Stacks 6))
	(terpri)
	(princ "    B1      B2      B3      B4      B5      B6  ")
	(terpri)
	;separate hand from board
	(princ "------------------------------")
	(terpri)
	;gets the human player's hand
	(princ (first Hands))
	(terpri)
	(princ "    0       1        2       3       4       5  ")
	(terpri)
	(princ "Your Score: ")
	;gets the human player's score
	(princ (first Scores))
	(terpri)
	(princ "Your Rounds Won: ")
	;gets the number of rounds the human player has won
	(princ (first Wins))
	(terpri)
)


;**********************************************
;Source code for playing turn
;**********************************************
;*********************************************************************
;Function Name: playTurn
;Purpose: Lets the human or computer play
;Parameters: Yards, a list of lists containing the human player and computer player's boneyards
;			 Stacks, a list of the top tiles on the stack
;			 Hands, a list of lists containing the human player and computer player's hands
;			 Scores, a list of the human and computer player's scores
;			 Passes, a list containing a list of which player passed
;			 Wins, a list of the human and computer player's number of wins
;Local Variables: nYards, a list of lists containing the human player and computer player's boneyards
;				  nPlayer, an atom containing a value to determine the next player
;				  board, a list of lists of lists containing the Stacks and the new Hands after human player plays
;				  compChange, a list of lists of lists containing the Stacks and the new Hands after the computer plays
;Algorithm: If player is set to 0 (undetermined), get which player goes first, draw new hands
;			If both players passes or if both hands are empty, call newHand
;			Otherwise, 
;				If human is going, print board and ask if the user wants to save
;					Checks if the player must pass. If the yes, pass to next player
;					Ask user for input and update stacks and hands and pass to next player
;				If computer is going, print board and ask if the user wants to save
;					Checks if the player must pass. If the yes, pass to next player
;					Otherwise, call AIPlay to let computer play
;Return Value: T, from (terpri) from endGame from newHand
;Assistance Received: None
;*********************************************************************
;newHand
;---or---
;printBoard
;saveYN
;canPass
;wantHelp
;readnum05
;inputStack
;playTurn
;---or---
;printBoard
;saveYN
;canPass
;AIPlay
;playTurn
(defun playTurn (player Yards Stacks Hands Scores Passes Wins)
	;if player = 0 (undetermined), then check who goes first and start a new hand.
	(cond ( (equal player 0) 
			(let* ( (nYards (compareTop (first Yards) (second Yards)))
					(nPlayer (goFirst (first nYards) (first (rest nYards)))))
				  (newHand nPlayer nYards Stacks Hands Scores Wins)))
			;if both players passed or if both hands are empty, then start a new hand.
		  ( (or(equal Passes (list t t)) (and (null (first Hands)) (null(second Hands))))
			(newHand player Yards Stacks Hands Scores Wins))
		  
		  (t 
			(cond ( (= player 1)
						(princ "==============================")
						(terpri)
						(princ "Your Turn!")
						(terpri)
						;Displays the board.
						(printBoard Yards Stacks Hands Scores Wins)
						;Prompt user if they want to save
						(saveYN player Yards Stacks Hands Scores Wins)
						;Check if the human must pass.
						(cond ((or (null(first Hands)) (canPass Stacks (first Hands)))
									(princ "You must pass")
									(terpri)
									;If the human must pass, do so and set pass list accordingly
									(playTurn 2 Yards Stacks Hands Scores (replaceAt Passes 0 t) Wins))
							  (t 
									;Prompt user if they want help
									(wantHelp Stacks Hands)
									(let ( (board (inputStack Stacks Hands (readnum05 (length (first Hands))))))
									(cond ( (equal board NIL)
											;If the input was unsuccessful, then retry this turn.
											(playTurn 1 Yards Stacks Hands Scores Passes Wins))
										  (t 
											;Otherwise, update the Stacks and Hands, allowed computer to play, and set the Human to not passing
											(playTurn 2 Yards (first board) (first (rest board)) Scores (replaceAt Passes 0 NIL) Wins)))))))
				  ( (= player 2) 
						(princ "==============================")
						(terpri)
						(princ "Computer's Turn!")
						(terpri)
						;Displays the board
						(printBoard Yards Stacks Hands Scores Wins)
						;Prompt user if they want to save
						(saveYN player Yards Stacks Hands Scores Wins)
						(cond ( (or (null(second Hands)) (canPass Stacks (second Hands))) 
								;If computer must pass, do so.
								(princ "Computer passes")
								(terpri)
								;allow human to play and set pass list accordingly.
								(playTurn 1 Yards Stacks Hands Scores (replaceAt Passes 1 t) Wins)
								)
							  (t (let ( (compChange (AIPlay Stacks Hands)))
									;Computer makes a play, allows human to play, updates the Stacks and Hands, and sets the computer's pass to NIL (did not pass)
									(playTurn 1 Yards (first compChange) (first (rest compChange)) Scores (replaceAt Passes 1 NIL) Wins))
								  )
						)
				   )
			)
	))
)

;*********************************************
;Source code to ask if user wants to keep playing
;*********************************************
;*********************************************************************
;Function Name: endGame
;Purpose: Displays the number of rounds each player has won and prompts user if user wants to play again
;Parameters: Wins, a list containing the number of wins the human and computer player have
;Return Value: T, from (terpri)
;Assistance Received: None.
;*********************************************************************
;readnum12
;newGame
;tourWin
(defun endGame (Wins)
				(princ "Your rounds won: ")
				;Gets the number of rounds human has won
				(princ (first Wins))
				(terpri)
				(princ "Computer's rounds won: ")
				;Gets the number of rounds the computer has won
				(princ (second Wins))
				(terpri)
				(princ "Play again?")
				(terpri)
				(princ "1. Yep")
				(terpri)
				(princ "2. Nope")
				(terpri)
				;Validate user input.
				(let ( (input (readnum12)))
					(cond ( (equal input '1) 
							;Creates a new game and passes the number of rounds each player has won
							(newGame Wins))
						  ( (equal input '2)
							;Calls tourWin to display who won the tournament
							(tourWin Wins)
							(terpri)))))
;*********************************************
;Source code for finding score at the end of the round
;*********************************************
;*********************************************************************
;Function Name: getScore
;Purpose: gets the score from the current board
;Parameters: Stacks, a list of the top tiles of the stack. The first 6 elements are the human's side. The last 6 are the computer's side.
;Return Value: A list with human's score and computer's score
;Assistance Received: Non
;*********************************************************************
;sumtiles
(defun getScore(Stacks Hands)
	;Does not add to total score, only gets the points from the current hand and stacks
	;Returns list scores (playerscore cpuscore) 
	(list (- (sumTiles Stacks #\B) (sumTiles (first Hands) #\B)) (- (sumTiles Stacks #\W) (sumTiles (first (rest Hands)) #\W)))
)
;*********************************************
;Source code for getting the sum of all tiles in a list
;*********************************************
;*********************************************************************
;Function Name: sumTiles
;Purpose: Sums the values of all of the tiles in a list of a given color
;Parameters: numList, the list of tiles to be searched. Tiles should be lists containing color, pip1, and pip2.
;			 color, a character 'W or 'B that the function will look for.
;Return Value: An atom of the sum of all of the tiles in the list of the given color
;Assistance Received: None
;*********************************************************************
; BUG : 0 appears at end of list	

;checkColor
;checkVal
;sumTiles
(defun sumTiles(numList color)
	;if the list is empty at any point, end the recursion and return 0
	(cond (( null(first numList)) 
					  0) 
		  (t 
						;if the tile is of the specified color, add its value to the value of the rest of the list
				(cond ((equal (checkColor (first numList)) color)
							(+ (checkVal (first numList)) (sumTiles (rest numList) color)))
							;if the tile is not of the specified, get the value of the rest of the list
					  (t (sumTiles (rest numList) color)))))
)
;-----------------------------Validators---------------------------------------
;*********************************************
;Source Code to take in numbers 1-2
;*********************************************
;*********************************************************************
;Function Name: readnum12
;Purpose: To prompt user for input for integer between 1 and 2
;Parameters: None
;Return Value: an integer between 1 and 2 
;Assistance Received: None
;*********************************************************************
;read
;valid12
(defun readnum12 ()
	(princ "Please enter a number from the menu: ")
	(terpri)
	;Reads and validates the input
	(valid12 (read)))
;*********************************************
;Source Code to validate the input for numbers 1-2
;*********************************************
;*********************************************************************
;Function Name: valid12
;Purpose: To validate that the input is either 1 or 2
;Parameters: num, an integer passed in from readnum12()
;Return Value: A number between 1 and 2
;Assistance Received: None
;*********************************************************************
;readnum12
(defun valid12 (num)
	;if the input number is less than 1 or greater than 2, ask again for input
	(cond ( ( < num 1 )
			(readnum12))
			( ( > num 2)
			(readnum12))
			;else, return the input
			(t num)))

;**********************************************
;Source code for reading user input of stack name
;***********************************************
;*********************************************************************
;Function Name: inputStack
;Purpose: validates user input for stack and checks if the player is legal
;Parameters: Stacks, a list of tiles containing the stacks
;			 Hands, a list of lists containing the human and computer player's hands
;			 handtile, a list containing the tile being played
;Return Value: a list containing the list containing the updated stack and the list containing the updated hands.
;Assistance Received: None
;*********************************************************************
;findAt
;stackToIndex
;tryplay
;replaceAt
;eliminate
(defun inputstack(Stacks Hands handtile)
	(princ "Please enter a stack name: ")
	(let ( ( input (read))
			;finds the tile at that stack location
		   ( tile (findAt(first Hands) handtile)))
		(terpri)
			;if the input cannot be translated, then ask for a new stack name
		(cond ( ( equal (stackToIndex input) NIL) 
				(princ "Invalid stack name")
				(inputstack Stacks Hands handtile))
				;if the input is an illegal play, return NIL, which playTurn recognizes as the signal to retry the current turn
			  ( ( equal (tryplay Stacks tile (stackToIndex input)) NIL) 
				(princ "invalid move")
				(terpri)
				NIL)
			  ( t 
				;Display's the user's play
				(princ "You played ")
				(princ tile)
				(princ " on ")
				(princ input)
				(terpri)
				;Returns list of (Stacks Hands) for playTurn to update
				(list (replaceAt Stacks (stackToIndex input) tile)(list (eliminate (first Hands) handtile) (first (rest Hands))))))))
;**********************************************
;Source code for translating stack name to index
;*********************************************
;*********************************************************************
;Function Name: stackToIndex
;Purpose: translate the user's input of stack name to the index on the stack list
;Parameters: input, an atom containing the input from inputStack()
;Return Value: An atom containing the index on the stack list, or nil if the input could not be translated
;Assistance Received: Nonce
;*********************************************************************
(defun stackToIndex (input)
	(let ((side (char (string input) 0)))
		;Second character of input must be a digit between 1 and 7
		(cond ( (and (< (digit-char-p (char (string input) 1)) 7)(> (digit-char-p (char (string input) 1)) 0))
				(cond ( (eq side #\W) 
						;Translate to an index between 6 and 11
						(+ 5 (digit-char-p (char (string input) 1))))
					  ( (eq side #\B) 
						;Translate to an index between 0 and 5
						(+ -1 (digit-char-p (char (string input) 1))))
					  (t 
						;if the first character is not W or B, return NIL (failure to translate)
					     NIL)))
			  (t 
				;if second character of input is not between 1 and 7, return NIL (failure to translate)
				NIL) )))
;******************************************************
;Source code for translating index to stack name
;*******************************************************
;*********************************************************************
;Function Name: indexToStack
;Purpose: Translates the index on the stack list into human readable stack names
;Parameters: input, an atom containing the index on the stack list
;Return Value: an atom containing the stack name
;Assistance Received: None.
;*********************************************************************
(defun indexToStack (input)
	(cond ( (>= input 6) 
				;Input above or equal to 6 is W side
				(list #\W (- input 5)))
			
		  (t 
				;Input below 6 is B side 
				(list #\B (+ input 1)))
		  ))
;**********************************************
;Source code reads numbers from 0-5/handsize
;**********************************************
;*********************************************************************
;Function Name: readnum05
;Purpose: Validates user input for index of tile in hand
;Parameters: handsize, an atom containing the size of the hand being played from
;Return Value: an atom, containing an index that can be validated
;Assistance Received: None.
;*********************************************************************
;read
;valid05
(defun readnum05 (handsize)
	(princ "Please enter the index of tile: ")
	(terpri)
	;reads and validates the index to make sure it is between 0 the current handsize
	(valid05 (read) handsize))
;**********************************************
;Source code validates input for readnum05
;********************************************
;*********************************************************************
;Function Name: valid05
;Purpose: Validates user input for the index of tile in hand
;Parameters: num, an atom containing the index to be verified
;			 handsize, an atom containing the size of the hand being played from
;Return Value: An atom containing an index that could be validated
;Assistance Received: None.
;*********************************************************************
;readnum05
(defun valid05 (num handsize)
	;if the input is below 0 or greater or equal to the maximum hand size, ask the user for new input
	(cond ( ( < num 0 )
			(readnum05 handsize))
			( ( >= num handsize)
			(readnum05 handsize))
			;if the input is validated, return it
			(t num)))
			
;************************************************
;Source code for validating user input (y/n)
;************************************************
;*********************************************************************
;Function Name: validYN
;Purpose: Validates user input of Y or N
;Parameters: input, atom containing user input
;Return Value: Y or N, based on user input
;Assistance Received: none
;*********************************************************************
;validYN
(defun validYN (input)
	;if the input is Y or N, return it
	(cond ((or (equal input 'Y) (equal input 'N))
			input)
		(t 
		;otherwise prompt user for Y/N answer and validate again
			(princ "(Y/N)?")
			(terpri)
			(validYN (read)))
))

;**********************************************
;Source code for checking if tile is playable
;**********************************************
;*********************************************************************
;Function Name: tryplay
;Purpose: Checks if the tile is playable
;Parameters: Stacks, a list containing the top tiles on the stacks
;			 tile, the list containing the tile being played
;			 tileIndex, the index on the stack where the tile will be played
;Return Value: An atom, of value T or Nil, indicating if the tile is playable
;Assistance Received: None.
;*********************************************************************
;findAt
;checkVal
;checkDouble
(defun tryplay (Stacks tile tileIndex)
	;Get the tile at that stack index
	(let ( (stacktile (findAt Stacks tileIndex)))
		;if the input tile is not a double and is greater than or equal to the tile, then the play is allowed
		(cond ( (and (>= (checkVal tile) (checkVal stacktile))(not (checkDouble tile))) t)
			  ( t 

			    (cond ( (checkDouble tile) 
						;if the tile is a double, and the tile on the stack is not, then allowed it
						(cond ( (equal (checkDouble stacktile) NIL) t)
								;if the tile on the stack is a double, allow the move if the tile in hand is greater
							  ((> (checkVal tile) (checkVal stacktile)) t)
							  ;if the tile is less than or equal to the stack tile that is a double, then it is not allowed
							  (t NIL)))
						;if the tile is less than the stack tile, and the tile is not a double, then it is not allowed
					  (t NIL))))))

;************************************************
;Source code for checking if plays are possible
;************************************************
;*********************************************************************
;Function Name: canPass
;Purpose: Checks if the player can pass based on their hand and the stacks
;Parameters: Stacks, the list of the top tiles on the stacks
;			 playHand, the list containing the tiles in hand for the player 
;Return Value: NIL, if the player cannot pass. T if the player can.
;Assistance Received: None.
;*********************************************************************
;bestPlay
(defun canPass(Stacks playHand)
	;If plays remain, the player cannot pass. If there are no plays, the player may pass
	(cond ( (bestPlay Stacks playHand) NIL)
		  (t 
			t)))
;************************************************
;Source code for finding if plays are possible
;************************************************
;*********************************************************************
;Function Name: bestPlay
;Purpose: Finds if any plays are possible
;Parameters: Stacks, the list of the top tiles on the stacks.
;			 playHand, the list of the tiles in the player's hand
;Return Value: T, if the player can play. Nil if the player can not
;Assistance Received: None.
;*********************************************************************
;findEle
;lowestValue
;tryplay
;bestPlay
(defun bestPlay(Stacks playHand)
	;find the lowest tile on the stack
	(let ( (lowestTile (findEle Stacks (lowestValue Stacks) 0)))
		;if the player hand is empty, nothing can be played
		(cond ( (null playHand)
				(terpri) NIL)
			  ( t 
				;if the tile cannot be played, then keep looking though the hand until a tile can be played
				(cond ( (equal (tryplay Stacks (lowestValue playHand) lowestTile) NIL)
							(bestPlay Stacks (eliminate playHand (findEle playHand (lowestValue playHand) 0))))
						  (t 
							;Otherwise (because a play is allowed), returns list of (tile indexofstack)
							(list (lowestValue playHand) lowestTile)))))))
;-------------------------------------Check for derived values-------------------------------
;**********************************************
;Source code calculating which hand is currently happening
;**********************************************
;*********************************************************************
;Function Name: findHand
;Purpose: Finds which hand is currently being played based on the number of tiles in the boneyard
;Parameters: yard, a list containing any one boneyard
;Return Value: An atom of the values 0,1,2,3,4 or the string "corrupted data" indicating the hand.
;Assistance Received: None
;*********************************************************************
(defun findHand (yard)
	;Calculates the hand the game is currently on by counted the number of tiles in a boneyard
	(let ( (tiles (length yard)))
				;stacks were dealt, but hands were not. 0 Hands dealt.
		 (cond  ((= tiles 22) 0)
				;stacks and hands were dealt. 1 Hand dealt.
				((= tiles 16) 1)
				;6 more tiles were drawn. 2 Hands dealt.
				((= tiles 10) 2)
				;6 more tiles were drawn. 3 Hands dealt.
				((= tiles 4) 3)
				;Boneyard is empty. 4 Hands dealt.
				((= tiles 0) 4)
				;Anything else would be irregular
				(t "corrupt data"))))

;**********************************************
;Source code checks the value of the tile
;***********************************************
;*********************************************************************
;Function Name: checkVal
;Purpose: Checks the value of the tile
;Parameters: tile, a list containing the tile to be checked
;Return Value: an atom containing the sum of the two pips on the tile
;Assistance Received: None.
;*********************************************************************
(defun checkVal (tile)
	;adds the values of the two pips, the second and third elements of the list that is each tile
	(let ((pip1 (first (rest tile)))
		  (pip2 (first (rest (rest tile)))))
		 (+ pip1 pip2)))
;****************************************************
;Source code checks the color of the tile
;****************************************************
;*********************************************************************
;Function Name: checkColor
;Purpose: Gets the color of the tile 
;Parameters: tile, a list containing the tile to be checked
;Return Value: A character containing the color of the tile, or NIL if it failed to read
;Assistance Received: None.
;*********************************************************************
(defun checkColor (tile)
	;checks the first character of the tile for the color
	(cond ( (consp tile)
		(char (string (first tile)) 0))
		;if the tile cannot be parsed, return NIL
		(t NIL)))
;*************************************************
;Source code checks if tile is a double
;************************************************
;*********************************************************************
;Function Name: checkDouble
;Purpose: Checks if the file is a double
;Parameters: tile, a list containing the tile to be checked
;Return Value: an atom or value T or NIL, indicating if the tile is a double
;Assistance Received: None.
;*********************************************************************
(defun checkDouble (tile)
	;checks if the two pips are the same value
	(let ((pip1 (first (rest tile)))
		  (pip2 (first (rest (rest tile)))))
		 (= pip1 pip2)))
;*************************************************
;Source code to get domino at a position count
;**************************************************
;*********************************************************************
;Function Name: findAt
;Purpose: Finds the element at an index in a list
;Parameters: numList, the list being searched
;			 count, the index where the element should be
;Return Value: The element at that location
;Assistance Received: None.
;*********************************************************************
;findat
(defun findat (numList count)
	;returns the element when count = 0
	(cond ((= count 0)
			(first numList))
		;decrement count, and throw out the element just examined until count = 0
		(t (findat (rest numList) (- count 1)))))
;************************************************
;Source code for finding lowest value
;************************************************
;*********************************************************************
;Function Name: lowestvalue
;Purpose: Finds the lowest tile in the list
;Parameters: numList, the list of tiles being searched
;Return Value: The lowest tile in the list
;Assistance Received: None.
;*********************************************************************
;lowestValue
;checkVal
(defun lowestValue (numList)
	;returns the last value, and if any values are lower than it on the way back up, return the them until all elements have been examined
	(cond ( (null (rest numList))
				(first numList))
		((let ((low (lowestValue (rest numList))))
		(cond ((< (checkVal low) (checkVal (first numList))) low)
				(t (first numList))))))
)
;**************************************************
;Source code for finding an element in a list; use 0 for count
;***************************************************
;*********************************************************************
;Function Name: findEle
;Purpose: Finds the index of the first instance of an element
;Parameters: numList, the list of tiles being searched
;			 element, the element being searched for
;			 count, a counter variable that records the index. Should be set to 0 when first called.
;Return Value: An atom containing the index of the element.
;Assistance Received: None.
;*********************************************************************
;findEle
(defun findEle (numList element count)
	;when element is found, return the count, which should have the index
	(cond ( (equal element (first numList)) count)
		  (t 
			(findEle (rest numList) element (+ count 1))))
)

;------------------------------------data manipulation----------------------------------
;************************************************
;Source code to replace a tile at index 'loc' with 'newThing'
;************************************************
;*********************************************************************
;Function Name: replaceAt
;Purpose: Replaces an element from numList at index loc with newThing
;Parameters: numList, a list of tiles
;			 loc, an atom containing the index of replacement
;			 newThing, an atom containing the replacement element
;Return Value: The updated list
;Assistance Received: None.
;*********************************************************************
;replaceAt
(defun replaceAt(numList loc newThing)
	;Look through the list until that index is reached and return whatever was before it, it, and whatever comes after
	(cond ((= loc 0)
			(cons newThing (rest numList)))
		   (t (cons (first numList) (replaceAt (rest numList) (- loc 1) newThing)))))
;************************************************
;Source code to shuffle a boneyard
;************************************************
;*********************************************************************
;Function Name: shuffle
;Purpose: Shuffles the boneyard
;Parameters: boneyard, the list of tiles being shuffles
;			 size, an atom containing the size of the boneyard
;			 times, the number of times the function will recur
;Return Value: A list containing the shuffle stacks
;Assistance Received: Andrew K.
;*********************************************************************
;findAt
;eliminate
;shuffle
(defun shuffle(boneyard size times)

	(cond ((= times 0) boneyard)
		;gets a random number between 0 and size-1, get the domino at that location, and bring it to the front
		   (t (let* ((tileNum (random size))
				  (domino (findAt boneyard tileNum))
				  (newYard (cons domino (eliminate boneyard tileNum))))
			;continue until times = 0
			(shuffle newYard size (- times 1))))))

;************************************************
;Source code to take a tile at position count
;************************************************
;*********************************************************************
;Function Name: eliminate
;Purpose: Removes an element at an index
;Parameters: numList, the list the element is being removed from
;			 count, the index of where the numList is being removed from
;Return Value: The updated list
;Assistance Received: None.
;*********************************************************************
;eliminate
(defun eliminate (numList count)
	;Looks through the list until count = 0, and returns whatever was before it, and what ever was after it
	(cond ((= count 0) 
			 (rest numList))
		  (t (cons (first numList) (eliminate (rest numList) (- count 1))))))

;***********************************************
;Source code to get next 'number' of tiles
;***********************************************
;*********************************************************************
;Function Name: draw
;Purpose: Gets the next 'number' of elements from a list
;Parameters: numList, the list that is being drawn from
;			 number, the number of elements being drawn
;Return Value: The list of tiles that were drawn
;Assistance Received: None.
;*********************************************************************
;draw
(defun draw(numList number)
	(let ((retList))
		;Looks through the list and returns them all in a list until number = 1 is processed or the list is empty
		(cond ((= number 1) 
				(cons (first numList)retList))
			  ((equal (first numList) NIL) 
				retList)
			  (t 
				(cons (first numList)(draw (rest numList) (- number 1)))))))
;***************************************************
;Source code to remove next 'number of tiles
;**************************************************
;*********************************************************************
;Function Name: mill
;Purpose: Removes the next 'number' of tiles from a list
;Parameters: numList, the list of tiles being removed from
;			 number, the number of tiles being removed
;Return Value: The updated list of tiles, now missing the top 'number' of elements
;Assistance Received: None.
;*********************************************************************
;mill
(defun mill(numList number)
	;throws away tiles until number = 1 is processed.
	(cond ((= number 1) (rest numList))
		  (t 
			(mill (rest numList) (- number 1)))))
;--------------------------------------------SERIALIZATION----------------------------------------------
;*************************************************
;Source code to save file
;*************************************************
;*********************************************************************
;Function Name: saveGame
;Purpose: Saves the game to a file
;Parameters: player, an atom that keeps track of whose turn it is. 1 for human. 2 for computerWins
;			 Yards, a list of two lists containing human Boneyard, computer Boneyard
;			 Stacks, a list of the top tiles of the stack. The first 6 elements are the human's side. The last 6 are the computer's side.
;			 Hands, a list containing the player's hands as two lists
;			 Scores, a list containing the player's scores
;			 Wins, a list containing the number of rounds each player as won
;Return Value: A list containing a list of the computer and the human player's stacks, boneyard, hand, score, rounds won. 
;				The list also contains whose turn it is.
;Assistance Received: None.
;*********************************************************************
;with-open-file
;read
;draw
(defun saveGame(player Yards Stacks Hands Scores Wins)
	(let ( ( pTurn (cond ( (= player 1) "Human")
						 ( (= player 2) "Computer"))))
	(print "Enter a file name")
	;Writes to the file of the user's specification. If the file exists, override. Else, create a new file.
	(with-open-file (*standard-output* (string (read))
						:direction :output
						:if-exists :supersede
						:if-does-not-exist :create)
			;and print the data in the correct format (see Return Value above)
			(princ (list (list (draw Stacks 6) (first Yards) (first Hands) (first Scores) (first Wins)) (list (reverse(draw (reverse Stacks) 6)) (first (rest Yards)) (first (rest Hands)) (first (rest Scores)) (first (rest Wins))) pTurn))
			)
))
;************************************************
;Source code for reading if the user wishes to save
;************************************************
;*********************************************************************
;Function Name: saveYN
;Purpose: Validates user input if they want to save
;Parameters: player, an atom that keeps track of whose turn it is. 1 for human. 2 for computerWins
;			 Yards, a list of two lists containing human Boneyard, computer Boneyard
;			 Stacks, a list of the top tiles of the stack. The first 6 elements are the human's side. The last 6 are the computer's side.
;			 Hands, a list containing the player's hands as two lists
;			 Scores, a list containing the player's scores
;			 Wins, a list containing the number of rounds each player as won
;Return Value: NIL if user does not wish to save, the string "Saving and " if the user wishes to save
;Assistance Received: Andrew K.
;*********************************************************************
;read
;validYN
;saveGame
(defun saveYN (player Yards Stacks Hands Scores Wins)
	(princ "Do you wish to save? (Y/N)")
	(terpri)
	;prompts and validates user input
	(cond ( (equal (validYN(read)) 'Y) 
			(saveGame player Yards Stacks Hands Scores Wins)
			(princ "Saving and ")
			;throw statement goes all the way up to tournament to exit functions
			(throw 'saved))
		  (t 
			NIL))
)

;*************************************************
;Source code to open file to load
;*************************************************
;*********************************************************************
;Function Name: loadGame
;Purpose: loads the game from a file
;Parameters: none
;Return Value: T, from playTurn
;Assistance Received: none.
;*********************************************************************
		;read
		;open
;playTurn	;loadGame
;close		;close

(defun loadGame()
	(princ "Enter a file name: ")
	(let ( (in (open (string (read)) :direction :input :if-does-not-exist  nil)))
		;if the file exists, then translate the atom into a number that playTurn recognizes
		(cond (in
				(let ((input (read in)) )
					(let ( ( player (cond ( (equal (third input) 'Human) 1)
										  ( (equal (third input) 'Computer) 2)
										  (t 
											0))))
					;parses file for playTurn to use
					;the format for playTurn is (player Yards Stacks Hands Scores Passes Wins)
						(playTurn player (list (second (second input))(second (first input))) (append (first (second input)) (first (first input))) (list (third (second input)) (third (first input))) (list (fourth(second input)) (fourth(first input))) (list NIL NIL) (list (fifth (second input)) (fifth (first input))))
					)
				)
				(close in))
			  (t 
				;If the file is not found, ask for a new file name
				(princ "File not found!")
				(terpri)
				(loadGame)
				(close in)
				)))
)


;--------------------------------------------------Computer Player----------------------------------------------
;**************************************************
;Computer plays
;**************************************************
;*********************************************************************
;Function Name: AIPlay
;Purpose: The computer player makes moves
;Parameters: Stacks, the list containing the top tiles on the stacks
;			 Hands, the list containing the lists of the human and computer player's hands
;Return Value: A list containing: the new list of tiles on the stacks, and a list of lists of the new hands of the two players
;Assistance Received: None.
;*********************************************************************
;precedenceAI
;indexToStack
;replaceAt
;findEle
;eliminate
(defun AIPlay (Stacks Hands)
	;If the computer has a move, print it
	(let ( (move (precedenceAI Stacks (second Hands))))
		(princ "Computer plays ")
		(princ (second move))
		(princ " on ")
		(princ (indexToStack (third move)))
		(terpri)
		;Outputs in the format (stacks hands)
		(list (replaceAt Stacks (third move) (second move)) (list (first Hands) (eliminate (first (rest Hands)) (findEle (first (rest Hands))(second move) 0))))
	)
)
;**************************************************
;Determining what to play
;**************************************************
;*********************************************************************
;Function Name: precedenceAI
;Purpose: Prints the reason why the computer arrived that move
;Parameters: Stacks, a list containing the top tiles on the stacks
;			 playHand, a list containing the hand being played from
;Return Value: A list containing the precedence of the move, the tiles being played, and the index where it is being played on
;Assistance Received: None.
;*********************************************************************
;precedenceAll
;precedenceHigh
(defun precedenceAI (Stacks playHand)
	;print a reason for the move based on the precedence 
	(let ( ( move (precedenceHigh (precedenceAll Stacks playHand 0 0))))
		 (cond ( (= (first move) -99) NIL)
			   ( (< (first move) 0)
				 (princ "Computer tries to minimize point loss")
				 (terpri) move)
			   ( (= (first move) 0)
				 (princ "Computer is forced to make no point gain")
				 (terpri) move)
			   ( (= (first move) 1)
				 (princ "Computer cannot make the stack value higher")
				 (terpri) move)
			   ( (> (first move) 20) 
				 (princ "Computer plays for maximum point gain")
				 (terpri) move)
			   ( (< (first move) 20)
				 (princ "Computer plays to reset a stack")
				 (terpri) move)
				 ))
)
;***************************************************
;Find highest precedence
;***************************************************
;*********************************************************************
;Function Name: precendenceHigh
;Purpose: Finds the move with the highest precedence
;Parameters: PrecendenceList, a list containing the precedence, the tile being played, and the index being played on, for every combination of tiles and indices
;Return Value: A list of (precedence of the move, the tile being played, the index being played on)
;Assistance Received: None.
;*********************************************************************
;precedenceHigh
(defun precedenceHigh (PrecedenceList)
	;looks through the list for precedence values and returns the move that has the highest precedence
	(cond ( (null (rest PrecedenceList))
				(first PrecedenceList))
				;if the current move has higher precedence then the preceding moves (technically moves that come after it in the list), use current move
		(t (let ((high (PrecedenceHigh (rest PrecedenceList))))
				(cond ((> (first high) (first (first PrecedenceList))) high)
					  (t (first PrecedenceList))))))
)
;***************************************************
;Creates an array of precedence
;***************************************************
;*********************************************************************
;Function Name: precedenceAll
;Purpose: Finds the precedence of every combination of tiles and indices
;Parameters: Stacks, a list containing the top tiles of the stacks
;			 playHand, the list containing the tiles in the hand being played from
;			 stackindex, the index on the stack to begin at. Should be set to zero.
;			 handindex, the index in the hand to begin at. Should be set to zero.
;Return Value: A list containing the precedence, the tile being played, and the index being played on, for every combination of tiles and indices
;Assistance Received: None.
;*********************************************************************
;findAt
;precedence
;precedenceALL
(defun precedenceAll (Stacks playHand stackindex handindex)
	;Takes a tile in hand, and gets its precedence for each stack. Then move on to the next tile in hand.
	(cond ( (= (length playHand) handindex)
			NIL)
		(t (cond ( (= (length Stacks) stackindex)
				;precedence list elements in format (precedence TileInHand indexOnStack)
				(append (precedenceALL Stacks playHand 0 (+ handindex 1))))
			  ( 
				(append (list (list (precedence Stacks stackindex (findAt playHand handindex)) (findAt playHand handindex) stackindex)) (precedenceALL Stacks playHand (+ stackindex 1) handindex))))))
)
;***************************************************
;Finds precedence
;***************************************************
;*********************************************************************
;Function Name: precedence
;Purpose: Finds the precedence of a tile at a index on the stacks
;Parameters: Stacks, a list containing the top tiles of the stacks
;			 stackIndex, an atom containing the index of the tile being played one
;			 handTile, the tile being played
;Return Value: The precedence of the move
;Local Variables: None
;Algorithm: Checks if the tile being played is smaller.
;				If yes, check the if the hand tile is a double
;				If no, return -99, as tile cannot be played
;				If both tiles are doubles, return -99, as tile cannot be played
;				Otherwise, check if the tiles are the same color
;					If yes, precedence = the value of the tile in hand - the value of the tile on the stack
;					If no, precedence = the value of the tile on the stack -  the value of the tile in hand
;				If both tiles are equal value:
;					If both tiles are doubles, return -99, as tile cannot be played
;					If both tiles are the same color, return 0, as there is no net score change
;					Otherwise, return 1, as the point gain is minimal
;				If the tile in hand is bigger:
;					If both tiles are the same color, precedence = the value of the tile on the stack -  the value of the tile in hand
;					If the tile in hand is a double, precedence = the value of the tile in hand - the value of the tile on the stack
;					Otherwise, precedence = 20 + precedence = the value of the tile in hand - the value of the tile on the stack
;Assistance Received: Andrew K.
;*********************************************************************
;checkVal
;findAt
;checkDouble
;checkColor
(defun precedence (Stacks stackIndex handTile)
	(cond ( (< (checkVal handTile) (checkVal (findAt Stacks stackIndex)) )
			(cond ( (not(checkDouble handTile)) 
					;if the Tile in hand is smaller and is not a double, it cannot be played
					-99)
				  ( (and (checkDouble handTile) (checkDouble (findat Stacks stackIndex)) )
					;if the tile in hand is smaller and both are doubles, the tile cannot be played
					-99)
				  (t 
					(cond ( (equal (checkColor handTile) (checkColor (findAt Stacks stackIndex)))
							;if the tiles are the same color, the precedence is negative (unfavorable)
							(- (checkVal handTile)(checkVal (findAt Stacks stackIndex))))
						  (t 
							;If the tiles are not the same color, the precedence is based on difference.
							;A lower double on a higher valued tile is better
							(- (checkVal (findAt Stacks stackIndex)) (checkVal handTile)))))))
		  ( (= (checkVal handTile) (checkVal (findAt Stacks stackIndex)))
			(cond ( (and (checkDouble handTile) (checkDouble (findAt Stacks stackIndex)))
					;if both tiles are equal and are both doubles, the move is illegal
					-99)
				  ( (equal (checkColor handTile) (checkColor (findAt Stacks stackIndex)))
					;if the difference is for same colored tiles, return 0 for no net change in score
					0)
				  (t 
					;if the tiles are equal and not the same color, return 1 for minimal point gain
					1)))
		  ( (> (checkVal handTile) (checkVal (findAt Stacks stackIndex)))
			(cond ( (equal (checkColor handTile) (checkColor (findAt Stacks stackIndex)))
					;if the tiles are the same color and the tile in hand is greater, the precedence decreases as the difference is larger
					;Don't play large tiles on your own small tiles. 
					(- (checkVal(findAt Stacks stackIndex)) (checkVal handTile)))
				  ( (checkDouble handTile)
					;if the tile in hand is a double and is larger, precedence is negative because it wastes the double property of resetting stacks
					(- (checkVal handTile) (checkVal(findAt Stacks stackIndex))))
				  (t 
					;If the tile in hand is not a double, is larger, and the two tiles have different tiles, fire away and try to get a ton of points
					(+ (- (checkVal handTile) (checkVal(findAt Stacks stackIndex))) 20))))))
;***********************************************
;Get help
;***********************************************
;*********************************************************************
;Function Name: wantHelp
;Purpose: Prompts if the user wishes to receives help
;Parameters: Stacks, the list of tiles on the top of the stacks
;			 Hands, the list containing the human player's hand and the computer player's hand.
;Return Value: T from (terpri) if the user wants help, or NIL if user does not want help
;Assistance Received: None.
;*********************************************************************
;read
;validYN
;precedenceAI
;indexToStack
(defun wantHelp (Stacks Hands)
	;reads and validates if the user wants help
	(princ "Do you want help? (Y/N)")
	(terpri)
	(cond ( (equal (validYN(read)) 'Y)
			;if the user wants help, use the computer's decision making process to recommend a move.
			(let ( (move (precedenceAI Stacks (first Hands))))
				(princ "Computer recommends ")
				(princ (second move))
				(princ " on ")
				(princ (indexToStack(third move)))
				(terpri)))
		  (t 
			NIL))
)