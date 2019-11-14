*&---------------------------------------------------------------------*
*& Report Z77_COMPANY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z77_COMPANY.

CONSTANTS lc_party  TYPE PARTY VALUE 'J_1BCG'.
CONSTANTS lc_brazil TYPE LAND1 VALUE 'BR'.

DATA:
  BEGIN OF ls_company_structure,
    company TYPE BUKRS,
    plant   TYPE BWKEY,
    bupla   TYPE J_1BBRANC_,
    cnpj    TYPE STRING,
  END OF ls_company_structure.

DATA lv_cnpj_cc     TYPE PAVAL.

DATA lt_company           TYPE TABLE OF T001.
DATA lt_company_structure LIKE TABLE OF ls_company_structure.

DATA ls_company    TYPE T001.
DATA ls_plant      TYPE T001K.
DATA ls_bupla      TYPE T001W.
DATA ls_bupla_info TYPE J_1BBRANCH.

SELECT * FROM T001 INTO ls_company
                   WHERE LAND1 = lc_brazil.

  SELECT SINGLE PAVAL FROM T001Z INTO lv_cnpj_cc
                                WHERE BUKRS = ls_company-bukrs
                                AND   PARTY = lc_party.

  SELECT * FROM T001K INTO ls_plant
                      WHERE BUKRS = ls_company-bukrs.

    SELECT * FROM T001W INTO ls_bupla
                       WHERE WERKS = ls_plant-bwkey.

      SELECT * FROM J_1BBRANCH INTO ls_bupla_info
                              WHERE BUKRS = ls_company-bukrs
                                AND BRANCH = ls_bupla-j_1bbranch.

        ls_company_structure-company = ls_company-bukrs.
        ls_company_structure-plant   = ls_plant-bwkey.
        ls_company_structure-bupla   = ls_bupla-j_1bbranch.

        CONDENSE lv_cnpj_cc.
        CONCATENATE lv_cnpj_cc(2) '.' lv_cnpj_cc+2(3) '.' lv_cnpj_cc+5(3)
                    '/' ls_bupla_info-cgc_branch
                    INTO ls_company_structure-cnpj.


        WRITE: 'CCode : ',ls_company_structure-company ,' ',
               'Plant : ',ls_company_structure-plant   ,' ',
               'Bupla : ',ls_company_structure-bupla   ,' ',
               'CNPJ  : ',ls_company_structure-cnpj, /.

        APPEND ls_company_structure TO lt_company_structure.

      ENDSELECT.
    ENDSELECT.
  ENDSELECT.
ENDSELECT.

BREAK-POINT.
