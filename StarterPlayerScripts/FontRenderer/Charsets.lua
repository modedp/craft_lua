local l_Assets_l = require(game:GetService("ReplicatedStorage").Assets)
return {
	standard1 = {
		texture = l_Assets_l.fonts["font-standard1"], 
		sheetSize = Vector2.new(10, 10), 
		characters = { { "!", "\"", "\194\163", "$", "%", "^", "&", "*", "(", ")" }, { "-", "=", "_", "+", "`", "{", "}", "[", "]", ";" }, { ":", "@", "'", "~", "#", "|", "\\", "/", "<", ">" }, { ",", ".", "?", "a", "b", "c", "d", "e", "f", "g" }, { "h", "i", "j", "k", "l", "m", "n", "o", "p", "q" }, { "r", "s", "t", "u", "v", "w", "x", "y", "z", "A" }, { "B", "C", "D", "E", "F", "G", "H", "I", "J", "K" }, { "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U" }, { "V", "W", "X", "Y", "Z", "\194\172", "0", "1", "2", "3" }, { "4", "5", "6", "7", "8", "9", " ", "\n", "\194\167", "" } }, 
		widths = { { 1, 3, 5, 5, 5, 5, 6, 3, 3, 3 }, { 5, 5, 5, 5, 1, 4, 4, 3, 3, 1 }, { 1, 6, 1, 6, 5, 1, 5, 5, 4, 4 }, { 1, 1, 5, 5, 5, 5, 5, 5, 4, 5 }, { 5, 1, 3, 4, 1, 7, 5, 5, 5, 5 }, { 4, 5, 4, 5, 5, 7, 5, 5, 5, 5 }, { 5, 5, 5, 5, 5, 5, 5, 3, 5, 5 }, { 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 }, { 5, 5, 5, 5, 5, 5, 5, 2, 5, 5 }, { 5, 5, 5, 5, 5, 5, 6, 7, 5, 7 } }
	}, 
	standard2 = {
		texture = l_Assets_l.fonts["font-standard2"], 
		sheetSize = Vector2.new(10, 10), 
		characters = { { "\194\166", "\194\169", "\194\174", "\194\176", "\194\177", "\194\185", "\194\178", "\194\179", "\226\129\180", "\194\182" }, { "\194\188", "\194\189", "\194\190", "\195\151", "\195\183", "\226\128\147", "\226\128\148", "\226\128\152", "\226\128\153", "\226\128\154" }, { "\226\128\156", "\226\128\157", "\226\128\158", "\226\128\162", "\194\183", "\226\128\166", "\226\129\132", "\226\136\146", "\226\136\149", "\226\132\162" } }, 
		widths = { { 1, 7, 7, 3, 5, 2, 3, 3, 3, 6 }, { 7, 7, 7, 5, 5, 3, 6, 1, 1, 1 }, { 3, 3, 3, 4, 4, 5, 5, 5, 5, 7 } }
	}, 
	international1 = {
		texture = l_Assets_l.fonts["font-international1"], 
		sheetSize = Vector2.new(10, 10), 
		characters = { { "\195\128", "\195\129", "\195\130", "\195\131", "\195\132", "\195\133", "\195\134", "\195\135", "\195\136", "\195\137" }, { "\195\138", "\195\139", "\195\140", "\195\141", "\195\142", "\195\143", "\195\144", "\195\145", "\195\146", "\195\147" }, { "\195\148", "\195\149", "\195\150", "\195\152", "\195\153", "\195\154", "\195\155", "\195\156", "\195\157", "\195\158" }, { "\195\159", "\195\160", "\195\161", "\195\162", "\195\163", "\195\164", "\195\165", "\195\166", "\195\167", "\195\168" }, { "\195\169", "\195\170", "\195\171", "\195\172", "\195\173", "\195\174", "\195\175", "\195\176", "\195\177", "\195\178" }, { "\195\179", "\195\180", "\195\181", "\195\182", "\195\184", "\195\185", "\195\186", "\195\187", "\195\188", "\194\181" }, { "\195\189", "\195\190", "\195\191", "\196\177", "\197\146", "\197\147", "\194\164", "\194\165", "\226\130\172", "\194\162" }, { "\194\170", "\194\186", "\226\128\185", "\226\128\186", "\194\171", "\194\187", "\197\184", "\225\186\158", "\206\145", "\206\146" }, { "\206\147", "\206\148", "\206\149", "\206\150", "\206\151", "\206\152", "\206\153", "\206\154", "\206\155", "\206\156" }, { "\206\157", "\206\158", "\206\159", "\206\160", "\206\161", "\206\163", "\206\164", "\206\165", "\206\166", "\206\167" } }, 
		widths = { { 5, 5, 5, 5, 5, 5, 7, 5, 5, 5 }, { 5, 5, 3, 3, 3, 3, 6, 5, 5, 5 }, { 5, 5, 5, 7, 5, 5, 5, 5, 5, 4 }, { 5, 5, 5, 5, 5, 5, 5, 7, 5, 5 }, { 5, 5, 5, 2, 2, 3, 3, 5, 5, 5 }, { 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 }, { 5, 4, 5, 1, 7, 7, 5, 5, 6, 5 }, { 3, 3, 3, 3, 5, 5, 5, 5, 5, 5 }, { 4, 5, 5, 5, 5, 6, 3, 5, 5, 5 }, { 5, 5, 5, 6, 5, 5, 5, 5, 5, 5 } }
	}, 
	international2 = {
		texture = l_Assets_l.fonts["font-international2"], 
		sheetSize = Vector2.new(10, 10), 
		characters = { { "\206\168", "\206\169", "\206\177", "\206\178", "\206\179", "\206\180", "\206\181", "\206\182", "\206\183", "\206\184" }, { "\206\185", "\206\186", "\206\187", "\206\188", "\206\189", "\206\190", "\206\191", "\207\128", "\207\129", "\207\130" }, { "\207\131", "\207\132", "\207\133", "\207\134", "\207\135", "\207\136", "\207\137" } }, 
		widths = { { 5, 6, 5, 5, 5, 5, 4, 5, 5, 5 }, { 2, 4, 5, 5, 5, 5, 5, 5, 5, 5 }, { 6, 5, 5, 5, 5, 5, 7 } }
	}
};
