use strict;
use warnings;
use diagnostics;
use Array::Shuffle qw(shuffle_array); #shuffling words
use List::MoreUtils qw(firstidx);
use Term::ANSIColor; #for bolding words

#!/usr/bin/env perl
playGame(); #start the game
sub playGame{
my @array=();
open(my $fh, "<", "test.txt")
    or die "Failed to open file: $!\n";
#push elements from the text file into an array
while(<$fh>) 
{ 
    chomp; 
    push @array, $_;
} 
close $fh;
#print @array;
#print join " ", @array;
shuffle_array(@array); #shuffle the array

print "\n >>>>>> Terminal Hangman <<<<<< \n";
print "Type \"start\" to begin a new game\n";
my $turn = 0;
my $rematch = "";
print "> ";
my $userWord = <>;
chomp($userWord); #remove newline character
#make sure user types in start
until($userWord eq "start")
{
	print "> ";
	$userWord = <>;
	chomp($userWord);
}
print "\nGenerating your random word... \n \n \n";
sleep(2);

until($rematch eq "quit")
{
	#randomly set the word to the 17th word in the array
	my $word = $array[17];
	#convert the word into uppercase (simplify)
	$word = uc $word;
	my @alphabet = ("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", 
"L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
	my $lives = 6;
	#create array with letters of word, separating them with split function
	my @letters = split(//, $word);
	print "\nWord Generated! \n\n";
	#print starting Hangman display
	hangmanDisplay1();
	print color("bold");
	print "Your word looks like: ";
	print color('reset');
	if($rematch eq "new" || $turn == 0)
	{
		foreach $a (@letters)
		{
			print "_ ";
		}
	}
	#letters remaining = the amount of letters in the array
	my $lettersRemaining = scalar @letters;
	#print "$lettersRemaining";
	print "\n \n";
	
	print "Lives Remaining: $lives \n";
	print "Letters remaining: ";
	foreach $b (@alphabet)
	{
		print "$b";
	}
	print "\n";
	print "Guess a letter: ";
	print "> ";
	#<> retrieves the input from the user
	my $guess = <>;
	chomp($guess);
	$guess = uc $guess;
	print "\n-----------------------\n";
	print "Reading in your guess...\n";
	sleep(1.5);
	print "\n\n";
	#guess is not in the alphabet, (possibly guessed two letters or a letter that is not left)
	until( $guess ~~ @alphabet)
	{
		print "Invalid Entry! \n";
		print "Please select from the available letters";
		print "> ";
		$guess = <>;
		chomp($guess);
		$guess = uc $guess;
	}
	$lettersRemaining = scalar @letters;
		 until( $lives == 0 || $lettersRemaining == 0)
		 {
		 	#guess is in letters (correct guess)
		 	if ( grep( /^$guess$/, @letters ) )
		 	{
		 		#first check to see if there are more than one of that letter in the word
		 		if( grep(/$guess/, @letters) > 1)
		 		{
		 			#get the number of repeats of that letter and subtract that from letters remaining
		 			my $repeats = grep(/$guess/, @letters);
		 			$repeats = $repeats - 1;
		 			$lettersRemaining = $lettersRemaining - $repeats;
		 			#print "remaining: $lettersRemaining \n";
		 		}
		 		#find the index of that letter in the alphabet, and remove it so user knows if letter is gone
		 		my $index = firstidx { $_ eq $guess } @alphabet;
		 		splice(@alphabet, $index, 1);
		 		print "Good Guess! You guessed a correct letter!\n";
		 		$lettersRemaining = $lettersRemaining - 1;
		 		print "Remaining letters in Alphabet: @alphabet \n\n";
		 		#print "$lettersRemaining";
		 		print color("bold");
		 		print "Your correct selections so far: ";
		 		# if($lettersRemaining == 0)
		 		# {
		 		# 	last;
		 		# }
		 		foreach my $b (@letters)
		 		{
		 			if( $b ~~ @alphabet)
		 			{
		 				print "_ ";
		 			}
		 			else
		 			{
		 				print "$b ";
		 			}
		 		}
		 		print color("reset");
		 		print "\n----------------------- \n";
		 		if( $lettersRemaining == 0)
		 		{
		 			print "\n";
		 			print "Congratulations! You have guessed the word correctly! Your word was: $word \n\n";
		 			terminate();
		 			exit;
		 		}
		 		
		 		print "\n";
		 		print "Guess a letter: ";
		 		print "> ";
		 		$guess = <>;
		 		chomp($guess);
		 		$guess = uc $guess;

		 		until( $guess ~~ @alphabet)
		 		{
		 			print "Invalid Entry! \n";
		 			print "Please select from the available letters";
		 			print "> ";
		 			$guess = <>;
		 			chomp($guess);
		 			$guess = uc $guess;
				}
			}
			#guessed letter is not in the word
				elsif( ! grep( /^$guess$/, @letters ) )
				{
					$lives = $lives - 1;
					#user loses
					if($lives == 0)
					{
						hangmanDisplay7();
						print color("bold");
						print "\nWrong again! Sorry, you have used all of your available lives. \n\nPlease play again if you would like.\n\n";
						print "Your Word was: $word\n\n";
						print color("reset");
						terminate();
					}
					#now print out hangman Displays
					if($lives == 5)
					{
						hangmanDisplay2();
					}
					elsif($lives == 4)
					{
						hangmanDisplay3();
					}
					elsif($lives == 3)
					{
						hangmanDisplay4();
					}
					elsif($lives == 2)
					{
						hangmanDisplay5();
					}
					elsif($lives == 1)
					{
						hangmanDisplay6();
					}

					print "Wrong letter! Please guess again.\n\n";
					my $index = firstidx { $_ eq $guess } @alphabet;
		 			splice(@alphabet, $index, 1);
		 			print color("bold");
		 			print "What you have so far: ";
		 			foreach $b (@letters)
		 			{
		 				if( $b ~~ @alphabet )
		 				{
		 					print "_ ";
		 				}
		 				else
		 				{
		 					print "$b ";
		 				}
		 			}
		 			print color("reset");
		 			print "\n\n";
		 			print "Lives Remaining: $lives \n";
		 			print "Letters Remaining: ";

		 			foreach my $b (@alphabet)
		 			{
		 				print "$b ";
		 			}
		 			print "\n-----------------------";
		 			print "\n\n";
		 			print "Guess a letter: ";
		 			print "> ";
		 			$guess = <>;
		 			chomp($guess);
		 			$guess = uc $guess;
		 			until( $guess ~~ @alphabet )
		 			{
		 				print "Invalid Entry! \n";
		 				print "Please select from the available letters";
		 				print "> ";
		 				$guess = <>;
		 				chomp($guess);
		 				$guess = uc $guess;
		 				print "\n-----------------------\n";
					}
			}
				else 
				{
					$lives = $lives - 1;
					print "You lose!\n";
					print "The word was $word";
					exit 0;
				}
			
		 	
		 }

	}
}
	sub terminate{
		print "Type in 'again' if you would like to play once more or 'quit' to exit out.\n";
		print "\n";
		print "Please choose: ";
		print "> ";
		my $play = <>;
		chomp($play);
		#print "$play";
		if($play eq "again")
		{
			print "\n \nThanks for playing, and best of luck next time around! \n \n";
			print "--------------------\n";
			playGame();
		}
		elsif($play eq "quit")
		{
			sleep(2);
			print "\n";
			print "Thanks for playing! \n \nExiting game.... \n \n";
			sleep(1);
			exit;
		}



		
	}
	sub hangmanDisplay1
{
        print "  -------\n";
        print "  |     |\n";
        print "  |\n";
        print "  |\n";
        print "  |\n";
        print "  |\n";
        print "  |\n";
        print "--|----\n";
}
	sub hangmanDisplay2
{
        print "  -------\n";
        print "  |     |\n";
        print "  |     o\n";
        print "  |\n";
        print "  |\n";
        print "  |\n";
        print "  |\n";
        print "--|----\n";
}
sub hangmanDisplay3
{
        print "  -------\n";
        print "  |     |\n";
        print "  |     o\n";
        print "  |     |\n";
        print "  |\n";
        print "  |\n";
        print "  |\n";
        print "--|----\n";
}

sub hangmanDisplay4
{
        print "  -------\n";
        print "  |     |\n";
        print "  |     o\n";
        print "  |    \\|\n";
        print "  |\n";
        print "  |\n";
        print "  |\n";
        print "--|----\n";
}

sub hangmanDisplay5
{
        print "  -------\n";
        print "  |     |\n";
        print "  |     o\n";
        print "  |    \\|/\n";
        print "  |\n";
        print "  |\n";
        print "  |\n";
        print "--|----\n";
}

sub hangmanDisplay6
{
        print "  -------\n";
        print "  |     |\n";
        print "  |     o\n";
        print "  |    \\|/\n";
        print "  |     /\n";
        print "  |\n";
        print "  |\n";
        print "--|----\n";
}
sub hangmanDisplay7
{
        print "  -------\n";
        print "  |     |\n";
        print "  |     x\n";
        print "  |    \\|/\n";
        print "  |     /\\\n";
        print "  |\n";
        print "  |\n";
        print "--|----\n";
    }


