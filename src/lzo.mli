(** Bindings to LZO compression/decompression *)

exception Error of string

(** {1 Unsafe}

Two [int] parameters are offset and length of substring in the source string.
No bounds checking is performed.
*)

val unsafe_adler32 : string -> int -> int -> int32
val unsafe_compress : string -> int -> int -> string
val unsafe_decompress : string -> int -> int -> int -> string

(** {1 Substrings}

Two [int] parameters are offset and length of substring in the source string.
Out of bounds access attempts will result in [Invalid_argument] exception.
*)

val adler32_sub : string -> int -> int -> int32
val compress_sub : string -> int -> int -> string
val decompress_sub : string -> int -> int -> int -> string

(** {1 Convenience} *)

val adler32 : string -> int32
val compress : string -> string
val decompress : string -> int -> string

