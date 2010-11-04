
exception Error of string

val unsafe_adler32 : string -> int -> int -> int32
val unsafe_compress : string -> int -> int -> string
val unsafe_decompress : string -> int -> int -> int -> string

val adler32_sub : string -> int -> int -> int32
val compress_sub : string -> int -> int -> string
val decompress_sub : string -> int -> int -> int -> string

val adler32 : string -> int32
val compress : string -> string
val decompress : string -> int -> string

