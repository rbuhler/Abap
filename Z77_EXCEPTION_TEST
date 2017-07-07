*&---------------------------------------------------------------------*
*& Report Z77_EXCEPTION_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z77_EXCEPTION_TEST.

CONSTANTS lc_number TYPE I VALUE 1.

IF lc_number = 1.
  TRY.
    PERFORM exception.
  CATCH cx_j_1bnfe_cf INTO DATA(ls_exception).
    WRITE: / ls_exception->get_text( ).
  ENDTRY.

ENDIF.

FORM exception RAISING cx_j_1bnfe_cf.

  RAISE EXCEPTION TYPE cx_j_1bnfe_cf EXPORTING textid = cx_j_1bnfe_cf=>entry_not_found
                                               attribute1 = CL_J_1BNFE_CF_CONSTANT=>C_TABLE_ACTIVE.
ENDFORM.
