class Z77CL_JSON definition
  public
  final
  create public .

public section.

  class-methods LOAD_JSON
    importing
      !IV_DOCNUM type J_1BDOCNUM
    returning
      value(RV_JSON) type STRING .
  class-methods LOAD_DDIC
    importing
      !IV_JSON type STRING
    returning
      value(RT_ACTIVE) type J_1BNFE_ACTIVE .
  class-methods LOAD_NFE_JSON
    importing
      !IV_DOCNUM type J_1BDOCNUM
      !IV_RFC type STRING .
protected section.
private section.
ENDCLASS.



CLASS Z77CL_JSON IMPLEMENTATION.


  method LOAD_DDIC.
* https://wiki.scn.sap.com/wiki/display/Snippets/One+more+ABAP+to+JSON+Serializer+and+Deserializer

*   deserialize JSON string json into internal table lt_flight doing camelCase to ABAP like field name mapping
  /ui2/cl_json=>deserialize( EXPORTING json = iv_json pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = rt_active ).

  endmethod.


  method LOAD_JSON.
  DATA ls_active TYPE J_1BNFE_ACTIVE.
  DATA lt_active TYPE TABLE OF J_1BNFE_ACTIVE.

  SELECT SINGLE * FROM J_1BNFE_ACTIVE
                  INTO ls_active
                 WHERE docnum = iv_docnum.
  APPEND ls_active TO lt_active.

  rv_json = /ui2/cl_json=>serialize( data = lt_active compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

  endmethod.


  method LOAD_NFE_JSON.
*    DATA LO_NFE_400 TYPE REF TO cl_j_1bnfe_cf_authorize_310.

    DATA lv_docnum TYPE j_1bdocnum.
    DATA lv_rfc    TYPE string.

    DATA wk_header TYPE j_1bnfdoc.
    DATA ls_acckey TYPE j_1b_nfe_access_key.
    DATA lv_msstat TYPE j_1bnfe_ms_status.
*
    DATA wk_item          TYPE TABLE OF j_1bnflin.
    DATA wk_partner       TYPE TABLE OF j_1bnfnad.
    DATA wk_item_tax      TYPE TABLE OF j_1bnfstx.
    DATA wk_header_msg    TYPE TABLE OF j_1bnfftx.
    DATA wk_refer_msg     TYPE TABLE OF j_1bnfref.
    DATA wk_ot_partner    TYPE TABLE OF j_1bnfcpd.
    DATA wk_import_di     TYPE TABLE OF j_1bnfimport_di.
    DATA wk_import_adi    TYPE TABLE OF j_1bnfimport_adi.
    DATA wk_trans_volumes TYPE TABLE OF j_1bnftransvol.
    DATA wk_trailer_info  TYPE TABLE OF j_1bnftrailer.
    DATA wk_trade_notes   TYPE TABLE OF j_1bnftradenotes.
    DATA wk_add_info      TYPE TABLE OF j_1bnfadd_info.
    DATA wk_ref_proc      TYPE TABLE OF j_1bnfrefproc.
    DATA wk_sugar_suppl   TYPE TABLE OF j_1bnfsugarsuppl.
    DATA wk_sugar_deduc   TYPE TABLE OF j_1bnfsugardeduc.
    DATA wk_vehicle       TYPE TABLE OF j_1bnfvehicle.
    DATA wk_pharmaceut    TYPE TABLE OF j_1bnfpharmaceut.
    DATA wk_fuel          TYPE TABLE OF j_1bnffuel.
    DATA wk_export        TYPE TABLE OF j_1bnfe_export.
    DATA wk_trace         TYPE TABLE OF j_1bnfetrace.
    DATA wk_pharma        TYPE TABLE OF j_1bnfepharma.
    DATA wk_payment       TYPE TABLE OF j_1bnfepayment.
    DATA wk_nve           TYPE TABLE OF j_1bnfnve.

    lv_docnum = iv_docnum.
    lv_rfc    = iv_rfc.

    CALL FUNCTION 'Z77J_1B_NF_DOCUMENT_READ' DESTINATION lv_rfc
      EXPORTING
        doc_number         = lv_docnum
     IMPORTING
        doc_header         = wk_header
      TABLES
        doc_partner        = wk_partner
        doc_item           = wk_item
        doc_item_tax       = wk_item_tax
        doc_header_msg     = wk_header_msg
        doc_refer_msg      = wk_refer_msg
        doc_ot_partner     = wk_ot_partner
        doc_import_di      = wk_import_di
        doc_import_adi     = wk_import_adi
        doc_trans_volumes  = wk_trans_volumes
        doc_trailer_info   = wk_trailer_info
        doc_trade_notes    = wk_trade_notes
        doc_add_info       = wk_add_info
        doc_ref_proc       = wk_ref_proc
        doc_sugar_suppl    = wk_sugar_suppl
        doc_sugar_deduc    = wk_sugar_deduc
        doc_vehicle        = wk_vehicle
        doc_pharmaceut     = wk_pharmaceut
        doc_fuel           = wk_fuel
        doc_export         = wk_export
        doc_nve            = wk_nve
        doc_traceability   = wk_trace
        doc_pharma         = wk_pharma
        doc_payment        = wk_payment
      EXCEPTIONS
        OTHERS             = 1.


    wk_header-bukrs = 'BR01'. "@gambiarra

    IF sy-subrc = 0.
* ------------------------------------------------------------
*     SET GLOBAL VARIABLES
* ------------------------------------------------------------
      DATA ls_branch_info TYPE j_1bnfe_branch_info.
      DATA lv_branch_cnpj TYPE stcd1.
      DATA ls_active      TYPE j_1bnfe_active.

      CALL FUNCTION 'Z77J_1BNFE_XML_RAED_ACTIVE_TAB' DESTINATION lv_rfc
      EXPORTING
        i_docnum = lv_docnum
      IMPORTING
        e_acttab = ls_active
      EXCEPTIONS
        no_entry      = 1
        error_message = 2
        OTHERS        = 3.

    ENDIF.
        ls_active-bukrs = 'BR01'. "@gambiarra

    IF sy-subrc = 0.

      ls_branch_info-bukrs      = ls_active-bukrs.
      ls_branch_info-branch     = ls_active-branch.
      ls_branch_info-model      = ls_active-model.
      ls_branch_info-regio      = ls_active-regio.
      ls_branch_info-rfcdest    = ''.
      ls_branch_info-xnfeactive = ''.

      lv_branch_cnpj = ls_active-stcd1.

      MOVE-CORRESPONDING ls_active to ls_acckey.

      CALL FUNCTION 'J_1B_NFE_CHECK_ACTIVE_SERVER'
        EXPORTING
          is_branch_info = ls_branch_info
          iv_branch_cnpj = lv_branch_cnpj.
* ------------------------------------------------------------

      CALL FUNCTION 'J_1B_NF_MAP_TO_XML'
        EXPORTING
          i_nfdoc                = wk_header
          i_acckey               = ls_acckey
        IMPORTING
          ev_msstat              = lv_msstat
        TABLES
          it_nflin               = wk_item
          it_nfnad               = wk_partner
          it_nfstx               = wk_item_tax
          it_nfftx               = wk_header_msg
          it_nfref               = wk_refer_msg
          it_nfcpd               = wk_ot_partner
          it_import_di           = wk_import_di
          it_import_adi          = wk_import_adi
          it_trans_volumes       = wk_trans_volumes
          it_trailer_info        = wk_trailer_info
          it_trade_notes         = wk_trade_notes
          it_add_info            = wk_add_info
          it_ref_proc            = wk_ref_proc
          it_sugar_suppl         = wk_sugar_suppl
          it_sugar_deduc         = wk_sugar_deduc
          it_vehicle             = wk_vehicle
          it_pharmaceut          = wk_pharmaceut
          it_fuel                = wk_fuel
          it_export              = wk_export
          it_nve                 = wk_nve
          it_pharma              = wk_pharma
          it_payment             = wk_payment
          it_trace               = wk_trace
       EXCEPTIONS
          OTHERS                 = 1.

      IF sy-subrc <> 0.
*     Implement suitable error handling here
      ENDIF.

    ENDIF.
  endmethod.
ENDCLASS.
