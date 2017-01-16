module Arrays
	$monsters = [
		{'name'=>'Bulldrome', 'hp'=>500, 'icon'=>'bulldrome', 'trap'=>'both', 'color'=>'0x8b7657'},
		{'name'=>'Velocidrome', 'hp'=>500, 'icon'=>'velocidrome', 'trap'=>'both', 'color'=>'0x5193bd'},
		{'name'=>'Caeserber', 'hp'=>500, 'icon'=>'caeserber', 'trap'=>'both', 'color'=>'0xac8d45'},
		{'name'=>'Yian Kut-Ku', 'hp'=>500, 'icon'=>'yiankutku', 'trap'=>'both', 'color'=>'0xf57957'},
		{'name'=>'Gendrome', 'hp'=>500, 'icon'=>'gendrome', 'trap'=>'both', 'color'=>'0x588649'},
		{'name'=>'Baelidae', 'hp'=>500, 'icon'=>'baelidae', 'trap'=>'shock', 'color'=>'0x6a5577'},
		{'name'=>'Yellow Caeserber', 'hp'=>500, 'icon'=>'caeserber2', 'trap'=>'both', 'color'=>'0xc5cc6d'},
		{'name'=>'Gypceros', 'hp'=>500, 'icon'=>'gypceros', 'trap'=>'pitfall', 'color'=>'0x54657c'},
		{'name'=>'Congalala', 'hp'=>500, 'icon'=>'congalala', 'trap'=>'both', 'color'=>'0xc8979a'},
		{'name'=>'Chramine', 'hp'=>500, 'icon'=>'chramine', 'trap'=>'ptifall', 'color'=>'0x664c2f'},
		{'name'=>'Cephadrome', 'hp'=>500, 'icon'=>'cephadrome', 'trap'=>'both', 'color'=>'0xb0985b'},
		{'name'=>'Daimyo Hermitaur', 'hp'=>500, 'icon'=>'daimyohermitaur', 'trap'=>'shock', 'color'=>'0xad4934'},
		{'name'=>'Blue Yian Kut-Ku', 'hp'=>700, 'icon'=>'yiankutku2', 'trap'=>'both', 'color'=>'0x569cc6'},
		{'name'=>'Khezu', 'hp'=>500, 'icon'=>'khezu', 'trap'=>'both', 'color'=>'0xc1bfc2'},
		{'name'=>'Basarios', 'hp'=>1000, 'icon'=>'basarios', 'trap'=>'both', 'color'=>'0x8699a0'},
		{'name'=>'Hypnocatrice', 'hp'=>1000, 'icon'=>'hypnocatrice', 'trap'=>'both', 'color'=>'0xde681f'},
		{'name'=>'Gold Congalala', 'hp'=>1000, 'icon'=>'congalala2', 'trap'=>'both', 'color'=>'0xf9c041'},
		{'name'=>'Dread Baelidae', 'hp'=>1000, 'icon'=>'baelidae2', 'trap'=>'shock', 'color'=>'0x91926a'},
		{'name'=>'Purple Gypceros', 'hp'=>1000, 'icon'=>'gypceros2', 'trap'=>'pitfall', 'color'=>'0x9f46d3'},
		{'name'=>'Shogun Ceanataur', 'hp'=>2000, 'icon'=>'shogunceanataur', 'trap'=>'shock', 'color'=>'0x365d84'},
		{'name'=>'Blangonga', 'hp'=>2000, 'icon'=>'blangonga', 'trap'=>'both', 'color'=>'0xefeed7'},
		{'name'=>'Estrellian', 'hp'=>2500, 'icon'=>'estrellian', 'trap'=>'no', 'color'=>'0x923023'}
	]
	$items = [
		{'name'=>'Potion', 'image'=>'item_icon_01', 'throw'=>false},
		{'name'=>'Antidote', 'image'=>'4', 'throw'=>false},
		{'name'=>'Cool Drink', 'image'=>'item_icon_09', 'throw'=>false},
		{'name'=>'Hot Drink', 'image'=>'item_icon_10', 'throw'=>false},
		{'name'=>'Dash Juice', 'image'=>'item_icon_11', 'throw'=>false},
		{'name'=>'Lifepowder', 'image'=>'item_icon_58', 'throw'=>true},
		{'name'=>'Chilled Meat', 'image'=>'item_icon_17', 'throw'=>true},
		{'name'=>'Hot Meat', 'image'=>'item_icon_18', 'throw'=>true},
		{'name'=>'Poisoned Meat', 'image'=>'item_icon_22', 'throw'=>true},
		{'name'=>'Drugged Meat', 'image'=>'item_icon_23', 'throw'=>true},
		{'name'=>'Tinged Meat', 'image'=>'item_icon_24', 'throw'=>true},
		{'name'=>'Vitality Agent', 'image'=>'item_icon_12', 'throw'=>false},
		{'name'=>'Energy Drink', 'image'=>'item_icon_11', 'throw'=>false},
		{'name'=>'Mega Nutrients', 'image'=>'item_icon_53', 'throw'=>false},
		{'name'=>'Demondrug', 'image'=>'item_icon_10', 'throw'=>false},
		{'name'=>'Armorskin', 'image'=>'item_icon_13', 'throw'=>false},
		{'name'=>'Mega Potion', 'image'=>'item_icon_89', 'throw'=>false},
		{'name'=>'Mega Demondrug', 'image'=>'item_icon_91', 'throw'=>false},
		{'name'=>'Mega Nutrients', 'image'=>'item_icon_93', 'throw'=>false},
		{'name'=>'Special Medicine', 'image'=>'item_icon_93', 'throw'=>false},
		{'name'=>'Awakening', 'image'=>'item_icon_93', 'throw'=>false},
		{'name'=>'Shock Trap', 'image'=>'item_icon_03', 'throw'=>false},
		{'name'=>'Flash Bomb', 'image'=>'item_icon_06', 'throw'=>true},
		{'name'=>'Sonic Bomb', 'image'=>'item_icon_07', 'throw'=>true},
		{'name'=>'Paintball', 'image'=>'item_icon_25', 'throw'=>true},
		{'name'=>'Smoke Bomb', 'image'=>'item_icon_81', 'throw'=>true},
		{'name'=>'Deodorant', 'image'=>'item_icon_80', 'throw'=>true},
		{'name'=>'Poison Smoke Bomb', 'image'=>'item_icon_82', 'throw'=>true},
		{'name'=>'Farcaster', 'image'=>'item_icon_83', 'throw'=>true},
		{'name'=>'Tranq Bomb', 'image'=>'item_icon_30', 'throw'=>true},
		{'name'=>'Pitfall Trap', 'image'=>'item_icon_31', 'throw'=>false},
		{'name'=>'Barrel Bomb S', 'image'=>'item_icon_37', 'throw'=>true},
		{'name'=>'Barrel Bomb L', 'image'=>'item_icon_38', 'throw'=>true},
		{'name'=>'Dung Bomb', 'image'=>'18', 'throw'=>true},
		{'name'=>'Sonic Grenade', 'image'=>'item_icon_47', 'throw'=>true},
		{'name'=>'Dynamite', 'image'=>'item_icon_38', 'throw'=>true},
		{'name'=>'Pickaxe', 'image'=>'prop_tool_03', 'throw'=>true},
		{'name'=>'Bug Net', 'image'=>'prop_tool_04', 'throw'=>false},
		{'name'=>'Fishing Kit', 'image'=>'prop_tool_10', 'throw'=>false}
	]
	$levels = [
		0,
		100,
		255,
		475,
		770,
		1150,
		1625,
		2205,
		2900,
		3720,
		4675,
		5775,
		7030,
		8450,
		10045,
		11825,
		13800,
		15980,
		18375,
		20995,
		23850,
		26950,
		30305,
		33925,
		37820,
		42000,
		46475,
		51255,
		56350,
		61770,
		67525,
		73625,
		80080,
		86900,
		94095,
		101675,
		109650,
		118030,
		126825,
		136045,
		145700,
		155800,
		166355,
		177375,
		188870,
		200850,
		213325,
		226305,
		239800,
		253820,
		268375,
		283475,
		299130,
		315350,
		332145,
		349525,
		367500,
		386080,
		405275,
		425095,
		445550,
		466650,
		488405,
		510825,
		533920,
		557700,
		582175,
		607355,
		633250,
		659870,
		687225,
		715325,
		744180,
		773800,
		804195,
		835375,
		867350,
		900130,
		933725,
		968145,
		1003400,
		1039500,
		1076455,
		1114275,
		1152970,
		1192550,
		1233025,
		1274405,
		1316700,
		1359920,
		1404075,
		1449175,
		1495230,
		1542250,
		1590245,
		1639225,
		1689200,
		1740180,
		1792175,
		1845195,
		1899250
	]
end
