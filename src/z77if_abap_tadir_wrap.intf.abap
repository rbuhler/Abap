interface Z77IF_ABAP_TADIR_WRAP
  public .


  class-methods LOAD_PACKAGE_OBJECTS
    importing
      !IV_PACKAGE_ID type DEVCLASS
    exporting
      !ET_PACKAGE_OBJECTS type Z77_ABAP_PACKAGE_TT .
endinterface.
