import re
import sys
icg_file = "output_file.txt"

istemp = lambda s : bool(re.match(r"^t[0-9]*$", s)) 
isid = lambda s : bool(re.match(r"^[A-Za-z][A-Za-z0-9_]*$", s)) #will match temp also

binary_operators = {"+", "-", "*", "/", "*", "&", "|", "^", ">>", "<<", "==", ">=", "<=", "!=", ">", "<"}

def printicg(list_of_lines, message = "") :
	print(message.upper())
	for line in list_of_lines :
		print(line.strip())


def remove_dead_code(list_of_lines) :
	num_lines = len(list_of_lines)
	temps_on_lhs = set()
	for line in list_of_lines :
		tokens = line.split()
		if istemp(tokens[0]) :
			temps_on_lhs.add(tokens[0])

	useful_temps = set()
	for line in list_of_lines :
		tokens = line.split()
		if len(tokens) >= 2 :
			if istemp(tokens[1]) :
				useful_temps.add(tokens[1])
		if len(tokens) >= 3 :
			if istemp(tokens[2]) :	
				useful_temps.add(tokens[2])

	temps_to_remove = temps_on_lhs - useful_temps
	new_list_of_lines = []
	for line in list_of_lines :
		tokens = line.split()
		if tokens[0] not in temps_to_remove :
			new_list_of_lines.append(line)
	if num_lines == len(new_list_of_lines) :
		return new_list_of_lines
	return remove_dead_code(new_list_of_lines)
				

if __name__ == "__main__" :

	if len(sys.argv) == 2 :
		icg_file = str(sys.argv[1])
	
	list_of_lines = []
	f = open(icg_file, "r")
	for line in f :
		list_of_lines.append(line)
	f.close()

	printicg(list_of_lines, "ICG")
	without_deadcode = remove_dead_code(list_of_lines)
	printicg(without_deadcode, "Optimized ICG after removing dead code")
	print("Eliminated", len(list_of_lines)-len(without_deadcode), "lines of code")




	
	
	
