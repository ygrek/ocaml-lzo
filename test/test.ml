
let () =
  Random.self_init ();
  let check n =
    let s =
      let s = Bytes.create n in
      for i = 0 to pred n do Bytes.set s i (Char.chr (Random.int 256)) done;
      Bytes.unsafe_to_string s
    in
    assert (s = Lzo.decompress (Lzo.compress s) (String.length s));
  in
  for n = 0 to 1024 do check n done;
  for _ = 0 to 1024 do check (Random.int 16384 + 16384) done;
  ()

