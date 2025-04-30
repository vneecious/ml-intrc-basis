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
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: #SINGLE
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_intercoCompanyCodeVH', element: 'CompanyCode' } } ]
  key Providercompanycode                                                      as CompanyCode,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZC_FISCALYEAR1', element: 'FiscalYear' },
                                              distinctValues: true } ]
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: #SINGLE
  key Fiscalyear,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'zc_poper_vh', element: 'Poper' },
                                              additionalBinding: [ { element: 'FiscalYear',
                                                                     localElement: 'Fiscalyear',
                                                                     usage: #FILTER_AND_RESULT } ] } ]
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: #SINGLE
  key Fiscalperiod,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'zi_ledger_sh', element: 'Rldnr' } } ]
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: #SINGLE
  key Ledger,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'zi_read_dom_paymenttype', element: 'value' },
                                          distinctValues: true } ]
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: #SINGLE
  key PaymentType,
      IsReleased,
      @Consumption.defaultValue: 'X'
      cast( case when IsReleased = 'X' then ' ' else 'X' end as abap_boolean ) as IsPending,
      CreatedBy,
      CreatedAt,
      Description
}
