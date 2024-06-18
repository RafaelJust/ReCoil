extends Node

# These values determine which verion of an instrument is played
@export var Drums: int = 1
@export var Bass: int = 0 # 0 means disabled
@export var Lead: int = 0

var drumPlayers: Array
var bassPlayers: Array
var leadPlayers: Array

func _ready():
	#Get all the players in an aray for easy access
	drumPlayers = $Drums.get_children()
	bassPlayers = $Bass.get_children()
	leadPlayers = $Lead.get_children()
	
	# Start the right track
	SwitchTrack(drumPlayers, Drums)
	SwitchTrack(bassPlayers, Bass)
	SwitchTrack(leadPlayers, Lead)

func SwitchTrack (players: Array, newInstrument: int):
	if newInstrument == -1: return
	if players[newInstrument].name == "None": # Timer has a different start method
		players[newInstrument].start()
	else:
		players[newInstrument].play()

func LoopDone_Drums():
	SwitchTrack(drumPlayers, Drums)

func LoopDone_Bass():
	SwitchTrack(bassPlayers, Bass)

func LoopDone_Lead():
	SwitchTrack(leadPlayers, Lead)
