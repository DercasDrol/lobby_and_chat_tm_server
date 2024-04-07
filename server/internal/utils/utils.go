package utils

func DeleteSliceStringElement(s []string, element string) []string {
	index := -1
	for k, v := range s {
		if element == v {
			index = k
			break
		}
	}
	if index == -1 {
		return s
	} else {
		return append(s[:index], s[index+1:]...)
	}
}

func DeleteSliceIntElement(s []int, element int) []int {
	index := -1
	for k, v := range s {
		if element == v {
			index = k
			break
		}
	}
	if index == -1 {
		return s
	} else {
		return append(s[:index], s[index+1:]...)
	}
}

func ContainsInt(s []int, e int) bool {
	for _, a := range s {
		if a == e {
			return true
		}
	}
	return false
}

func ContainsString(s []string, e string) bool {
	for _, a := range s {
		if a == e {
			return true
		}
	}
	return false
}
