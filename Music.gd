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
	var index: int = newInstrument - 1 # Arrays start counting at 0, so we need to compensate
	if index == -1: return # don't play anything if nothing is needed, or if the corresponding player is already playing
	players[index].play()

func LoopDone_Drums():
	SwitchTrack(leadPlayers, Lead)
	SwitchTrack(drumPlayers, Drums)
	SwitchTrack(bassPlayers, Bass)	
