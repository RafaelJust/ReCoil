extends Node

# These values determine which verion of an instrument is played
@export var Drums: int = 1
@export var Bass: int = 0 # 0 means disabled
@export var Lead: int = 0

var drumPlayers: Array
var bassPlayers: Array
var leadPlayers: Array

var otherPlayers: Array

var Other: Array = [false, false, false, false, false] 

var bassDouble: bool = true # makes sure the bass only plays every two bars

func _ready():
	#Get all the players in an aray for easy access
	drumPlayers = $Drums.get_children()
	bassPlayers = $Bass.get_children()
	leadPlayers = $Lead.get_children()
	otherPlayers = $Other.get_children()
	
	# Start the right track
	SwitchTrack(drumPlayers, Drums)
	SwitchTrack(bassPlayers, Bass)
	SwitchTrack(leadPlayers, Lead)

func SwitchTrack (players: Array, newInstrument: int):
	var index: int = newInstrument - 1 # Arrays start counting at 0, so we need to compensate
	if index == -1: return # don't play anything if nothing is needed, or if the corresponding player is already playing
	players[index].play()

func SwitchTrack_Others():
	for i in range(len(Other)):
		if Other[i]:
			otherPlayers[i].play()

func LoopDone_Drums():
	
	if Drums == 4: Drums = 0
	if Bass == 4: Bass = 0
	if Lead == 4: Lead = 0
	
	SwitchTrack(leadPlayers, Lead)
	if bassDouble: SwitchTrack(bassPlayers, Bass)
	SwitchTrack(drumPlayers, Drums)
	SwitchTrack_Others()
	
	if(Bass >= 1): bassDouble = !bassDouble
	else: bassDouble = true
