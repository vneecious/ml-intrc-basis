/**
 * Main Interco Basis View
 *
 * Intercompany Basis View Hierarchy:
 * ZR_IntercoJEItemClass <------- CURRENT VIEW
 *  - ZI_IntercoJEItemClass
 *      - ZI_IntercoJEItemClassMatch
 *          - ZI_IntercoJEItemClassRule
 *              - ZI_IntercoJEItemPandL
 *                  - ZI_IntercoJEItem
 */
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Intercompany / Basis: Journal Entry Item Clasification'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XXL,
    dataClass: #MIXED
}
define root view entity ZR_IntercoJEItemClass
  as select from ZI_IntercoJEItemClass
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key Ledger,
  key FiscalPeriod,

      Segment,
      AccountingDocumentType,
      AccountingDocumentItem,
      DebitCreditCode,
      AccountingDocumentCategory,
      LedgerFiscalYear,
      ClearingAccountingDocument,
      ClearingJournalEntry,
      ClearingDate,
      ClearingDocFiscalYear,
      ClearingJournalEntryFiscalYear,
      IsOpenItemManaged,
      TransactionCurrency,
      AmountInTransactionCurrency,
      CompanyCodeCurrency,
      AmountInCompanyCodeCurrency,
      GlobalCurrency,
      AmountInGlobalCurrency,
      CreationDate,
      FiscalYearPeriod,
      OriginObjectType,

      GLAccount,
      ChartOfAccounts,
      PostingDate,
      CreationDateTime,
      ControllingArea,
      CostCenter,
      ProfitCenter,
      // Intercompany Specifics
      PaymentType,
      _IntercoCompanyCode.SiteCode,
      _IntercoCompanyCode.SiteName,
      CostCenterStandardHierArea,
      GLAccountParentNode,
      CCConsolidation,
      PCConsolidation,
      CCAllocation,
      zagrup_cuentas,
      zconsolidation,
      PandLL0Id,
      _MT005.L0                                                                                          as PandLL0Name,
      PandLL1Id,
      _MT005.L1                                                                                          as PandLL1Name,
      PandLL2Id,
      _MT005.L2                                                                                          as PandLL2Name,
      PandLL3Id,
      _MT005.L3                                                                                          as PandLL3Name,
      PandLL4Id,
      _MT005.L4                                                                                          as PandLL4Name,
      PandLL5Id,
      _MT005.L5                                                                                          as PandLL5Name,
      // Classification Rule
      _CurrentClassificationRule.ID                                                                      as ClassificationRuleID,
      cast(coalesce(ClassificationRuleExtID, '0000000000') as zint_rule_id)                              as ClassificationRuleExtID,
      _CurrentClassificationRule.RuleName,
      case when $projection.DescriptionBase = '' or  $projection.DescriptionBase is null
      then
        cast(coalesce(_CurrentClassificationRule.Product, '--') as matnr)
      else
      cast(coalesce(_CurrentBasisItem.Product, '--') as matnr)
      end                                                                                                as Concept,
      case when $projection.DescriptionBase = '' or  $projection.DescriptionBase is null
      then
        _CurrentClassificationRule._Product.ProductName
      else
              _CurrentBasisItem._Product.ProductName
      end                                                                                                as ConceptName,
      _CurrentClassificationRule.IsNotBillable                                                           as IsNotBillableFromMasterData,
      _CurrentClassificationRule.Score                                                                   as ClassificationRuleScore,
      // Exemption
      _CurrentExemption.ID                                                                               as ClassificationExemptionID,
      cast(coalesce(_CurrentExemption.ExternalID, '0000000000' ) as zint_exemption_id)                   as ClassificationExemptionExtID,
      _CurrentExemption.ExemptionName,
      cast( case when ClassificationExemptionExtID is not initial then 'X' else '' end as abap_boolean ) as IsNotBillableFromExemption,

      cast( case when ClassificationRuleExtID is not initial and _CurrentClassificationRule.IsNotBillable is initial then 'B'
                 when ClassificationRuleExtID is not initial and _CurrentClassificationRule.IsNotBillable is not initial then 'N'
                 when _CurrentExemption.ExternalID is not initial then 'E'
                 else '-' end as zint_billable_status )                                                  as IsBillable,
      case $projection.IsBillable
           when 'B' then 3
           when 'N' then 1
           when 'E' then 2
           else 0 end                                                                                    as IsBillableCriticality,
      // MVP 2 ->
      _CurrentBasisItem.Id                                                                               as IdBase,
      _CurrentBasisItem.Description                                                                      as DescriptionBase,
      _CurrentBasisItem.IsReleased                                                                       as IsReleased,
      // MVP 2 <-


      // TEMP INDEX ->
      CompanyCode                                                                                        as IndexCompanyCode,
      _CCAllocationParentNode._Text[ 1: Language = $session.system_language ].HierarchyNodeText          as IndexAllocation,
      _CCConsolidationParentNode._Text[ 1: Language = $session.system_language ].HierarchyNodeText       as IndexConsolidation,
      _CCStdParentNode._Text[1: Language = $session.system_language ].HierarchyNodeText                  as IndexArea,
      _PCHierarchyFlat._BusinessUnitText[1: Language = $session.system_language ].HierarchyNodeText      as IndexBusinessUnit,
      _MT005.L0                                                                                          as IndexPYL0,
      _MT005.L1                                                                                          as IndexPYL1,
      _MT005.L2                                                                                          as IndexPYLCLASIFICADO,
      CostCenter                                                                                         as IndexCostCenter,
      GLAccount                                                                                          as IndexAccountNro,
      concat(FiscalYear, substring(FiscalPeriod, 2, 2))                                                  as IndexMonth,
      AmountInGlobalCurrency                                                                             as IndexTotal,
      _CurrentClassificationRule._Product.ProductName                                                    as IndexFacturacion,
      _CurrentCostCenter,
      _CurrentProfitCenter
      // TEMP INDEX <-

}
