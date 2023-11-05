extends Node

signal playerActionsAvailable(player:Player, source:InventoryItem, actions:Array[PlayerAction])
signal playerActionsRemoved(player:Player, source:InventoryItem)
signal playerActionsAllRemoved(player:Player)
signal modalPanelOpened(panel:Control)
signal modalPanelClosed(panel:Control)
