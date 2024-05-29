
#include <lzodefs.h>
#include <lzoconf.h>
#include <lzo1x.h>
#include <assert.h>
#include <memory.h>

#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/callback.h>

static void raise_error(char const* s)
{
  static const value* exn = NULL;
  if (NULL == exn)
  {
    exn = caml_named_value("Lzo.Error");
    assert(NULL != exn);
  }
  caml_raise_with_string(*exn, s);
}

CAMLprim value caml_lzo_init(value unit)
{
  CAMLparam1(unit);
  if (LZO_E_OK != lzo_init())
    raise_error("init");
  CAMLreturn(Val_unit);
}

CAMLprim value caml_lzo_adler32(value v_s, value v_ofs, value v_len)
{
  CAMLparam3(v_s,v_ofs,v_len);
  lzo_uint32 checksum = lzo_adler32(0, NULL, 0);
  checksum = lzo_adler32(checksum, &Byte_u(v_s,Int_val(v_ofs)), Int_val(v_len));
  CAMLreturn(caml_copy_int32(checksum));
}

CAMLprim value caml_lzo_compress(value v_s, value v_ofs, value v_len)
{
  CAMLparam3(v_s, v_ofs, v_len);
  CAMLlocal1(v_out);
  lzo_uint len = Int_val(v_len);
  lzo_uint out_len = 0;
  lzo_uint wrkmem_size = LZO1X_1_15_MEM_COMPRESS;
  lzo_bytep mem = caml_stat_alloc(wrkmem_size + len + len / 16 + 64 + 3);
  lzo_bytep wrk = mem;
  lzo_bytep out = mem + wrkmem_size;
  int r = 0;

  r = lzo1x_1_15_compress(&Byte_u(v_s, Int_val(v_ofs)), len, out, &out_len, wrk);
  assert(LZO_E_OK == r && out_len < len + len / 16 + 64 + 3);

  /*
  if (out_len > len)
  {
    caml_stat_free(mem);
    raise_error("caml_lzo_compress");
  }
  */

  v_out = caml_alloc_initialized_string(out_len, out);
  caml_stat_free(mem);

  CAMLreturn(v_out);
}

CAMLprim value caml_lzo_decompress(value v_s, value v_ofs, value v_len, value v_size)
{
  CAMLparam4(v_s,v_ofs,v_len,v_size);
  CAMLlocal1(v_out);
  lzo_uint len = Int_val(v_len);
  v_out = caml_alloc_string(Int_val(v_size));
  lzo_uint out_len = Int_val(v_size);
  int r = lzo1x_decompress_safe(&Byte_u(v_s, Int_val(v_ofs)), len, &Byte_u(v_out,0), &out_len, NULL);
  if (r != LZO_E_OK || Int_val(v_size) != out_len)
  {
    /*fprintf(stderr,"caml_lzo_decompress: failed (r=%d,len=%d,size=%d,out_len=%d)\n", r, len, Int_val(v_size), out_len);*/
    raise_error("decompress");
  }
  CAMLreturn(v_out);
}

