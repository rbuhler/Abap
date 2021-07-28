class Z77CL_ABAP_PACKAGE definition
  public
  create public .

public section.

  methods GET_FG_OBJECTS .
  methods PRINT_OBJECTS
    importing
      !IV_OBJ_TYPE type TROBJTYPE .
  methods CONSTRUCTOR
    importing
      !IV_PACKAGE type DEVCLASS .
protected section.
private section.

  data GV_PACKAGE_ID type DEVCLASS .
  data GT_PACKAGE_OBJECTS type Z77_ABAP_PACKAGE_TT .
  data GO_OO_CLASS type ref to CL_OO_CLASS .

  methods GET_CLASS_ATTR
    importing
      !IV_CLASS_NAME type SEOCLSNAME
    exporting
      !EO_OO_CLASS type ref to CL_OO_CLASS .
ENDCLASS.



CLASS Z77CL_ABAP_PACKAGE IMPLEMENTATION.


  method CONSTRUCTOR.

    gv_package_id = iv_package.
    CONDENSE gv_package_id.

  endmethod.


  method GET_CLASS_ATTR.

    DATA lo_oo_class TYPE REF TO cl_oo_class.

    TRY .

      CREATE OBJECT lo_oo_class
        EXPORTING
          clsname                   = iv_class_name
          with_inherited_components = 'X'
          with_interface_components = 'X'.
    CATCH cx_class_not_existent. " Class Does Not Exist
    ENDTRY.

    eo_oo_class = lo_oo_class.

  endmethod.


  METHOD get_fg_objects.

    CALL METHOD Z77CL_ABAP_TADIR_WRAP=>z77if_abap_tadir_wrap~load_package_objects
      EXPORTING
        iv_package_id      = gv_package_id
      IMPORTING
        et_package_objects = gt_package_objects.

        SORT gt_package_objects BY object obj_name.

  ENDMETHOD.


  METHOD print_objects.

    DATA ls_objects TYPE z77_abap_package_st.

    WRITE: '-----------------------------------------------------------------',/.
    WRITE: 'PACKAGE     :', gv_package_id ,/.
    WRITE: 'OBJECT TYPE :', iv_obj_type,/.
    WRITE: '-----------------------------------------------------------------',/.

    LOOP AT gt_package_objects INTO ls_objects.

      CASE ls_objects-object.
        WHEN iv_obj_type.

          WRITE: ls_objects-obj_name, /.
        WHEN OTHERS.              " skipp
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
