@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'join head bases and items bases'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_IntercoBasisFlat
  as select from ZI_IntercoBasisItem
  //    inner join   ZI_INTERCOBASISITEM_DOCS as ItemsDocs on HeaderBasis.Id = ItemsDocs.Id
{
  key _header.Id,
  key Providercompanycode,
  key Fiscalyear,
  key Fiscalperiod,
  key Ledger,
  key Glaccount,
  key Product,
  key Costcenter,
  key Profitcenter,
      PaymentType,
      _header.IsReleased,
      _header.Reportexecutedat,
      _header.CreatedAt,
      _header.CreatedBy,
      _header.Description,
      _header.KeyParams,
      _header.MinDateTime,
      _header.MaxDateTime,
//      _header.ProposalId,
//      _header.ProposalProduct,
      Companycodecurrency,
      Globalcurrency,
      Amountinglobalcurrency,
      Amountincompanycodecurrency,
      /* Associations */
      _header._proposals,
      _Product
}
