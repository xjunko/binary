module main

import encoding.binary
import math.bits

interface Numbers {}

// swaps - /shrug
fn swap16(n u16) u16 {
	return bits.reverse_bytes_16(n)
}

fn swap32(n u32) u32 {
	return bits.reverse_bytes_32(n)
}

fn swap64(n u64) u64 {
	return bits.reverse_bytes_64(n)
}


// https://github.com/WolvesFortress/VRakLib/blob/rewrite/bytebuffer.v#L508
fn swapfloat(n f32) f32 {
	// fucking bullshit
	unsafe {
		as_int := &u32(&n)
		v := swap32(u32(*as_int))
		as_float := &f32(&v)
		return *as_float
	}
}

// https://github.com/WolvesFortress/VRakLib/blob/rewrite/bytebuffer.v#L508
fn swapdouble(n f64) f64 {
	// another one lol
	unsafe {
		as_int := &u64(&n)
		v := swap64(u64(*as_int))
		as_double := &f64(&v)
		return *as_double
	}
}

//

fn get_size(n Numbers) int {
	return match n {
		i16, u16 { int(sizeof(u16)) }
		int, u32, f32 { int(sizeof(u32)) }
		i64, u64, f64 { int(sizeof(u64)) }
		else { int(0) }
	}
}

pub fn make_int(n Numbers) []byte {
	// support i16, u16, i32, u32, i64, u64, f32, f64
	mut bytes := []byte{len: get_size(n)}

	match n {
		i16 { make_short(mut bytes, *n) }
		u16 { binary.little_endian_put_u16(mut bytes, *n) }
		int { make_int_(mut bytes, *n) }
		u32 { binary.little_endian_put_u32(mut bytes, *n) }
		i64 { make_long(mut bytes, *n) }
		u64 { binary.little_endian_put_u64(mut bytes, *n) }
		f32 { make_float(mut bytes, *n) }
		f64 { make_double(mut bytes, *n) }

		else { println('Invalid type!') }
	}

	return bytes
}

fn make_short(mut bytes []byte, nn i16) {
	// suffering
	n := i16(swap16(u16(nn)))

	bytes[0] = byte(n >> i16(8))
	bytes[1] = byte(n)	
}

fn make_int_(mut bytes []byte, nn int) {
	// suffering
	n := int(swap32(u32(nn)))

	bytes[0] = byte(n >> int(24))
	bytes[1] = byte(n >> int(16))
	bytes[2] = byte(n >> int(8))
	bytes[3] = byte(n)
}

fn make_long(mut bytes []byte, nn i64) {
	// suffering
	n := i64(swap64(u64(nn)))

	// sheeeeeeesh im sure theres a better way to do this
	bytes[0] = byte(n >> i64(56))
	bytes[1] = byte(n >> i64(48))
	bytes[2] = byte(n >> i64(40))
	bytes[3] = byte(n >> i64(32))
	bytes[4] = byte(n >> i64(24))
	bytes[5] = byte(n >> i64(16))
	bytes[6] = byte(n >> i64(8))
	bytes[7] = byte(n)
}

fn make_float(mut bytes []byte, nn f32) {
	n := swapfloat(nn)
	as_int := unsafe { &u32(&n) }

	bytes[0] = byte(u32(*as_int) >> u32(24))
	bytes[1] = byte(u32(*as_int) >> u32(16))
	bytes[2] = byte(u32(*as_int) >> u32(8))
	bytes[3] = byte(u32(*as_int))
}

fn make_double(mut bytes []byte, nn f64) {
	// :ok_hand: :ok_hand: :ok_hand: :ok_hand:
	n := swapdouble(nn)
	as_int := unsafe { &u64(&n) }

	bytes[0] = byte(u64(*as_int) >> u64(56))
	bytes[1] = byte(u64(*as_int) >> u64(48))
	bytes[2] = byte(u64(*as_int) >> u64(40))
	bytes[3] = byte(u64(*as_int) >> u64(32))
	bytes[4] = byte(u64(*as_int) >> u64(24))
	bytes[5] = byte(u64(*as_int) >> u64(16))
	bytes[6] = byte(u64(*as_int) >> u64(8))
	bytes[7] = byte(u64(*as_int))
}

fn main() {
	println(make_int(i16(-32)))

}