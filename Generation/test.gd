extends Node

@onready var dungeon = $".."

var tests = []

func _ready():
	await get_tree().process_frame # ļauj dungeonam pabeigt generate()

	run_tests()


# -------------------------
# TEST RUNNER
# -------------------------
func run_tests():
	tests = []

	tests.append(test_rooms_exist())
	tests.append(test_monster_spawn())
	tests.append(test_player_spawn())

	print("\n===== DUNGEON TEST RESULTS =====")
	for t in tests:
		print(t)
	print("================================\n")


# -------------------------
# TEST 1
# -------------------------
func test_rooms_exist() -> String:
	var type = "Funkcionāls tests"
	var goal = "Pārbaudīt vai dungeonā ir ģenerētas istabas"
	var actions = "Pārbaudīt room_positions masīvu"

	var expected = "room_positions > 0"
	var actual = str(dungeon.room_positions.size())

	var passed = dungeon.room_positions.size() > 0

	var conclusion = "OK" if passed else "FAIL - nav ģenerētu istabu"

	return format_test(type, goal, actions, expected, actual, conclusion)


# -------------------------
# TEST 2
# -------------------------
func test_monster_spawn() -> String:
	var type = "Integrācijas tests"
	var goal = "Pārbaudīt vai monstrs ir novietots dungeonā"
	var actions = "Pārbaudīt monster_pos vērtību"

	var expected = "monster_pos != null"
	var actual = str(dungeon.monster_pos)

	var passed = dungeon.monster_pos != null

	var conclusion = "OK" if passed else "FAIL - monster nav spawnots"

	return format_test(type, goal, actions, expected, actual, conclusion)


# -------------------------
# TEST 3
# -------------------------
func test_player_spawn() -> String:
	var type = "Funkcionāls tests"
	var goal = "Pārbaudīt vai spēlētājs ir novietots dungeonā"
	var actions = "Pārbaudīt player_pos vērtību"

	var expected = "player_pos != null"
	var actual = str(dungeon.player_pos)

	var passed = dungeon.player_pos != null

	var conclusion = "OK" if passed else "FAIL - player nav spawnots"

	return format_test(type, goal, actions, expected, actual, conclusion)


# -------------------------
# FORMAT
# -------------------------
func format_test(type, goal, actions, expected, actual, conclusion) -> String:
	return (
		"Veids: " + type + "\n" +
		"Mērķis: " + goal + "\n" +
		"Darbības: " + actions + "\n" +
		"Paredzamais rezultāts: " + expected + "\n" +
		"Reālais rezultāts: " + actual + "\n" +
		"Secinājums: " + conclusion + "\n"
	)
