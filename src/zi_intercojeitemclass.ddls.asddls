/**
 * The purpose of this view is just add the association to ZI_IntercoClassificationRule and ZI_IntercoExemption.
 *
 * Intercompany Basis View Hierarchy:
 * ZR_IntercoJEItemClass
 *  - ZI_IntercoJEItemClass <------- CURRENT VIEW
 *      - ZI_IntercoJEItemClassMatch
 *          - ZI_IntercoJEItemClassRule
 *              - ZI_IntercoJEItemPandL
 *                  - ZI_IntercoJEItem
 */
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Intercompany / Basis: JE Item Classified for Interco'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XXL,
    dataClass: #MIXED
}
define view entity ZI_IntercoJEItemClass
  as select from ZI_IntercoJEItemClassMatch
  association [0..1] to ZI_IntercoClassificationRule as _CurrentClassificationRule on  _CurrentClassificationRule.RuleID = $projection.ClassificationRuleExtID
  association [0..1] to ZI_IntercoExemption          as _CurrentExemption          on  _CurrentExemption.ExternalID = $projection.ClassificationExemptionExtID
  association [0..1] to ZI_IntercoBasisFlat          as _CurrentBasisItem          on  _CurrentBasisItem.Ledger              = $projection.Ledger
                                                                                   and _CurrentBasisItem.Glaccount           = $projection.GLAccount
                                                                                   and _CurrentBasisItem.Costcenter          = $projection.CostCenter
                                                                                   and _CurrentBasisItem.Fiscalyear          = $projection.FiscalYear
                                                                                   and _CurrentBasisItem.Fiscalperiod        = $projection.FiscalPeriod
                                                                                   and _CurrentBasisItem.Providercompanycode = $projection.CompanyCode
                                                                                   and _CurrentBasisItem.Profitcenter        = $projection.ProfitCenter
                                                                                   and $projection.CreationDateTime          between _CurrentBasisItem.MinDateTime and _CurrentBasisItem.MaxDateTime
  //
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key FiscalPeriod,
  key AccountingDocument,
  key LedgerGLLineItem,
  key Ledger,

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

      ProfitCenter,
      PostingDate,
      CreationDateTime,
      CostCenter,
      ControllingArea,
      PaymentType,
      CostCenterStandardHierArea,
      ChartOfAccounts,
      GLAccount,
      GLAccountHierarchy,
      GLAccountHierarchyNode,
      GLAccountParentNode,
      CCConsolidationHierarchy,
      CCConsolidationHierarchyNode,
      CCConsolidationParentNode,
      CCConsolidation,
      PCConsolidationHierarchy,
      PCConsolidationHierarchyNode,
      PCConsolidationParentNode,
      PCConsolidation,
      CCAllocationHierarchy,
      CCAllocationHierarchyNode,
      CCAllocationParentNode,
      CCAllocation,
      zagrup_cuentas,
      zconsolidation,
      CCStdHierarchy,
      CCStdParentNode,
      PCBusinessUnit,
      PCSubBusinessUnitGroup,
      PCSubBusinessUnit,
      PandLL0Id,
      PandLL1Id,
      PandLL2Id,
      PandLL3Id,
      PandLL4Id,
      PandLL5Id,
      BestMatchClassificationRule,
      cast(substring(BestMatchClassificationRule, 1, 1) as abap.int4)      as ClassificationRuleScore,
      cast( substring(BestMatchClassificationRule, 3, 12) as zint_rule_id) as ClassificationRuleExtID,
      cast(substring(BestMatchExemption, 1, 1) as abap.int4)               as ClassificationExemptionScore,
      cast( substring(BestMatchExemption, 3, 12) as zint_rule_id)          as ClassificationExemptionExtID,
      /* Associations */
      _CCAllocationHierarchyNode,
      _CCConsolidationHierarchyNode,
      _CCConsolidationParentNode,
      //      _ClassificationRule,
      _GLAccountHierarchyNode,
      _GLAccountParentNode,
      _IntercoCompanyCode,
      _MT005,
      _PCConsolidationHierarchyNode,
      _PCConsolidationParentNode,
      _CurrentClassificationRule,
      _CurrentExemption,
      _CurrentBasisItem,

      _CCAllocationParentNode,
      _CurrentCostCenter,
      _CurrentProfitCenter,
      _CCStdHierarchyNode,
      _CCStdParentNode,
      _PCHierarchyFlat
}
