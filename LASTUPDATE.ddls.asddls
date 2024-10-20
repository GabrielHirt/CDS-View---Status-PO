@AbapCatalog.sqlViewName: 'ZCDS_LAST_CHANGE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ultimo status de PO, aprovação'

define view CDS_LAST_CHANGE
    as select from cdhdr
{
    cdhdr.objectid,
    max(cdhdr.changenr) as max_changenr
}
group by cdhdr.objectid