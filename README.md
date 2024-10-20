# CDS View - Purchasing report for follow-up
**Built with:** 🛠️ </br>
- SAP Logon
- Eclipse IDE com o plugin ADT (ABAP Development Tools) </br>

## Objective and Details
- Goal: Control the PO Approval Status</br>

- Tables Involved and Joins:</br>
EKKO (Purchase order headers) – Main table for purchase order headers.</br>
CDHDR (Change header logs): Tracks change logs (linked to PO by objectid).
CDPOS (Change item logs): Records specific changes (linked by changenr).

- Associations:</br>
Links to zcds_last_change to fetch the latest change for each PO.

- Selected Fields:</br>
PedidoCompra: Purchase order number.</br>
DATA_CRIACAO: PO creation date.</br>
DATA_FIM: Last change date.</br>

- Status Calculation (CASE Statement):</br>
'G' → "APROVADO" (Approved).</br>
'B' → "EM APROVAÇÃO" (In Approval).</br>
Else → "STATUS INDEFINIDO" (Undefined).</br>

- Filters (WHERE Clause):</br>
Includes only POs with 'G' or 'B' status.</br>
Ensures the latest change is considered.</br>




## Summary 📋:
This CDS View is designed to generate a comprehensive report on purchase orders: </br></br>

This query helps extract key purchase order statuses along with their creation and last modification dates.


**Purchase Follow-up ABAP CDS View** ⚙️
```abap
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
```


**Purchase Follow-up ABAP CDS View** ⚙️
```abap
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
```

## Assignment of a CDS View to a Transaction Code (T-Code) 

### Summary 📋
Assigning a CDS View to a transaction code allows users to access the view directly through a shortcut in SAP GUI or Fiori, simplifying navigation.

**1. Steps Overview:**
- Create a New Transaction Code (T-Code):

**2. Use SE93 to create the transaction code.**
- Link CDS View to the T-Code:
- In SE93, select the "Program and Selection Screen" or "Report" option if the CDS is used within a report or Fiori App.
- Alternatively, link the T-Code to an Application UI that consumes the CDS view. 
**3. Usage:**
- Once created, the transaction code acts as a direct entry point, simplifying access to the CDS view.

**Purpose:**
- Facilitates quick access to reports or applications based on CDS views.
- Avoids complex menu navigation for end-users.
- This process ensures that business users or analysts can efficiently access key data through a simple T-Code shortcut 


## Assignment an OData Service
Would you like to know how to creat a OData Service and consume inside an Excel, Power BI etc? 

<a href="https://github.com/GabrielHirt/CDS_View-OData_Creation/blob/main/README.md">Check it out!</a>

<!-- -->

## Reference
### Introduction SAP CDS View Course 
https://learning.sap.com/learning-journeys/acquire-core-abap-skills/defining-basic-cds-views_44d04348-d743-3ad4-b581-44e37262ddc3

![image](https://github.com/user-attachments/assets/501b62c3-fc70-4b89-b534-4eb4f4657f15)



