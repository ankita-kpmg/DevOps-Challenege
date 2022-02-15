#_________Recursive Function_________________
def get_val(obj, key):
	return obj[key]

def get_nested_val(obj, key, index=0):
	val = ""
	if "/" in key:
		if len(key.split("/")) > 1:
			key_arr = key.split("/")
			val = get_val(obj,key_arr[index])
			if index < len(key_arr)-1:
				val = get_nested_val(val, key, index+1)
				return val
			else:
				return val

object_dict = {"a":{"b":{"c":"d"}}}
key = "a/b/c"
final_val = get_nested_val(object_dict, key)
print(final_val)
