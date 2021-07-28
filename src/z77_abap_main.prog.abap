*&---------------------------------------------------------------------*
*& Report Z77_ABAP_MAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z77_abap_main.

DATA lv_package TYPE devclass.
DATA lo_package TYPE REF TO z77cl_abap_package.

lv_package = 'GLO-EDO-BR'.

CREATE OBJECT lo_package
  EXPORTING
    iv_package = lv_package.

lo_package->get_fg_objects( ).

lo_package->print_objects('CLAS').
lo_package->print_objects('INTF').

lo_package->print_objects('FUGR').
lo_package->print_objects('PROG').
