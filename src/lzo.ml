
exception Error of string

external init : unit -> unit = "caml_lzo_init"
external unsafe_adler32 : string -> int -> int -> int32 = "caml_lzo_adler32"
external unsafe_compress : string -> int -> int -> string = "caml_lzo_compress"
external unsafe_decompress : string -> int -> int -> int -> string = "caml_lzo_decompress"

let validate s ofs len name =
  if ofs < 0 || len < 0 || ofs > String.length s - len then invalid_arg ("Lzo."^name)

let adler32_sub s ofs len =
  validate s ofs len "adler32";
  unsafe_adler32 s ofs len

let compress_sub s ofs len =
  validate s ofs len "compress";
  unsafe_compress s ofs len

let decompress_sub s ofs len size =
  validate s ofs len "decompress";
  unsafe_decompress s ofs len size

let adler32 s = unsafe_adler32 s 0 (String.length s)
let compress s = unsafe_compress s 0 (String.length s)
let decompress s size = unsafe_decompress s 0 (String.length s) size

let () =
  Callback.register_exception "Lzo.Error" (Error "");
  init ()

