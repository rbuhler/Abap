class Z77CL_ABAP_TADIR_WRAP definition
  public
  create public .

public section.

  interfaces Z77IF_ABAP_TADIR_WRAP .

  aliases LOAD_PACKAGE_OBJECTS
    for Z77IF_ABAP_TADIR_WRAP~LOAD_PACKAGE_OBJECTS .
protected section.
private section.
ENDCLASS.



CLASS Z77CL_ABAP_TADIR_WRAP IMPLEMENTATION.


  METHOD z77if_abap_tadir_wrap~load_package_objects.

    DATA ls_package_objects TYPE z77_abap_package_st.

    CLEAR et_package_objects.

    SELECT devclass object obj_name
           FROM tadir
           INTO ls_package_objects
           WHERE devclass = iv_package_id.

      APPEND ls_package_objects TO et_package_objects.

    ENDSELECT.

  ENDMETHOD.
ENDCLASS.
