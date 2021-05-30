module main

pub fn write_uleb128(num_ int) []byte {
	if num_ == 0 {
		return []byte{len: 1}
	}

	mut bytes := []byte{}
	mut length := 0
	mut num := num_ // this is retarded


	for num > 0 {
		bytes << byte((num & 127))
		num >>= 7
		if num != 0 {
			bytes[length] |= 128
		}
		length++
	}

	return bytes

}

pub fn make_string(s string) []byte {
	if s.len == 0 {
		return []byte{len: 1}
	}

	mut bytes := []byte{}
	bytes << byte(11)
	bytes << write_uleb128(s.len)
	bytes << s.bytes()

	return bytes
}

fn test() {
	println(
		make_string('deez nuts')
		)
}