*&---------------------------------------------------------------------*
*& Report Z77_JSON
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z77_JSON.
  DATA lv_docnum TYPE j_1bdocnum VALUE 0000000106.

  DATA ls_active TYPE j_1bnfe_active.
  DATA lv_json   TYPE string.
* Testing ABAP Git
* Serialize
  lv_json = Z77CL_JSON=>load_json( iv_docnum = lv_docnum ).
* deSerialize
  ls_active = Z77CL_JSON=>load_ddic( iv_json = lv_json ).

* Linha nova
  BREAK-POINT.
