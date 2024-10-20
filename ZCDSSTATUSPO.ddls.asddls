@AbapCatalog.sqlViewName: 'Z_CSD_STATUSPO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status AP. PO'

define view ZCDS_STATUSPO
    as select from ekko
    left outer join cdhdr
        on ekko.ebeln = cdhdr.objectid
    left outer join cdpos
        on cdhdr.changenr = cdpos.changenr
    association [1..1] to zcds_last_change as _latest_change
        on cdhdr.changenr = _latest_change.max_changenr
{
    key cdhdr.objectid as PedidoCompra,                     ---> Número do pedido de compra
    ekko.aedat as DATA_CRIACAO,                             ---> Data de criação
    cdhdr.udate as DATA_FIM,

    case
        when cdpos.value_new = 'G' then 'APROVADO'         ---> Se 'G', status "APROVADO"
        when cdpos.value_new = 'B' then 'EM APROVAÇÃO'     ---> Se 'B', status "EM APROVAÇÃO"
        else 'STATUS INDEFINIDO'
    end as StatusPedido
}
where

    (cdpos.value_new = 'G' or cdpos.value_new = 'B') 
    and cdhdr.changenr = _latest_change.max_changenr;       ---> Filtrar pelo maior changenr