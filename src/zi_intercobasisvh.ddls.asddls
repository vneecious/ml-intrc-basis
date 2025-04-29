@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for ZI_intercoBasisFlat'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_IntercoBasisVH
  as select distinct from ZI_IntercoBasisFlat
{
  key Id,
  key Providercompanycode as CompanyCode,
  key Fiscalyear,
  key Fiscalperiod,
  key Ledger,
  key PaymentType,
      IsReleased,
      CreatedBy,
      CreatedAt,
      Description
}
